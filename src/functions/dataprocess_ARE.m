function Error_ARE = dataprocess_ARE(ARE_data, DTW_data, NOA_data, ~, EXP_data)
    ARE_ARE  = mean(abs(ARE_data(:,2)  - EXP_data(:,2)./(EXP_data(:,2))));
    DTW_ARE  = mean(abs(DTW_data(:,2)  - EXP_data(:,2)./(EXP_data(:,2))));
    NOA_ARE  = mean(abs(NOA_data(:,2)  - EXP_data(:,2)./(EXP_data(:,2))));

    Error_ARE= [ARE_ARE DTW_ARE NOA_ARE];
end

