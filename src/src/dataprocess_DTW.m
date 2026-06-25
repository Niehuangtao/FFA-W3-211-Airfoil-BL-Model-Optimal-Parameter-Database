function Error_dtw = dataprocess_DTW(ARE_data,DTW_data,GZ_data,init_data,exp_data)
    ARE_DTW  = dtw(ARE_data(:,2) ,exp_data(:,2));
    DTW_DTW  = dtw(DTW_data(:,2) ,exp_data(:,2));
    GZ_DTW   = dtw(GZ_data(:,2)  ,exp_data(:,2));
    init_DTW = dtw(init_data(:,2),exp_data(:,2));

    Error_dtw = [ARE_DTW DTW_DTW GZ_DTW];
end