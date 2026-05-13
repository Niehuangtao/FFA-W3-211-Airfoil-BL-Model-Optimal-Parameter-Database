function Tf = select_Tf(TESF,f_lagi_1,LESFi,VRTXi,d_alphai,alphai,alpha0,Tf0,tau_vi,Tvl)
    Tf = Tf0;
    if TESF == 1
        if d_alphai*(alphai-alpha0)<0
            Tf = Tf0 / 2;
        elseif LESFi == -1
            Tf = Tf0;
        elseif f_lagi_1 < 0.7
            Tf = Tf0 / 2;
        else
            Tf = Tf0 / 1.75;
        end
    else
        if LESFi == -1
            Tf = Tf0 / 0.5;
        end
        if VRTXi == 1 && tau_vi < Tvl && tau_vi > 0
            Tf = Tf0 / 0.25;
        end
        if d_alphai*(alphai-alpha0) > 0
            Tf = Tf0 / 0.75;
        end
    end

end

