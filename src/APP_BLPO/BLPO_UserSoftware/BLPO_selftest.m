function BLPO_selftest()
%BLPO_SELFTEST Verify sample data, evaluation, short optimization and export.

root = fileparts(mfilename("fullpath"));
addpath(fullfile(root, "functions"));

BLPO_make_sample_data();
cfg = BLPO_sample_config();
params = BLPO_default_parameters();

expFile = string(fullfile(root, "sample_data", "sample_reference_experiment_2col.csv"));
cfdFile = string(fullfile(root, "sample_data", "sample_reference_cfd_4col.csv"));

setcaseExp = BLPO_build_setcase(cfg, expFile);
resultExp = BLPO_evaluate(params.vector, setcaseExp);
fprintf("Experiment objective: %.6g\n", resultExp.metrics.total);

setcaseCfd = BLPO_build_setcase(cfg, cfdFile);
resultCfd = BLPO_evaluate(params.vector, setcaseCfd);
fprintf("CFD objective: %.6g\n", resultCfd.metrics.total);

[~, resultOpt, history] = BLPO_optimize(setcaseExp, ...
    Mode="lag", PopulationSize=8, MaxGenerations=1, RunLocalSearch=false, Display="off");
fprintf("Short optimization objective: %.6g -> %.6g\n", history.initialFitness, resultOpt.metrics.total);

files = BLPO_export_results(resultCfd, string(fullfile(root, "output", "selftest")));
disp(files);
disp("BLPO selftest completed.");
end
