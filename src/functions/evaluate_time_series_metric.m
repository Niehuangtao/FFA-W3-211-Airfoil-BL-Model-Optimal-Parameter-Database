function fitness = evaluate_time_series_metric(model, reference, metricName, target)
%EVALUATE_TIME_SERIES_METRIC Compare one time-series coefficient target.

    modelTime = model.full.time(:);
    validTime = reference.time >= modelTime(1) & reference.time <= modelTime(end);

    if nnz(validTime) < 3
        fitness = realmax;
        return;
    end

    if nargin < 4 || isempty(target)
        target = reference.targets{1};
    end

    target = upper(strtrim(char(target)));
    refTime = reference.time(validTime);
    modelAlpha = interp1(modelTime, model.full.alpha, refTime, 'linear');
    refCoeff = reference.(target);
    refCoeff = refCoeff(validTime);
    modelCoeff = interp1(modelTime, model.full.(target), refTime, 'linear');

    switch normalize_metric_name(metricName)
        case 'NOA'
            fitness = compute_metric_value(metricName, modelAlpha, modelCoeff, modelAlpha, refCoeff);
        otherwise
            fitness = compute_metric_value(metricName, refTime, modelCoeff, refTime, refCoeff);
    end
end
