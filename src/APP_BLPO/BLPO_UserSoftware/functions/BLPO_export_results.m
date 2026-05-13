function files = BLPO_export_results(result, outputFolder)
%BLPO_EXPORT_RESULTS Save parameters, metrics, comparison tables and figures.

arguments
    result struct
    outputFolder (1,1) string
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

defaults = BLPO_default_parameters();
if isfield(result, "initial")
    paramTable = table(defaults.labels(:), result.initial.param(:), result.param(:), ...
        'VariableNames', {'Parameter','InitialValue','OptimizedValue'});
else
    paramTable = table(defaults.labels(:), result.param(:), ...
        'VariableNames', {'Parameter','OptimizedValue'});
end

metricNames = ["Area_Cl"; "Area_Cm"; "Area_Objective"; "RMSE_Cl"; "RMSE_Cd"; "RMSE_Cm"];
metricValues = [result.metrics.areaCl; result.metrics.areaCm; result.metrics.total; ...
    result.metrics.rmseCl; result.metrics.rmseCd; result.metrics.rmseCm];
metricTable = table(metricNames, metricValues, 'VariableNames', {'Metric','Value'});

if isempty(result.reference.cd)
    if isfield(result, "initial")
        compareTable = table(result.reference.time, result.reference.alphaDeg, result.reference.cl, result.initial.fit.cl, result.fit.cl, ...
            'VariableNames', {'Time','AlphaDeg','ReferenceCl','InitialCl','ModelCl'});
    else
        compareTable = table(result.reference.time, result.reference.alphaDeg, result.reference.cl, result.fit.cl, ...
            'VariableNames', {'Time','AlphaDeg','ReferenceCl','ModelCl'});
    end
else
    if isfield(result, "initial")
        compareTable = table(result.reference.time, result.reference.alphaDeg, ...
            result.reference.cl, result.initial.fit.cl, result.fit.cl, ...
            result.reference.cd, result.initial.fit.cd, result.fit.cd, ...
            result.reference.cm, result.initial.fit.cm, result.fit.cm, ...
            'VariableNames', {'Time','AlphaDeg','ReferenceCl','InitialCl','ModelCl','ReferenceCd','InitialCd','ModelCd','ReferenceCm','InitialCm','ModelCm'});
    else
        compareTable = table(result.reference.time, result.reference.alphaDeg, ...
            result.reference.cl, result.fit.cl, result.reference.cd, result.fit.cd, result.reference.cm, result.fit.cm, ...
            'VariableNames', {'Time','AlphaDeg','ReferenceCl','ModelCl','ReferenceCd','ModelCd','ReferenceCm','ModelCm'});
    end
end

files.parameters = fullfile(outputFolder, "optimized_parameters.csv");
files.metrics = fullfile(outputFolder, "fit_metrics.csv");
files.comparison = fullfile(outputFolder, "comparison_data.csv");
files.mat = fullfile(outputFolder, "BLPO_result.mat");
files.figure = fullfile(outputFolder, "fit_comparison.png");

writetable(paramTable, files.parameters);
writetable(metricTable, files.metrics);
writetable(compareTable, files.comparison);
save(files.mat, "result");
BLPO_save_comparison_figure(result, files.figure);
end
