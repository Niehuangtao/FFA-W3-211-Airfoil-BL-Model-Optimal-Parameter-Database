function compare_optimal_result(para_local,para_init,setcase) 

    conditions = setcase.conditions ;
    airfoildata = setcase.airfoldata  ;
    CFDdatapath = setcase.CFDdatapath ;
    %% ===================== 2. 计算BL模型的输出值 Cl_BL / Cm_BL =====================
    [CC_total,CN_total,CM_total,CD,CL,CM,a] = cal_DS(para_local,conditions,airfoildata);
    [CC_init,CN_init,CM_init,CD_init,CL_init,CM_init,a_init] = cal_DS(para_init,conditions,airfoildata);
    
    % CFD数据
    [a0, cl,cd,cm] = get_CFDdata(CFDdatapath,setcase);
    
    w       = conditions.w;
    dt      = conditions.dt;
    start = 7.5;
    last  = 8.5;
    idx_s = 2*pi/w*start/dt;
    idx_l = 2*pi/w*last/dt;

    %CFD数据---------------------------------------------------
    % data = readmatrix("FFA_W3_211.txt");
    % figure
    % [a1,cl] = drawCoffeint('cl_211_0.31_20.out',meanangle,averageangle);
    % plot(rad2deg(a(idx_s:idx_l)), CL(idx_s:idx_l),a1,cl, 'LineWidth',1.5);
    % xlabel('攻角 α (°)','FontSize',15); 
    % ylabel('升力系数 C_L','FontSize',15);
    % title('BL模型cl系数','FontSize',15); grid on;
    % legend('BL模型','cfd数据','Location','northwest')
    % saveas(gcf, ['cl_compare','.png']);
    % exportgraphics(gcf,'cl_compare.pdf','ContentType', 'vector')
    % 
    % figure
    % [a2,cd] = drawCoffeint('cd_211_0.31_20.out',meanangle,averageangle);
    % plot(rad2deg(a(idx_s:idx_l)), CD(idx_s:idx_l), a2,cd,'LineWidth',1.5);
    % xlabel('攻角 α (°)','FontSize',15); 
    % ylabel('阻力系数 C_D','FontSize',15);
    % title('BL模型cd系数','FontSize',15); grid on;
    % legend('BL模型','cfd数据','Location','northwest')
    % saveas(gcf, ['cd_compare','.png']);
    % exportgraphics(gcf,'cd_compare.pdf','ContentType', 'vector')
       
    figure
    plot(rad2deg(a(idx_s:idx_l)), CL(idx_s:idx_l),a0,cl,rad2deg(a_init(idx_s:idx_l)),CL_init(idx_s:idx_l), 'LineWidth',1.5);
    xlabel('攻角 α (°)','FontSize',15); 
    ylabel('升力系数 C_L','FontSize',15);
    title('BL模型cl系数','FontSize',15); grid on;
    legend('优化后','升阻力数据','原BL','Location','northwest')
    saveas(gcf, ['cl_compare','.png']);
    exportgraphics(gcf,'cl_compare.pdf','ContentType', 'vector')
    
    figure
    plot(rad2deg(a(idx_s:idx_l)), CD(idx_s:idx_l), a0,cd,rad2deg(a_init(idx_s:idx_l)),CD_init(idx_s:idx_l),'LineWidth',1.5);
    xlabel('攻角 α (°)','FontSize',15); 
    ylabel('阻力系数 C_D','FontSize',15);
    title('BL模型cd系数','FontSize',15); grid on;
    legend('优化后','升阻力数据','原BL','Location','northwest')
    saveas(gcf, ['cd_compare','.png']);
    exportgraphics(gcf,'cd_compare.pdf','ContentType', 'vector')

    figure
    plot(rad2deg(a(idx_s:idx_l)), CM(idx_s:idx_l), a0,cm,rad2deg(a_init(idx_s:idx_l)),CM_init(idx_s:idx_l),'LineWidth',1.5);
    xlabel('攻角 α (°)','FontSize',15); 
    ylabel('力矩系数 C_M','FontSize',15);
    title('BL模型cm系数','FontSize',15); grid on;
    legend('优化后','升阻力数据','原BL','Location','northwest')
    saveas(gcf, ['cm_compare','.png']);
    exportgraphics(gcf,'cm_compare.pdf','ContentType', 'vector')
end