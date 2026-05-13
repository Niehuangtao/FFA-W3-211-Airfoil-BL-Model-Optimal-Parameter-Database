function reference = get_reference_data(setcase)
%GET_REFERENCE_DATA Return cached reference data.

    if isfield(setcase, 'reference') && isfield(setcase.reference, 'type')
        reference = setcase.reference;
        return;
    end

    persistent cachedPath cachedReference

    referencePath = setcase.referenceDataPath;
    if isfield(setcase, 'referenceConfig')
        referenceConfig = setcase.referenceConfig;
    else
        referenceConfig = struct();
    end
    cacheKey = build_reference_cache_key(referencePath, referenceConfig);

    if ~isempty(cachedPath) && strcmp(cachedPath, cacheKey)
        reference = cachedReference;
        return;
    end

    reference = read_reference_data(referencePath, referenceConfig);

    cachedPath = cacheKey;
    cachedReference = reference;
end

function cacheKey = build_reference_cache_key(referencePath, referenceConfig)
    referenceType = lower(strtrim(char(get_struct_value(referenceConfig, 'type', 'alphaCoefficient'))));
    coefficientName = upper(strtrim(char(get_struct_value(referenceConfig, 'coefficient', 'CN'))));
    stageTargets = get_struct_value(referenceConfig, 'timeSeriesTargets', {'CL'});

    if ischar(stageTargets) || isstring(stageTargets)
        stageTargets = cellstr(string(stageTargets));
    end

    stageTargets = cellfun(@(x) upper(strtrim(char(x))), stageTargets, 'UniformOutput', false);
    targetKey = strjoin(stageTargets, ',');

    cacheKey = sprintf('%s|%s|%s|%s', referencePath, referenceType, coefficientName, targetKey);
end
