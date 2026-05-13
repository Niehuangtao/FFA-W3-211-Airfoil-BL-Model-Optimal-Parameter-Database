function [bestParam, result, history] = BLPO_optimize(setcase, options)
%BLPO_OPTIMIZE Optimize BL parameters against user reference data.

arguments
    setcase struct
    options.Mode (1,1) string {mustBeMember(options.Mode, ["full","lag","cl","cm"])} = "full"
    options.PopulationSize (1,1) double = 48
    options.MaxGenerations (1,1) double = 20
    options.UseParallel (1,1) logical = false
    options.RunLocalSearch (1,1) logical = true
    options.Display (1,1) string = "iter"
    options.ProgressFcn = []
end

defaults = BLPO_default_parameters();
baseParam = defaults.vector;
progressFcn = options.ProgressFcn;
maxGenerations = max(1, round(options.MaxGenerations));
populationSize = max(8, round(options.PopulationSize));

if options.Mode == "full"
    stages = ["lag", "cl", "cm"];
else
    stages = options.Mode;
end

history = struct("initialFitness", BLPO_objective(baseParam, setcase), ...
                 "gaFitness", NaN, "localFitness", NaN, ...
                 "finalFitness", NaN, "mode", options.Mode, ...
                 "stages", []);

currentParam = baseParam;
local_notify(progressFcn, 0.05, "Initializing optimizer");

for stageIndex = 1:numel(stages)
    stageName = stages(stageIndex);
    [idx, lb, ub] = local_mode_bounds(defaults, stageName);
    [currentParam, stageHistory] = local_run_stage(currentParam, idx, lb, ub, ...
        setcase, stageName, stageIndex, numel(stages), populationSize, ...
        maxGenerations, options, progressFcn);
    history.stages = [history.stages; stageHistory]; %#ok<AGROW>
end

if ~isempty(history.stages)
    history.gaFitness = history.stages(end).gaFitness;
    history.localFitness = history.stages(end).localFitness;
    history.finalFitness = BLPO_objective(currentParam, setcase);
end

bestParam = currentParam;
local_notify(progressFcn, 0.96, "Evaluating optimized parameters");
result = BLPO_evaluate(bestParam, setcase);
initialResult = BLPO_evaluate(baseParam, setcase);
result.initial.param = baseParam;
result.initial.model = initialResult.model;
result.initial.fit = initialResult.fit;
result.initial.metrics = initialResult.metrics;
result.history = history;
local_notify(progressFcn, 1.00, "Optimization complete");
end

function [param, stageHistory] = local_run_stage(startParam, idx, lb, ub, setcase, ...
    stageName, stageIndex, stageCount, populationSize, maxGenerations, options, progressFcn)

stageStart = 0.08 + 0.84 * (stageIndex - 1) / stageCount;
stageSpan = 0.84 / stageCount;
target = local_stage_target(stageName);
if target == "cm" && ~setcase.reference.hasCm
    stageHistory = local_skipped_stage(startParam, setcase, stageName);
    param = startParam;
    local_notify(progressFcn, stageStart + stageSpan, sprintf("Stage %d/%d skipped: %s reference data missing", stageIndex, stageCount, stageName));
    return;
end
fitness = @(x) BLPO_objective(local_merge(startParam, idx, x), setcase, Target=target);
local_notify(progressFcn, stageStart, sprintf("Stage %d/%d: optimizing %s area", stageIndex, stageCount, target));

gaOptions = optimoptions("ga", ...
    "PopulationSize", populationSize, ...
    "MaxGenerations", maxGenerations, ...
    "FunctionTolerance", 1e-5, ...
    "ConstraintTolerance", 1e-5, ...
    "Display", char(options.Display), ...
    "UseParallel", options.UseParallel);
initialPopulation = local_initial_population(startParam(idx), lb, ub);
if ~isempty(initialPopulation)
    gaOptions.InitialPopulationMatrix = initialPopulation;
end
if ~isempty(progressFcn)
    gaOptions.OutputFcn = @(gaOptions, state, flag) local_ga_progress(progressFcn, ...
        maxGenerations, stageName, stageIndex, stageCount, stageStart, stageSpan, gaOptions, state, flag);
end

[xBest, fBest] = ga(fitness, numel(idx), [], [], [], [], lb, ub, [], gaOptions);
gaFitness = fBest;
local_notify(progressFcn, stageStart + 0.78 * stageSpan, sprintf("%s GA complete", stageName));

