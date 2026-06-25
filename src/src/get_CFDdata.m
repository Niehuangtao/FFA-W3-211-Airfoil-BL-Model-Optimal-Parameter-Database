function [AOA, Cl_ori] = get_CFDdata(filename,setcase)
    warning off
    % averageangle = 10.00; 
    % Re        = 500000;
    % c         = 1;
    % miu       = 1.79e-5;
    % rou       = 1.225;
    % meanangle    = 20;
    % 
    % U  = 10 ;
    % f     = 1 ;
    % w    = 0.31*U/c*2;
    % k    = pi*f*c/U;
    % T     = 1/f      ;

    meanangle = setcase.meanangle     ;
    averageangle = setcase.averageangle  ;
    conditions = setcase.conditions    ;
    airfoildata = setcase.airfoldata;

    f     = conditions.ff ;
    w     = conditions.w;
    c     = airfoildata.c;
    U     = conditions.U;
    T     = 2*pi/w      ;
 
    filename = resolve_data_file(filename, 'cfd');
    cfd_data  = readmatrix(filename);
    AOA  = cfd_data(:,1);
    Cl_ori = cfd_data(:,2);
    % Cd_ori = cfd_data(:,3);
    % Cm_ori = cfd_data(:,4);
    
    % timestep   = time(3)- time(2);
    
    %n = time(end,:) / T;
    % a =3;
    % b =4;
    % t_i = a * T / timestep;
    % t_j = b * T / timestep;
    % 
    % [a,~,~,~] = get_a_q(meanangle,-averageangle,w,c,U,time(t_i:t_j));
    % a = rad2deg(a);
    % Cl = Cl_ori(t_i:t_j);
    % Cd = Cd_ori(t_i:t_j);
    % Cm = Cm_ori(t_i:t_j);



    % figure
    % plot(a(2:length(Coff1)),Coff1(2:length(Coff1)),'Color','b')
    % hold on
    % plot(a(length(Coff1)+1:end),Coff2(length(Coff1)+1:end),'Color','r')
    % title(['k = ' num2str(k)   ' at ' type 'coefficient'])
    % ylabel(type)
    % xlabel('Angle of attack/ \alpha')
    % legend('Increasing angle of attack','Decreasing angle of attack','Location','northwest')
    % 
    % saveas(gcf, [filename,'.png']);
    % exportgraphics(gcf, [filename,'.pdf'], 'ContentType', 'vector');
end
