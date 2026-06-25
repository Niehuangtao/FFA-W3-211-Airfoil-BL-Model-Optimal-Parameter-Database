function Error_ARE = dataprocess_ARE(ARE_data,DTW_data,GZ_data,init_data,EXP_data)
    ARE_ARE  = mean(abs(ARE_data(:,2)  - EXP_data(:,2)./(EXP_data(:,2))));
    DTW_ARE  = mean(abs(DTW_data(:,2)  - EXP_data(:,2)./(EXP_data(:,2))));
    GZ_ARE   = mean(abs(GZ_data(:,2)   - EXP_data(:,2)./(EXP_data(:,2))));
    init_ARE = mean(abs(init_data(:,2) - EXP_data(:,2)./(EXP_data(:,2))));

    Error_ARE= [ARE_ARE DTW_ARE GZ_ARE];
end

