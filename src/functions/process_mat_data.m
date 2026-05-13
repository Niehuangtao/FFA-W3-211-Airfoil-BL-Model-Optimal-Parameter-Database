function Error_S = process_mat_data(S_ARE, S_DTW, S_NOA, S_default, S_exp)
    error_ARE = sqrt(sum((S_ARE-S_exp).^2));
    error_DTW = sqrt(sum((S_DTW-S_exp).^2));
    error_NOA = sqrt(sum((S_NOA-S_exp).^2));
    error_default = sqrt(sum((S_default-S_exp).^2));

    Error_S= [error_ARE error_DTW error_NOA error_default];
end
