function Tv = select_Tv(tau_v,Tvl,TESF,VRTX,d_alphai,alphai,alpha0,q_doti,Tv0)
    Tv = Tv0 / 1;
    if tau_v <= 2*Tvl && tau_v >= Tvl
        Tv = Tv0 / 3;
        if TESF == -1
            Tv = Tv0 / 4;
            if VRTX == 1 && 0 <= tau_v && tau_v <= Tvl
                if d_alphai*(alphai - alpha0) <0
                    Tv = Tv0/2;
                else
                    Tv = Tv0;
                end
            end
        end
    elseif d_alphai*(alphai - alpha0) <0
        Tv = Tv0/4;
    end
    if TESF == -1 && q_doti*(alphai - alpha0)<0
        Tv = Tv0;
    end
end

        

