function Fitness = fitness_MSE(param,setcase)
    meanangle = setcase.meanangle ;
    averageangle = setcase.averageangle ;
    conditions = setcase.conditions ;
    airfoildata = setcase.airfoldata  ;
    CFDdatapath = setcase.CFDdatapath ;

    % CFD data
    [a0, CN_CFD] = get_CFDdata(CFDdatapath,setcase);
    
    %% ===================== 2. Compute BL model outputs Cl_BL / Cm_BL =====================
    [CC_total,CN_total,CM_total,CD,CL,CM,a] = cal_DS(param,conditions,airfoildata);


    % Extract the selected BL model cycle window
    n_steps = conditions.n_steps;
    begin = 7* n_steps/10;
    last  = 8 * n_steps/10;
    test_Cl = CL(begin:last);
    test_Cd = CD(begin:last);
    test_Cm = CM(begin:last);
    test_Cn = CN_total(begin:last);
    a_c     = rad2deg(a(begin:last));
    %% ===================== 3. Metric 1: absolute area error enclosed by the curve=====================
    x_area = linspace(1,length(CN_CFD),500);
    x_CFD  = linspace(1,length(CN_CFD),length(CN_CFD));
    x_test  = linspace(1,length(CN_CFD),length(test_Cn));
    [S_Cl,MSE] = area_overlap_MSE(x_area,x_test,test_Cl,x_CFD,CN_CFD);
    % [S_Cd,RMSE_CD] = area_overlap(x_area,a_c,test_Cd,rad2deg(a0),Cd_CFD);
    % [S_Cm,RMSE_CM]  = area_overlap(x_area,a_c,test_Cm,rad2deg(a0),Cm_CFD);
    % %Area_Err_Cm = abs(S_Cm_BL - S_Cm_CFD);
    % Total_RMSE = RMSE_CL+RMSE_CD;
    % Total_Area_overlap = S_Cl;
    
    %% ===================== 4. Metric 2: pointwise RMSE =====================
    % RMSE_Cl = sqrt(mean((CL - Cl_CFD)^2));
    % RMSE_Cd = sqrt(mean((CD - Cd_CFD)^2)); 
    % RMSE_Cm = sqrt(mean((CM - Cm_CFD)^2));  
    % Total_RMSE = RMSE_Cl + RMSE_Cd + RMSE_Cm ;
    
    % Dynamic time warping
    % Normalization
    % norm_cl_cfd = normalize(Cl_CFD);
    % norm_test_cl = normalize(test_Cl);
    % norm_cd_cfd = normalize(Cd_CFD);
    % norm_test_cd = normalize(test_Cd);
    
    % [x_test_max,y_test_max] = getMaxXY(a_c,test_Cn);
    % [x_CFD_max,y_CFD_max] = getMaxXY(a0,CN_CFD);
    % [x_test_min,y_test_min] = getMinXY(a_c,test_Cn);
    % [x_CFD_min,y_CFD_min] = getMinXY(a0,CN_CFD);    
    % CN_CFD_new = interp1(x_CFD,CN_CFD,x_area,'linear');
    % dmax = (x_test_max-x_CFD_max)^2 + (y_CFD_max-y_test_max)^2;
    % dmin = (x_test_min-x_CFD_min)^2 + (y_CFD_min-y_test_min)^2;
    [dist1,~,~] = dtw(test_Cn,CN_CFD);
    % [dist2,~,~] = dtw(Cd_CFD,test_Cd);
    % [dist3,~,~] = dtw(Cm_CFD,test_Cm);
    
    
    %% ===================== 5. Keep physical-constraint penalty terms required by the BL model =====================
    
    
    %% ===================== 6. Total fitness function (smaller is better for the evolutionary algorithm) =====================
    % Weighting: area error is primary, RMSE is secondary, then physical penalties.
    Fitness = MSE*100;


