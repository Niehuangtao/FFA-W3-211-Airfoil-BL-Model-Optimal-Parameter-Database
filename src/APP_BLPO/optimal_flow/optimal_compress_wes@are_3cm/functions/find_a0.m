function alpha0 = find_a0(data)
    cl_exp     = data(:,2);
    alpha_exp  = data(:,1)*pi/180;
    cl_sign = sign(cl_exp);
    cross_zero_idx = [];

    for i = 2:length(cl_exp)-1
        if cl_sign(i) * cl_sign(i+1) < 0
            cross_zero_idx = [cross_zero_idx, i];
        elseif cl_exp(i) == 0
            cross_zero_idx = [cross_zero_idx, i];
        end
    end
    
    alpha_CL0 = [];
    for idx = cross_zero_idx
        x1 = alpha_exp(idx);   y1 = cl_exp(idx);
        x2 = alpha_exp(idx+1); y2 = cl_exp(idx+1);
        
        alpha_0 = x1 - y1 * (x2 - x1) / (y2 - y1);
        alpha_CL0 = [alpha_CL0, alpha_0];
    end

    target = abs(alpha_CL0);
    idx    = target == min(abs(alpha_CL0));
    alpha0 = alpha_CL0(idx);
end