function Fitness = fitness_cl(para_local_lag,para_init_cl,para_init_cm,setcase)
    meanangle = setcase.meanangle ;
    averageangle = setcase.averageangle ;
    conditions = setcase.conditions ;
    airfoildata = setcase.airfoldata  ;
    CFDdatapath = setcase.CFDdatapath ;

    % CFD数据
    [a0, CN_CFD,CD_CFD,CM_CFD] = get_CFDdata(CFDdatapath,setcase);
    %% ===================== 2. 计算BL模型的输出值 Cl_BL / Cm_BL =====================
    param = [para_local_lag para_init_cl para_init_cm];
    [CC_total,CN_total,CM_total,CD,CL,CM,a] = cal_DS(param,conditions,airfoildata);


    % 取BL模型最后5个周期
    n_steps = conditions.n_steps;
    begin = 7* n_steps/10;
    last  = 8 * n_steps/10;
    test_Cl = CL(begin:last);
    test_Cd = CD(begin:last);
    test_Cm = CM(begin:last);
    test_Cn = CN_total(begin:last);
    a_c     = rad2deg(a(begin:last));
    %% ===================== 3. 核心评价指标1：曲线围成面积的绝对误差=====================
    x_area = linspace(1,length(CN_CFD),500);
    x_CFD  = linspace(1,length(CN_CFD),length(CN_CFD));
    x_test  = linspace(1,length(CN_CFD),length(test_Cl));
    ARE = area_overlap_GZ(a_c',test_Cl,a0,CN_CFD);
    % [S_Cd,RMSE_CD] = area_overlap(x_area,a_c,test_Cd,rad2deg(a0),Cd_CFD);
    % [S_Cm,RMSE_CM]  = area_overlap(x_area,a_c,test_Cm,rad2deg(a0),Cm_CFD);
    % %Area_Err_Cm = abs(S_Cm_BL - S_Cm_CFD);
    % Total_RMSE = RMSE_CL+RMSE_CD;
    % Total_Area_overlap = S_Cl;
    
    %% ===================== 4. 核心评价指标2：逐点拟合的均方根误差(RMSE) =====================
    % RMSE_Cl = sqrt(mean((CL - Cl_CFD)^2));
    % RMSE_Cd = sqrt(mean((CD - Cd_CFD)^2)); 
    % RMSE_Cm = sqrt(mean((CM - Cm_CFD)^2));  
    % Total_RMSE = RMSE_Cl + RMSE_Cd + RMSE_Cm ;
    
    % 动态时间规整
    % 归一化
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
    % [dist1,~,~] = dtw(test_Cn,CN_CFD);
    % [dist2,~,~] = dtw(Cd_CFD,test_Cd);
    % [dist3,~,~] = dtw(Cm_CFD,test_Cm);
    
    
    %% ===================== 5. 保留所有物理约束惩罚项（BL模型硬性要求，必须保留） =====================
    
    
    %% ===================== 6. 总适应度函数（越小越好，完美适配进化算法） =====================
    % 权重分配：面积误差×10（主） + RMSE（次） + 惩罚项 → 优先保证面积相近，再保证点贴合，最后保证物理合理性
    Fitness = ARE;


