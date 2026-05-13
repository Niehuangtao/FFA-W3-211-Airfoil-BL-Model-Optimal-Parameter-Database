function [paraLocal, result] = run_optimal_metric(metricName, paraDefault, lb, ub, setcase, gaConfig, outputDir)
%RUN_OPTIMAL_METRIC Run GA optimization for one objective metric.

    if nargin < 6 || isempty(gaConfig)
        gaConfig = struct();
    end
    if nargin < 7 || isempty(outputDir)
        outputDir = pwd;
    end

    metricName = normalize_metric_name(metricName);
    paraDefault = paraDefault(:)';
    lb = lb(:)';
    ub = ub(:)';
    nParameters = numel(paraDefault);
    reference = get_reference_data(setcase);
    if strcmp(reference.type, 'timeSeries') && numel(reference.targets) > 1
        [paraLocal, result] = run_time_series_sequence( ...
            metricName, paraDefault, lb, ub, setcase, gaConfig, nParameters, reference.targets);
    else
        if strcmp(reference.type, 'timeSeries') && isscalar(reference.targets)
            setcase.activeTimeSeriesTarget = reference.targets{1};
        end
        [paraLocal, stageResult] = run_metric_stage( ...
            metricName, paraDefault, lb, ub, setcase, gaConfig, nParameters, '');
        result = finalize_single_stage_result(metricName, paraLocal, stageResult, reference);
    end

    fitnessOpt = result.fitness_opt;
    defaultFitness = result.default_fitness;
    exitflag = result.exitflag;
    gaOutput = result.gaOutput;

    parameterNames = {'A1', 'b1', 'A2', 'b2', 'Tp', 'Tf0', 'Tvl', 'Tv0', 'yita'};
    fprintf('\nDefault fitness = %.6f | Optimized fitness = %.6f\n', defaultFitness, fitnessOpt);
    for iParameter = 1:nParameters
        fprintf('%5s : default = %.6f | optimized = %.6f\n', ...
            parameterNames{iParameter}, paraDefault(iParameter), paraLocal(iParameter));
    end

    outputFile = fullfile(outputDir, sprintf('BL_reference_optimal_parameters_%s.mat', metricName));
    result.outputFile = outputFile;
    save(outputFile, 'paraLocal', 'fitnessOpt', 'defaultFitness', 'exitflag', 'gaOutput', 'result');
    fprintf('Saved optimized parameters to: %s\n', outputFile);
end

function [paraLocal, result] = run_time_series_sequence(metricName, paraDefault, lb, ub, setcase, gaConfig, nParameters, stageTargets)
    currentParam = paraDefault;
    nStages = numel(stageTargets);
    stageResults = repmat(empty_stage_result(), nStages, 1);

    fprintf('\n===== BL parameter optimization started: %s | sequential time-series =====\n', metricName);
    fprintf('Stage order: %s\n', strjoin(stageTargets, ' -> '));

    sequenceTimer = tic;
    for iStage = 1:nStages
        stageTarget = stageTargets{iStage};
        stageSetcase = setcase;
        stageSetcase.activeTimeSeriesTarget = stageTarget;
        stageLabel = sprintf('stage %d/%d', iStage, nStages);

        [currentParam, stageResults(iStage)] = run_metric_stage( ...
            metricName, currentParam, lb, ub, stageSetcase, gaConfig, nParameters, stageLabel);

        fprintf('Completed %s target %s: %.8f -> %.8f\n', ...
            upper(stageLabel), stageTarget, ...
            stageResults(iStage).defaultFitness, stageResults(iStage).fitnessOpt);
    end

    paraLocal = currentParam;
    result.metric = metricName;
    result.referenceType = 'timeSeries';
    result.sequenceMode = 'sequentialTimeSeries';
    result.stageTargets = stageTargets;
    result.stages = stageResults;
    result.para_local = paraLocal;
    result.default_fitness = stageResults(end).defaultFitness;
    result.fitness_opt = stageResults(end).fitnessOpt;
    result.initialDefaultFitness = stageResults(1).defaultFitness;
    result.stageDefaultFitness = [stageResults.defaultFitness];
    result.stageOptimizedFitness = [stageResults.fitnessOpt];
    result.exitflag = stageResults(end).exitflag;
    result.gaOutput = stageResults(end).gaOutput;
    result.elapsedSeconds = toc(sequenceTimer);

    fprintf('===== Sequential optimization finished: %s final target = %s fitness = %.8f =====\n', ...
        metricName, stageTargets{end}, result.fitness_opt);
