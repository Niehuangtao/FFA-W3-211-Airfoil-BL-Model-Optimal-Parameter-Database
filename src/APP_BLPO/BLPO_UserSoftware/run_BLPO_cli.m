function run_BLPO_cli()
%RUN_BLPO_CLI Command-line workflow for user-defined BLPO cases.

root = fileparts(mfilename("fullpath"));
addpath(fullfile(root, "functions"));

fprintf("\nBLPO dynamic-stall parameter optimization\n");
fprintf("Reference data format: 2 columns [time, Cl] or 4 columns [time, Cl, Cd, Cm].\n\n");

cfg = BLPO_sample_config();
cfg.meanAngleDeg = local_prompt_number("Mean angle alpha0 (deg)", cfg.meanAngleDeg);
cfg.amplitudeDeg = local_prompt_number("Pitch amplitude A (deg)", cfg.amplitudeDeg);
cfg.reducedFrequency = local_prompt_number("Reduced frequency k", cfg.reducedFrequency);
cfg.U = local_prompt_number("Incoming velocity U (m/s)", cfg.U);
cfg.Re = local_prompt_number("Reynolds number Re", cfg.Re);
cfg.cycles = local_prompt_number("Number of simulated cycles", cfg.cycles);
cfg.stepsPerCycle = local_prompt_number("Steps per cycle", cfg.stepsPerCycle);

defaultRef = fullfile(root, "sample_data", "sample_reference_experiment_2col.csv");
referenceFile = input("Reference data file [" + string(defaultRef) + "]: ", "s");
if strlength(strtrim(referenceFile)) == 0
    referenceFile = defaultRef;
end

mode = string(input("Optimization mode full/lag/cl/cm [full]: ", "s"));
if strlength(strtrim(mode)) == 0
    mode = "full";
end

popSize = local_prompt_number("GA population size", 24);
maxGen = local_prompt_number("GA max generations", 8);
outputFolder = input("Output folder [" + string(fullfile(root, "output")) + "]: ", "s");
if strlength(strtrim(outputFolder)) == 0
    outputFolder = fullfile(root, "output");
end

setcase = BLPO_build_setcase(cfg, string(referenceFile));
[bestParam, result, history] = BLPO_optimize(setcase, ...
    Mode=mode, PopulationSize=popSize, MaxGenerations=maxGen, RunLocalSearch=true);
files = BLPO_export_results(result, string(outputFolder));

fprintf("\nInitial area objective: %.6g\n", history.initialFitness);
fprintf("Final area objective:   %.6g\n", result.metrics.total);
fprintf("Area Cl/Cm:             %.6g / %.6g\n", result.metrics.areaCl, result.metrics.areaCm);
fprintf("RMSE Cl/Cd/Cm:          %.6g / %.6g / %.6g\n", result.metrics.rmseCl, result.metrics.rmseCd, result.metrics.rmseCm);
fprintf("Results saved to:  %s\n", outputFolder);
disp(files);
disp(bestParam);
end

function value = local_prompt_number(label, defaultValue)
answer = input(label + " [" + string(defaultValue) + "]: ", "s");
if strlength(strtrim(answer)) == 0
    value = defaultValue;
else
    value = str2double(answer);
    if ~isfinite(value)
        error("Invalid numeric input for %s.", label);
    end
end
end
