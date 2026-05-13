function Error_dtw = dataprocess_DTW(ARE_data, DTW_data, NOA_data, ~, exp_data)
    ARE_DTW  = dtw(ARE_data(:,2) ,exp_data(:,2));
    DTW_DTW  = dtw(DTW_data(:,2) ,exp_data(:,2));
    NOA_DTW  = dtw(NOA_data(:,2) ,exp_data(:,2));

    Error_dtw = [ARE_DTW DTW_DTW NOA_DTW];
end
