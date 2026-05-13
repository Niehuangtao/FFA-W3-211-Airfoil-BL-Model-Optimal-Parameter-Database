function E = new_areacover(ARE_data, DTW_data, NOA_data, default_data, exp_data)
    pg_ARE = polyshape(ARE_data(:,1), ARE_data(:,2));
    pg_DTW = polyshape(DTW_data(:,1), DTW_data(:,2));
    pg_NOA = polyshape(NOA_data(:,1), NOA_data(:,2));
    pg_default = polyshape(default_data(:,1), default_data(:,2));
    pg_exp = polyshape(exp_data(:,1), exp_data(:,2));
    
    
    pg_ARE = intersect(pg_exp, pg_ARE);
    pg_DTW = intersect(pg_exp, pg_DTW);
    pg_NOA = intersect(pg_exp, pg_NOA);
    pg_default = intersect(pg_exp, pg_default);
    
    A_ARE = area(pg_ARE);
    A_DTW = area(pg_DTW);
    A_NOA = area(pg_NOA);
    A_default = area(pg_default);
    
    A_exp = area(pg_exp);
    
    S_ARE = A_ARE/A_exp;
    S_DTW = A_DTW/A_exp;
    S_NOA = A_NOA/A_exp;
    S_default = A_default/A_exp;
    
    E = [S_ARE S_DTW S_NOA S_default];
    
    % figure;
    % plot(pg1, 'FaceColor', 'red', 'FaceAlpha', 0.3);
    % hold on;
    % plot(pg2, 'FaceColor', 'blue', 'FaceAlpha', 0.3);
    % plot(pg_inter, 'FaceColor', 'green', 'FaceAlpha', 0.6);
    % ylim([0 2])
    % axis equal;
    % legend('DTW区域', 'exp区域', '交集区域');
    % title(['交集面积 = ', num2str(A_inter)]);
end
