function validate_bl_inputs(config, setcase)
%VALIDATE_BL_INPUTS Fail fast on inconsistent configuration.

    if exist(config.files.airfoil, 'file') ~= 2
        error('BL:MissingAirfoilFile', 'Airfoil file not found: %s', config.files.airfoil);
    end

    if exist(config.files.reference, 'file') ~= 2
        error('BL:MissingReferenceFile', 'Reference data file not found: %s', config.files.reference);
    end

    lower = config.parameters.lower;
    upper = config.parameters.upper;
    defaultParameters = config.parameters.default;

    if ~(numel(lower) == numel(upper) && numel(defaultParameters) == numel(lower))
        error('BL:ParameterSizeMismatch', 'Default parameters and bounds must have equal length.');
    end

    if any(lower > upper)
        error('BL:InvalidBounds', 'Each lower bound must be less than or equal to its upper bound.');
    end

    if any(defaultParameters < lower) || any(defaultParameters > upper)
        error('BL:DefaultOutOfBounds', 'Default parameters must be inside the optimization bounds.');
    end

    if ~isfield(setcase.reference, 'type') || isempty(setcase.reference.x) || isempty(setcase.reference.y)
        error('BL:EmptyReferenceData', 'Reference data is empty.');
    end
end
