function [a, Cl,Cd,Cm] = get_CFDdata(filename,setcase)
    warning off

    meanangle = setcase.meanangle     ;
    averageangle = setcase.averageangle  ;
    conditions = setcase.conditions    ;
    airfoildata = setcase.airfoldata;

    w     = conditions.w;
    c     = airfoildata.c;
    U     = conditions.U;
    T     = 2*pi/w      ;
 
    cfd_data = readmatrix(filename);
    time   = cfd_data(:,1);
    Cl_ori = cfd_data(:,2);
    Cd_ori = cfd_data(:,3);
    Cm_ori = cfd_data(:,4);
    
    timestep   = time(3)- time(2);
    
    a = 3;
    b = 4;
    t_i = a * T / timestep;
    t_j = b * T / timestep;

    a = meanangle - averageangle*sin(w*time(t_i:t_j));
    Cl = Cl_ori(t_i:t_j);
    Cd = Cd_ori(t_i:t_j);
    Cm = Cm_ori(t_i:t_j);

end