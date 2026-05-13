function response = calculate_bl_response(param, setcase)
%CALCULATE_BL_RESPONSE Run the BL model and extract the configured comparison window.

    airfoilData = get_airfoil_data(setcase);
    conditions = setcase.conditions;
    [~, CN, ~, CD, CL, CM, alpha] = cal_DS(param, conditions, airfoilData);

    idx = get_analysis_indices(setcase);

    response.full.time = conditions.t(:);
    response.full.alpha = rad2deg(alpha(:));
    response.full.CN = CN(:);
    response.full.CL = CL(:);
    response.full.CD = CD(:);
    response.full.CM = CM(:);

    response.time = conditions.t(idx)';
    response.alpha = rad2deg(alpha(idx))';
    response.CN = CN(idx);
    response.CL = CL(idx);
    response.CD = CD(idx);
    response.CM = CM(idx);
end
