function compare_optimal_result_DTW(para_local,para_init,setcase) 


    objectiveName = 'DTW';
    outputDir = generated_results_dir();
    conditions = setcase.conditions ;
    airfoildata = setcase.airfoldata  ;
    CFDdatapath = setcase.CFDdatapath ;
    %% ===================== 2. Compute BL model outputs Cl_BL / Cm_BL =====================
    [CC_total,CN_total,CM_total,CD,CL,CM,a] = cal_DS(para_local,conditions,airfoildata);
    [CC_init,CN_init,CM_init,CD_init,CL_init,CM_init,a_init] = cal_DS(para_init,conditions,airfoildata);
    
    % CFD data
    [a0, cl] = get_CFDdata(CFDdatapath,setcase);
    x_area = linspace(1,length(cl),500);
    x_CFD  = linspace(1,length(cl),length(cl));
    cl = interp1(x_CFD,cl,x_area,'linear');

    w       = conditions.w;
    dt      = conditions.dt;
    start = 7;
    last  = 8;
    idx_s = 2*pi/w*start/dt;
    idx_l = 2*pi/w*last/dt;
    figure
    dtw(cl,CN_total(idx_s:idx_l))

    figure
    dtw(cl,CN_init(idx_s:idx_l))

    figure
    plot(CN_init(idx_s:idx_l))
    hold on
    plot(CN_total(idx_s:idx_l))
    plot(cl)
    legend('Initial curve','Optimized','CFD')
    
    [a0, cl] = get_CFDdata(CFDdatapath,setcase);
    %CFD data---------------------------------------------------
    % data = readmatrix("FFA_W3_211.txt");
    % figure
    % [a1,cl] = drawCoffeint('cl_211_0.31_20.out',meanangle,averageangle);
    % plot(rad2deg(a(idx_s:idx_l)), CL(idx_s:idx_l),a1,cl, 'LineWidth',1.5);
    % xlabel('Angle of attack (deg)','FontSize',15); 
    % ylabel('Lift coefficient C_L','FontSize',15);
    % title('BL model C_N comparison','FontSize',15); grid on;
    % legend('BL model','CFD data','Location','northwest')
    % saveas(gcf, fullfile(outputDir, ['cl_compare_' objectiveName '.png']));
    % exportgraphics(gcf, fullfile(outputDir, ['cl_compare_' objectiveName '.pdf']), 'ContentType', 'vector')
    % 
    % figure
    % [a2,cd] = drawCoffeint('cd_211_0.31_20.out',meanangle,averageangle);
    % plot(rad2deg(a(idx_s:idx_l)), CD(idx_s:idx_l), a2,cd,'LineWidth',1.5);
    % xlabel('Angle of attack (deg)','FontSize',15); 
    % ylabel('Drag coefficient C_D','FontSize',15);
    % title('BL model C_D comparison','FontSize',15); grid on;
    % legend('BL model','CFD data','Location','northwest')
    % saveas(gcf, fullfile(outputDir, ['cd_compare_' objectiveName '.png']));
    % exportgraphics(gcf, fullfile(outputDir, ['cd_compare_' objectiveName '.pdf']), 'ContentType', 'vector')
       
    figure
    plot(rad2deg(a(idx_s:idx_l)), CN_total(idx_s:idx_l),a0,cl,rad2deg(a_init(idx_s:idx_l)),CN_init(idx_s:idx_l), 'LineWidth',1.5);
    xlabel('Angle of attack (deg)','FontSize',15); 
    ylabel('Normal force coefficient C_N','FontSize',15);
    title('BL model C_N comparison','FontSize',15); grid on;
    legend('Optimized','Lift-drag data','Original BL','Location','northwest')
    saveas(gcf, fullfile(outputDir, ['cl_compare_' objectiveName '.png']));
    exportgraphics(gcf, fullfile(outputDir, ['cl_compare_' objectiveName '.pdf']), 'ContentType', 'vector')
    
    % figure
    % plot(rad2deg(a(idx_s:idx_l)), CD(idx_s:idx_l), a0,cd,rad2deg(a_init(idx_s:idx_l)),CD_init(idx_s:idx_l),'LineWidth',1.5);
    % xlabel('Angle of attack (deg)','FontSize',15); 
    % ylabel('Drag coefficient C_D','FontSize',15);
    % title('BL model C_D comparison','FontSize',15); grid on;
    % legend('Optimized','Lift-drag data','Original BL','Location','northwest')
    % saveas(gcf, fullfile(outputDir, ['cd_compare_' objectiveName '.png']));
    % exportgraphics(gcf, fullfile(outputDir, ['cd_compare_' objectiveName '.pdf']), 'ContentType', 'vector')
    % 
    % figure
    % plot(rad2deg(a(idx_s:idx_l)), CM(idx_s:idx_l), a0,cm,rad2deg(a_init(idx_s:idx_l)),CM_init(idx_s:idx_l),'LineWidth',1.5);
    % xlabel('Angle of attack (deg)','FontSize',15); 
    % ylabel('Moment coefficient C_M','FontSize',15);
    % title('BL model C_M comparison','FontSize',15); grid on;
    % legend('Optimized','Lift-drag data','Original BL','Location','northwest')
    % saveas(gcf, fullfile(outputDir, ['cm_compare_' objectiveName '.png']));
    % exportgraphics(gcf, fullfile(outputDir, ['cm_compare_' objectiveName '.pdf']), 'ContentType', 'vector')

    init_data = [rad2deg(a_init(idx_s:idx_l))',CN_init(idx_s:idx_l)];
    exp_data  = [a0,cl];
    DTW_data  = [rad2deg(a(idx_s:idx_l))',CN_total(idx_s:idx_l)];

    save(fullfile(outputDir, ['data_collection_' objectiveName '.mat']), 'init_data', 'exp_data', 'DTW_data');
end