function E = new_areacover(ARE_data,DTW_data,GZ_data,init_data,exp_data)
    pg_ARE = polyshape(ARE_data(:,1), ARE_data(:,2));
    pg_DTW = polyshape(DTW_data(:,1), DTW_data(:,2));
    pg_GZ = polyshape(GZ_data(:,1), GZ_data(:,2));
    pg_init = polyshape(init_data(:,1), init_data(:,2));
    pg_exp = polyshape(exp_data(:,1), exp_data(:,2));
    
    
    pg_ARE = intersect(pg_exp, pg_ARE);
    pg_DTW = intersect(pg_exp, pg_DTW);
    pg_GZ = intersect(pg_exp, pg_GZ);
    pg_init = intersect(pg_exp, pg_init);
    
    A_ARE = area(pg_ARE);
    A_DTW = area(pg_DTW);
    A_GZ = area(pg_GZ);
    A_init = area(pg_init);
    
    A_exp = area(pg_exp);
    
    S_ARE = A_ARE/A_exp;
    S_DTW = A_DTW/A_exp;
    S_GZ = A_GZ/A_exp;
    S_init = A_init/A_exp;
    
    E = [S_ARE S_DTW S_GZ S_init];
    
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