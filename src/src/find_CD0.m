function cd_at_CL0 = find_CD0(data)
    cl_exp     = data(:,2);
    alpha_exp_deg = data(:,1);
    alpha_exp_rad = alpha_exp_deg * pi/180;
    cd_exp     = data(:,3);  
    
    valid_idx = ~isnan(cl_exp) & ~isnan(alpha_exp_deg) & ~isnan(cd_exp);
    cl_exp = cl_exp(valid_idx);
    alpha_exp_deg = alpha_exp_deg(valid_idx);
    alpha_exp_rad = alpha_exp_rad(valid_idx);
    cd_exp = cd_exp(valid_idx);
    
    cl_sign = sign(cl_exp);
    cross_zero_idx = [];
    n = length(cl_exp);
    
    for i = 2:n-1
        if cl_sign(i) * cl_sign(i+1) < 0
            cross_zero_idx = [cross_zero_idx, i];
        elseif cl_exp(i) == 0
            cross_zero_idx = [cross_zero_idx, i];
        end
    end
    
    alpha_CL0 = [];
    for idx = cross_zero_idx

        x1_rad = alpha_exp_rad(idx);   y1_cl = cl_exp(idx);
        x2_rad = alpha_exp_rad(idx+1); y2_cl = cl_exp(idx+1);
        
        alpha_0_rad = x1_rad - y1_cl * (x2_rad - x1_rad) / (y2_cl - y1_cl);
        alpha_CL0 = [alpha_CL0, alpha_0_rad];
    end

    target = abs(alpha_CL0);
    idx    = target == min(abs(alpha_CL0));
    alpha0 = alpha_CL0(idx);

    cd_at_CL0 = [];
    if ~isempty(alpha0)
        alpha_0_deg = alpha0 * 180/pi;
        cd_at_CL0 = interp1(alpha_exp_deg, cd_exp, alpha_0_deg, 'linear', 'extrap');
    end

end