function [f_lag,Tf,Df] = cal_flag(fi,fi_1,Df,f_lagi_1,LESFi,VRTXi,dai,ai,alpha0,Tf0,Tf,tau_vi,Tvl,ds)
    Df = Df*exp(-ds/Tf) + (fi-fi_1)*exp(-0.5*ds/Tf);
    f_lag  = fi - Df;
    
    if f_lag<f_lagi_1
        TESF = 1;
    else
        TESF = -1;
    end
        
    Tf = select_Tf(TESF,f_lagi_1,LESFi,VRTXi,dai,ai,alpha0,Tf0,tau_vi,Tvl); 
end