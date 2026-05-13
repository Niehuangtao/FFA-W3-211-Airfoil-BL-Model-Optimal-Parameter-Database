function setcase = build_bl_setcase(caseConfig, fileConfig, referenceConfig)
%BUILD_BL_SETCASE Build all model inputs once and keep reusable data cached.

    if nargin < 3 || isempty(referenceConfig)
        referenceConfig = struct();
    end

    conditions = input_condition(caseConfig.meanangle, caseConfig.averageangle, caseConfig);
    airfoilData = input_afdata(fileConfig.airfoil, caseConfig.chord);

    setcase.meanangle = caseConfig.meanangle;
    setcase.averageangle = caseConfig.averageangle;
    setcase.conditions = conditions;
    setcase.airfoilData = airfoilData;
    setcase.airfoldata = airfoilData;  % Keep legacy field name for old functions.
    setcase.referenceDataPath = fileConfig.reference;
    setcase.referenceConfig = referenceConfig;
    setcase.windowCycles = caseConfig.windowCycles;

    setcase.reference = read_reference_data(fileConfig.reference, referenceConfig);
end
