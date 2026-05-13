function fitness = fitness_metric(param, setcase, metricName)
%FITNESS_METRIC Shared objective function for BL optimization metrics.

    metricName = normalize_metric_name(metricName);
    model = calculate_bl_response(param, setcase);
    reference = get_reference_data(setcase);

    switch reference.type
        case 'alphaCoefficient'
            coefficientName = reference.yName;
            modelCoeff = get_model_coefficient(model, coefficientName);
            fitness = compute_metric_value(metricName, model.alpha, modelCoeff, reference.alpha, reference.coeff);

        case 'timeSeries'
            target = reference.targets{1};
            if isfield(setcase, 'activeTimeSeriesTarget')
                target = setcase.activeTimeSeriesTarget;
            end
            fitness = evaluate_time_series_metric(model, reference, metricName, target);

        otherwise
            error('BL:UnknownReferenceType', 'Unsupported reference data type: %s', reference.type);
    end

    if ~isfinite(fitness)
        fitness = realmax;
    end
end
