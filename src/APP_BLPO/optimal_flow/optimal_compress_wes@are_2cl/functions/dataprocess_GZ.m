function Error_GZ = dataprocess_GZ(ARE_data,DTW_data,GZ_data,init_data,exp_data)
    ARE_GZ  = area_overlap_GZ(ARE_data(:,1)' ,ARE_data(:,2),exp_data(:,1),exp_data(:,2));
    DTW_GZ  = area_overlap_GZ(DTW_data(:,1)' ,DTW_data(:,2),exp_data(:,1),exp_data(:,2));
    GZ_GZ   = area_overlap_GZ(GZ_data(:,1)'  ,GZ_data(:,2) ,exp_data(:,1),exp_data(:,2));
    init_GZ = area_overlap_GZ(init_data(:,1)',init_data(:,2),exp_data(:,1),exp_data(:,2));

    area_exp = polyshape(exp_data(:,1),exp_data(:,2)); 
    S_exp = area(area_exp);
    Error_GZ = [ARE_GZ/S_exp DTW_GZ/S_exp GZ_GZ/S_exp];
end