function idx = get_analysis_indices(setcase)
%GET_ANALYSIS_INDICES Return the cycle window used for objective comparison.

    conditions = setcase.conditions;
    nSteps = conditions.n_steps;

    if isfield(setcase, 'windowCycles') && numel(setcase.windowCycles) == 2
        windowCycles = setcase.windowCycles;
    else
        windowCycles = [7 8];
    end

    if isfield(conditions, 'nCycles')
        nCycles = conditions.nCycles;
    else
        nCycles = 10;
    end

    startIdx = max(1, round(windowCycles(1) / nCycles * nSteps));
    endIdx = min(nSteps, round(windowCycles(2) / nCycles * nSteps));

    if startIdx >= endIdx
        error('BL:InvalidWindow', 'Invalid analysis window [%g %g].', windowCycles(1), windowCycles(2));
    end

    idx = startIdx:endIdx;
end
