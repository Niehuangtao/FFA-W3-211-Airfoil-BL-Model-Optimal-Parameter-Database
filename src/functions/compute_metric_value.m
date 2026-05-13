function value = compute_metric_value(metricName, modelX, modelY, referenceX, referenceY)
%COMPUTE_METRIC_VALUE Compute one scalar curve mismatch value.

    metricName = normalize_metric_name(metricName);

    modelY = modelY(:);
    referenceY = referenceY(:);

    switch metricName
        case 'MSE'
            [modelCoeff, refCoeff] = resample_coefficients(modelY, referenceY, 500);
            value = mean((refCoeff - modelCoeff).^2) * 100;

        case 'ARE'
            [modelCoeff, refCoeff] = resample_coefficients(modelY, referenceY, 500);
            denom = max(abs(modelCoeff), eps);
            value = mean(abs((refCoeff - modelCoeff) ./ denom));

        case 'DTW'
            [modelCoeff, refCoeff] = resample_coefficients(modelY, referenceY, 500);
            value = dtw(modelCoeff, refCoeff);

        case 'NOA'
            [modelX, modelCoeff] = clean_polyshape_vertices(modelX, modelY);
            [refX, refCoeff] = clean_polyshape_vertices(referenceX, referenceY);

            if numel(modelX) < 3 || numel(refX) < 3
                value = realmax;
                return;
            end

            warningState = warning('off', 'MATLAB:polyshape:repairedBySimplify');
            cleanup = onCleanup(@() warning(warningState));
            modelShape = polyshape(modelX, modelCoeff, 'Simplify', true);
            referenceShape = polyshape(refX, refCoeff, 'Simplify', true);
            value = area(union(modelShape, referenceShape)) - area(intersect(modelShape, referenceShape));

        otherwise
            error('BL:UnknownMetric', 'Unsupported optimization metric: %s', metricName);
    end

    if ~isfinite(value)
        value = realmax;
    end
end
