function metricName = normalize_metric_name(metricName)
%NORMALIZE_METRIC_NAME Normalize and validate metric identifiers.

    metricName = upper(strtrim(char(metricName)));
    validMetrics = {'MSE', 'ARE', 'DTW', 'NOA'};

    if ~any(strcmp(metricName, validMetrics))
        error('BL:UnknownMetric', 'Unsupported optimization metric: %s', metricName);
    end
end
