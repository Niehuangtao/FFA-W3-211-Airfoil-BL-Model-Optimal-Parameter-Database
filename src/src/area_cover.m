function [exp_up,exp_dw] = area_cover(ARE_data,DTW_data,MSE_data,init_data,exp_data)

    [ARE_up,ARE_dw] = reshape_data(ARE_data);
    [MSE_up,MSE_dw] = reshape_data(MSE_data);
    [DTW_up,DTW_dw] = reshape_data(DTW_data);
    [init_up,init_dw] = reshape_data(init_data);
    [exp_up,exp_dw] = reshape_expdata(exp_data);

    % max_dw_ARE = absolute_maxi(ARE_dw(:,2),exp_dw(:,2));
    % max_dw_MSE = absolute_maxi(MSE_dw(:,2),exp_dw(:,2));
    % max_dw_DTW = absolute_maxi(DTW_dw(:,2),exp_dw(:,2));
    % max_dw_init = absolute_maxi(init_dw(:,2),exp_dw(:,2));
    % 
    % min_up_ARE = absolute_mini(ARE_up(:,2),exp_up(:,2));
    % min_up_MSE = absolute_mini(MSE_up(:,2),exp_up(:,2));
    % min_up_DTW = absolute_mini(DTW_up(:,2),exp_up(:,2));
    % min_up_init = absolute_mini(init_up(:,2),exp_up(:,2));
    % 
    % S_exp = trapz(exp_up(:,1),exp_up(:,2)) - trapz(exp_dw(:,1),exp_dw(:,2));
    % S_ARE = (trapz(min_up_ARE,ARE_up(:,1)) - trapz(max_dw_ARE,ARE_dw(:,1)))/S_exp;
    % S_MSE = (trapz(min_up_MSE,MSE_up(:,1)) - trapz(max_dw_MSE,MSE_dw(:,1)))/S_exp;
    % S_DTW = (trapz(min_up_DTW,DTW_up(:,1)) - trapz(max_dw_DTW,DTW_dw(:,1)))/S_exp;
    % S_init = (trapz(min_up_init,init_up(:,1)) - trapz(max_dw_init,init_dw(:,1)))/S_exp;
    % 
    % E = [S_ARE S_MSE S_DTW S_init];

    % figure
    % plot(ARE_up(:,1),ARE_up(:,2))
    % hold on
    % plot(ARE_dw(:,1),ARE_dw(:,2))
    % 
    % plot(exp_up(:,1),exp_up(:,2))
    % plot(exp_dw(:,1),exp_dw(:,2))
    % plot(ARE_dw(:,1),max_dw_ARE,'o')
    % plot(ARE_up(:,1),min_up_ARE,'*')


end