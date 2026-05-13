function [a, Coefficient] = drawCoffeint(filename,setcase)
    warning off
    meanangle = setcase.meanangle ;
    averageangle = setcase.averageangle ;
    conditions = setcase.conditions;
    %1.工况设置（与主程序一致）
    f     = conditions.ff ;
    w    = conditions.w;
    U    = conditions.U;
    c    = 1;
    T     = 1/f      ;
    
    data       = readoutfile(filename);
    coefficient   = data(:,2)            ;
    time       = data(:,3)            ;
    timestep   = time(3)- time(2);
    
    %n = time(end,:) / T;
    a = 3;
    b = 4;
    t_i = a * T / timestep;
    t_j = b * T / timestep;

    [a,~,~,~] = get_a_q(meanangle,-averageangle,w,c,U,time(t_i:t_j));
    a = rad2deg(a);
    Coefficient = coefficient(t_i:t_j);

    % figure
    % plot(a(2:length(Coff1)),Coff1(2:length(Coff1)),'Color','b')
    % hold on
    % plot(a(length(Coff1)+1:end),Coff2(length(Coff1)+1:end),'Color','r')
    % title(['k = ' num2str(k)   '时的' type '系数'])
    % ylabel(type)
    % xlabel('攻角/ \alpha')
    % legend('攻角增大','攻角减小','Location','northwest')
    % 
    % saveas(gcf, [filename,'.png']);
    % exportgraphics(gcf, [filename,'.pdf'], 'ContentType', 'vector');
end