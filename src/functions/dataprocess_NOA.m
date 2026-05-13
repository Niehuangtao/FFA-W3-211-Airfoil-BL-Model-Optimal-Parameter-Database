function Error_NOA = dataprocess_NOA(ARE_data, DTW_data, NOA_data, ~, exp_data)
    ARE_NOA = area_overlap_NOA(ARE_data(:, 1)', ARE_data(:, 2), exp_data(:, 1), exp_data(:, 2));
    DTW_NOA = area_overlap_NOA(DTW_data(:, 1)', DTW_data(:, 2), exp_data(:, 1), exp_data(:, 2));
    NOA_NOA = area_overlap_NOA(NOA_data(:, 1)', NOA_data(:, 2), exp_data(:, 1), exp_data(:, 2));

    areaExp = polyshape(exp_data(:, 1), exp_data(:, 2));
    S_exp = area(areaExp);
    Error_NOA = [ARE_NOA / S_exp, DTW_NOA / S_exp, NOA_NOA / S_exp];
end