end

function result = finalize_single_stage_result(metricName, paraLocal, stageResult, reference)
    stageTargets = {stageResult.target};
    if strcmp(reference.type, 'timeSeries') && isfield(reference, 'targets') && ~isempty(reference.targets)
        stageTargets = reference.targets;
    end

    result.metric = metricName;
    result.referenceType = reference.type;
    result.sequenceMode = 'singleStage';
    result.stageTargets = stageTargets;
    result.stages = stageResult;
    result.para_local = paraLocal;
    result.fitness_opt = stageResult.fitnessOpt;
    result.default_fitness = stageResult.defaultFitness;
    result.exitflag = stageResult.exitflag;
    result.gaOutput = stageResult.gaOutput;
    result.elapsedSeconds = stageResult.elapsedSeconds;
end

function [paraLocal, stageResult] = run_metric_stage(metricName, startParam, lb, ub, setcase, gaConfig, nParameters, stageLabel)
    targetName = '';
    if isfield(setcase, 'activeTimeSeriesTarget')
        targetName = upper(strtrim(char(setcase.activeTimeSeriesTarget)));
    end

    fitnessFcn = @(param) fitness_metric(param, setcase, metricName);
    defaultFitness = fitnessFcn(startParam);

    nonlcon = [];
    if get_struct_value(gaConfig, 'EnforceDefaultImprovement', false)
        nonlcon = @(param) fitness_constraint_metric(param, defaultFitness, setcase, metricName);
    end

    options = build_ga_options(gaConfig, startParam);

    if isempty(stageLabel)
        fprintf('\n===== BL parameter optimization started: %s =====\n', metricName);
    else
        fprintf('\n===== BL parameter optimization started: %s | %s | %s =====\n', ...
            metricName, upper(stageLabel), targetName);
    end

    elapsedTimer = tic;
    [paraLocal, fitnessOpt, exitflag, gaOutput] = ga( ...
        fitnessFcn, nParameters, [], [], [], [], lb, ub, nonlcon, options);
    elapsedSeconds = toc(elapsedTimer);

    if isempty(stageLabel)
        fprintf('===== Optimization finished: %s fitness = %.8f =====\n', metricName, fitnessOpt);
    else
        fprintf('===== Optimization finished: %s | %s | %s fitness = %.8f =====\n', ...
            metricName, upper(stageLabel), targetName, fitnessOpt);
    end

    stageResult = struct( ...
        'name', stageLabel, ...
        'target', targetName, ...
        'startParam', startParam, ...
        'para_local', paraLocal, ...
        'defaultFitness', defaultFitness, ...
        'fitnessOpt', fitnessOpt, ...
        'exitflag', exitflag, ...
        'gaOutput', gaOutput, ...
        'elapsedSeconds', elapsedSeconds);
end

function options = build_ga_options(gaConfig, initialPopulation)
    options = optimoptions('ga', ...
        'PopulationSize', get_struct_value(gaConfig, 'PopulationSize', 512), ...
        'MaxGenerations', get_struct_value(gaConfig, 'MaxGenerations', 50), ...
        'FunctionTolerance', get_struct_value(gaConfig, 'FunctionTolerance', 1e-4), ...
        'ConstraintTolerance', get_struct_value(gaConfig, 'ConstraintTolerance', 1e-4), ...
        'Display', get_struct_value(gaConfig, 'Display', 'iter'), ...
        'InitialPopulationMatrix', initialPopulation, ...
        'UseParallel', get_struct_value(gaConfig, 'UseParallel', true));
end

function stageResult = empty_stage_result()
    stageResult = struct( ...
        'name', '', ...
        'target', '', ...
        'startParam', [], ...
        'para_local', [], ...
        'defaultFitness', NaN, ...
        'fitnessOpt', NaN, ...
        'exitflag', NaN, ...
        'gaOutput', struct(), ...
        'elapsedSeconds', NaN);
end