localFitness = NaN;
initialFitness = BLPO_objective(startParam, setcase, Target=target);
if options.RunLocalSearch
    localOptions = optimoptions("fmincon", ...
        "Algorithm", "sqp", ...
        "Display", char(options.Display), ...
        "MaxFunctionEvaluations", 200, ...
        "OptimalityTolerance", 1e-5, ...
        "StepTolerance", 1e-6);
    if ~isempty(progressFcn)
        localOptions.OutputFcn = @(x, optimValues, state) local_fmincon_progress(progressFcn, ...
            stageName, stageIndex, stageCount, stageStart, stageSpan, optimValues, state);
    end
    local_notify(progressFcn, stageStart + 0.82 * stageSpan, sprintf("%s local search", stageName));
    [xBest, fBest] = fmincon(fitness, xBest, [], [], [], [], lb, ub, [], localOptions);
    localFitness = fBest;
end

candidateParam = local_merge(startParam, idx, xBest);
candidateFitness = BLPO_objective(candidateParam, setcase, Target=target);
accepted = candidateFitness <= initialFitness;
if accepted
    param = candidateParam;
    finalFitness = candidateFitness;
else
    param = startParam;
    finalFitness = initialFitness;
end
local_notify(progressFcn, stageStart + stageSpan, sprintf("Stage %d/%d complete: %s", stageIndex, stageCount, stageName));
stageHistory = struct("name", stageName, ...
    "target", target, ...
    "skipped", false, ...
    "accepted", accepted, ...
    "initialFitness", initialFitness, ...
    "gaFitness", gaFitness, ...
    "localFitness", localFitness, ...
    "finalFitness", finalFitness);
end

function target = local_stage_target(stageName)
if stageName == "cm"
    target = "cm";
else
    target = "cl";
end
end

function stageHistory = local_skipped_stage(param, setcase, stageName)
stageHistory = struct("name", stageName, ...
    "target", "cm", ...
    "skipped", true, ...
    "accepted", false, ...
    "initialFitness", BLPO_objective(param, setcase), ...
    "gaFitness", NaN, ...
    "localFitness", NaN, ...
    "finalFitness", BLPO_objective(param, setcase));
end

function initialPopulation = local_initial_population(x0, lb, ub)
x0 = double(x0(:))';
lb = double(lb(:))';
ub = double(ub(:))';
if all(isfinite(x0)) && all(x0 >= lb) && all(x0 <= ub)
    initialPopulation = x0;
else
    initialPopulation = [];
end
end

function [idx, lb, ub] = local_mode_bounds(defaults, mode)
switch mode
    case "lag"
        idx = 1:4;
        lb = defaults.lbLag;
        ub = defaults.ubLag;
    case "cl"
        idx = 5:13;
        lb = defaults.lbCl;
        ub = defaults.ubCl;
    case "cm"
        idx = 14:24;
        lb = defaults.lbCm;
        ub = defaults.ubCm;
    otherwise
        error("BLPO:UnsupportedMode", "Unsupported optimization mode: %s", mode);
end
end

function merged = local_merge(baseParam, idx, x)
merged = baseParam;
merged(idx) = x;
end

function [state, gaOptions, optchanged] = local_ga_progress(progressFcn, maxGenerations, ...
    stageName, stageIndex, stageCount, stageStart, stageSpan, gaOptions, state, flag)
optchanged = false;
generation = 0;
if isfield(state, "Generation")
    generation = state.Generation;
end
fraction = stageStart + 0.75 * stageSpan * min(1, generation / maxGenerations);
switch string(flag)
    case "init"
        local_notify(progressFcn, stageStart, sprintf("Stage %d/%d %s GA initialized", stageIndex, stageCount, stageName));
    case "iter"
        local_notify(progressFcn, fraction, sprintf("Stage %d/%d %s GA generation %d / %d", ...
            stageIndex, stageCount, stageName, generation, maxGenerations));
    case "done"
        local_notify(progressFcn, stageStart + 0.78 * stageSpan, sprintf("Stage %d/%d %s GA finished", ...
            stageIndex, stageCount, stageName));
end
end

function stop = local_fmincon_progress(progressFcn, stageName, stageIndex, stageCount, ...
    stageStart, stageSpan, optimValues, state)
stop = false;
iteration = 0;
if isfield(optimValues, "iteration")
    iteration = optimValues.iteration;
end
fraction = stageStart + stageSpan * (0.82 + 0.13 * min(1, iteration / 20));
switch string(state)
    case "init"
        local_notify(progressFcn, stageStart + 0.82 * stageSpan, sprintf("Stage %d/%d %s local search initialized", ...
            stageIndex, stageCount, stageName));
    case "iter"
        local_notify(progressFcn, fraction, sprintf("Stage %d/%d %s local search iteration %d", ...
            stageIndex, stageCount, stageName, iteration));
    case "done"
        local_notify(progressFcn, stageStart + 0.95 * stageSpan, sprintf("Stage %d/%d %s local search finished", ...
            stageIndex, stageCount, stageName));
end
end

function local_notify(progressFcn, fraction, message)
if isempty(progressFcn)
    return;
end
try
    progressFcn(max(0, min(1, fraction)), string(message));
catch
end
end
