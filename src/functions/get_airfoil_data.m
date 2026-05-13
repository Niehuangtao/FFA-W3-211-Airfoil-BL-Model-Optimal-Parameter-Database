function airfoilData = get_airfoil_data(setcase)
%GET_AIRFOIL_DATA Accept both the corrected and legacy setcase field names.

    if isfield(setcase, 'airfoilData')
        airfoilData = setcase.airfoilData;
    elseif isfield(setcase, 'airfoldata')
        airfoilData = setcase.airfoldata;
    else
        error('BL:MissingAirfoilData', 'setcase must contain airfoilData or airfoldata.');
    end
end
