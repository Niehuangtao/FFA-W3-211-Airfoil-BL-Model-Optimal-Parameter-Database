clearvars;
close all;
clc;

projectRoot = fileparts(mfilename('fullpath'));
if isempty(projectRoot)
    projectRoot = pwd;
end

addpath(fullfile(projectRoot, 'functions'));
rng(1, 'twister');

config = bl_default_config(projectRoot);
setcase = build_bl_setcase(config.case, config.files, config.reference);
validate_bl_inputs(config, setcase);

results = struct();
collections = struct();

for iMetric = 1:numel(config.metrics)
    metricName = config.metrics{iMetric};

    [paraLocal, results.(metricName)] = run_optimal_metric( ...
        metricName, ...
        config.parameters.default, ...
        config.parameters.lower, ...
        config.parameters.upper, ...
        setcase, ...
        config.ga, ...
        config.outputDir);

    collections.(metricName) = compare_optimal_result( ...
        metricName, paraLocal, config.parameters.default, setcase, config.outputDir);
end

plot_bl_metric_comparison(collections, setcase, config.plot, config.outputDir);

disp('BL optimization workflow completed.');
