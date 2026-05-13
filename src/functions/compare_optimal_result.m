function collection = compare_optimal_result(metricName, paraLocal, paraDefault, setcase, outputDir)
%COMPARE_OPTIMAL_RESULT Collect optimized, default, and reference curves.

    if nargin < 5 || isempty(outputDir)
        outputDir = pwd;
    end

    metricName = normalize_metric_name(metricName);

    optimized = calculate_bl_response(paraLocal, setcase);
    defaultResponse = calculate_bl_response(paraDefault, setcase);
    reference = get_reference_data(setcase);

    switch reference.type
        case 'alphaCoefficient'
            coefficientName = reference.yName;
            metricData = [optimized.alpha(:), get_model_coefficient(optimized, coefficientName)];
            defaultData = [defaultResponse.alpha(:), get_model_coefficient(defaultResponse, coefficientName)];
            expData = [reference.alpha(:), reference.coeff(:)];

            collection.mode = 'alphaCoefficient';
            collection.xLabel = 'Angle of attack (deg)';
            collection.yLabel = coefficientName;

        case 'timeSeries'
            primaryTarget = reference.targets{end};
            [expData, defaultData, metricData, timeSeries] = build_time_series_data( ...
                reference, defaultResponse, optimized, primaryTarget);

            collection.mode = 'timeSeries';
            collection.xLabel = 'Time (s)';
            collection.yLabel = primaryTarget;
            collection.primaryTarget = primaryTarget;
            collection.optimizationTargets = reference.targets;
            collection.timeSeries = timeSeries;

        otherwise
            error('BL:UnknownReferenceType', 'Unsupported reference data type: %s', reference.type);
    end

    collection.metric = metricName;
    collection.optimized = metricData;
    collection.default = defaultData;
    collection.reference = expData;
    collection.referenceInfo = reference;

    dataFile = fullfile(outputDir, sprintf('data_collection_%s.mat', metricName));
    metricVariable = sprintf('%s_data', metricName);
    savePayload = struct();
    savePayload.default_data = defaultData;
    savePayload.exp_data = expData;
    savePayload.(metricVariable) = metricData;
    savePayload.collection = collection;
    save(dataFile, '-struct', 'savePayload');
end

function [expData, defaultData, metricData, timeSeries] = build_time_series_data(reference, defaultResponse, optimized, primaryTarget)
    modelTime = optimized.full.time(:);
    validTime = reference.time >= modelTime(1) & reference.time <= modelTime(end);
    time = reference.time(validTime);

    refCoeff = reference.(primaryTarget);
    refCoeff = refCoeff(validTime);
    defaultCoeff = interp1(defaultResponse.full.time(:), defaultResponse.full.(primaryTarget), time, 'linear');
    optimizedCoeff = interp1(optimized.full.time(:), optimized.full.(primaryTarget), time, 'linear');

    expData = [time(:), refCoeff(:)];
    defaultData = [time(:), defaultCoeff(:)];
    metricData = [time(:), optimizedCoeff(:)];

    timeSeries.time = time(:);
    for iTarget = 1:numel(reference.targets)
        target = reference.targets{iTarget};
        targetRef = reference.(target);
        timeSeries.reference.(target) = targetRef(validTime);
        timeSeries.default.(target) = interp1(defaultResponse.full.time(:), defaultResponse.full.(target), time, 'linear');
        timeSeries.optimized.(target) = interp1(optimized.full.time(:), optimized.full.(target), time, 'linear');
    end
end
