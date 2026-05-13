function Error_S = process_mat_data(S_ARE,S_DTW,S_GZ,S_init,S_exp)
    error_ARE = sqrt(sum((S_ARE-S_exp).^2));
    error_DTW = sqrt(sum((S_DTW-S_exp).^2));
    error_GZ = sqrt(sum((S_GZ-S_exp).^2));
    error_init = sqrt(sum((S_init-S_exp).^2));

    Error_S= [error_ARE error_DTW error_GZ error_init];
end