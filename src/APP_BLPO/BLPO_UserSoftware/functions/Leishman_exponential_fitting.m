function f = Leishman_exponential_fitting(alpha0,alpha1,alpha2,ae,S1,S2,S3,S4,n_steps)
    for i = 1: length(n_steps)
        if ae <= alpha1 && alpha0 <= ae
            f = 1 - 0.3*exp(rad2deg(ae-alpha1)/S1);
        elseif ae <= alpha0 && alpha2 <= ae
            f = 1 - 0.3*exp(rad2deg(alpha2-ae)/S3);
        elseif ae > alpha1
            f = 0.04 + 0.66*exp(rad2deg(alpha1-ae)/S2);
        elseif ae < alpha2
            f = 0.04 + 0.66*exp(rad2deg(ae-alpha2)/S4);
        end
    end
end