function [exp_up,exp_dw] = area_cover(~,~,~,~,exp_data)

    [exp_up,exp_dw] = reshape_expdata(exp_data);

    % max_dw_ARE = absolute_maxi(ARE_dw(:,2),exp_dw(:,2));
    % max_dw_MSE = absolute_maxi(MSE_dw(:,2),exp_dw(:,2));
    % max_dw_DTW = absolute_maxi(DTW_dw(:,2),exp_dw(:,2));
    % max_dw_default = absolute_maxi(default_dw(:,2),exp_dw(:,2));
    % 
    % min_up_ARE = absolute_mini(ARE_up(:,2),exp_up(:,2));
    % min_up_MSE = absolute_mini(MSE_up(:,2),exp_up(:,2));
    % min_up_DTW = absolute_mini(DTW_up(:,2),exp_up(:,2));
    % min_up_default = absolute_mini(default_up(:,2),exp_up(:,2));
    % 
    % S_exp = trapz(exp_up(:,1),exp_up(:,2)) - trapz(exp_dw(:,1),exp_dw(:,2));
    % S_ARE = (trapz(min_up_ARE,ARE_up(:,1)) - trapz(max_dw_ARE,ARE_dw(:,1)))/S_exp;
    % S_MSE = (trapz(min_up_MSE,MSE_up(:,1)) - trapz(max_dw_MSE,MSE_dw(:,1)))/S_exp;
    % S_DTW = (trapz(min_up_DTW,DTW_up(:,1)) - trapz(max_dw_DTW,DTW_dw(:,1)))/S_exp;
    % S_default = (trapz(min_up_default,default_up(:,1)) - trapz(max_dw_default,default_dw(:,1)))/S_exp;
    % 
    % E = [S_ARE S_MSE S_DTW S_default];

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
