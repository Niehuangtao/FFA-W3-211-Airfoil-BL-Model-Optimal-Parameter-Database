function [CC_total,CN_total,CM_total,CD,CL,CM,a] = cal_DS(param,conditions,airfoildata)
    st = 0.19;
    A1=param(1);b1=param(2);A2=param(3);b2=param(4);Tp=param(5);Tf0=param(6);
    Tvl=param(7);Tv0=param(8);yita=param(9);
    %k0=param(16);k1=param(17);k2=param(18);k3=param(19);
    A3   = 0.2           ; b3   = 0.2           ;
    A4   = 0.1           ; b4   = 0.1           ;
    A5   = 0.1           ; b5   = 0.3           ;
    %Re=2e6
    % S1   = 0.5           ; S2   = 0.5             ;
    % S3   = 3             ; S4   = 3            ;

    % Re=1e6
    S1   = 7           ; S2     = 3             ;
    S3   = 2           ; S4   = 2            ;

    % % Re=5e5
    % S1   = 0.5           ; S2   = 0.5             ;
    % S3   = 3             ; S4   = 3            ;

    k0   = 1 ;k1   = 1; k2   = 1; k3   = 1;

    CD0 =airfoildata.CD0 ;
    CM0 = airfoildata.CM0;
    alpha0 = airfoildata.alpha0;
    alpha1 = airfoildata.alpha1;
    alpha2 = airfoildata.alpha2;
    CN1 = airfoildata.CN1;
    CN2 = airfoildata.CN2;
    slope = airfoildata.slope;
    mCN = airfoildata.mCN;
    slope_M = airfoildata.slope_M; 
    c = airfoildata.c;
    xAC = airfoildata.xAC;
    xcp_c = airfoildata.xcp_c;

    % CD0 = airfoildata(1);CM0 = airfoildata(2);alpha0 = airfoildata(3);alpha1 = airfoildata(4);
    % alpha2 = airfoildata(5);CN1 = airfoildata(6);CN2 = airfoildata(7);slope = airfoildata(8);
    % mCN = airfoildata(9);slope_M = airfoildata(10);c = airfoildata(11);xAC = airfoildata(12);
    % xcp_c = airfoildata(13);

    a = conditions.a;
    da = conditions.da;
    q = conditions.q;
    dq = conditions.dq;
    as = conditions.as;
    beta = conditions.beta;
    n_steps = conditions.n_steps;
    ds = conditions.ds;
    U = conditions.U;
    M = conditions.M;
    s = conditions.s;
    t = conditions.t;

    Tl = c/as;
    Ta = 0.75*Tl/((1-M)+mCN*beta*M^2*(A1*b1+A2*b2));
    Tq = 0.75*Tl/((1-M)+mCN*beta*M^2*(A1*b1+A2*b2));
    km = 7/((15*(1-M)+1.5*slope_M*A5*b5*beta*M^2)) ;
    Tam= (A3*b4+A4*b3)*2*M/(b3*b4*(1-M));
    Tqm= 14*M/(15*(1-M)+1.5*mCN*beta^2*M^2*A5*b5);

    %%%%%%%%%%%%%%%%%%%%初始化滞后函数与变量%%%%%%%%%%%%%%%%%%%%
    %---------------------1.附着流----------------------
    X1 = A1*(a(1))*exp(-0.5*b1*beta^2*ds);
    Y1 = A2*(a(1))*exp(-0.5*b2*beta^2*ds); 
    X2 = A1*(da(1))*exp(-0.5*b1*beta^2*ds); 
    Y2 = A2*(dq(1))*exp(-0.5*b2*beta^2*ds); 
    X3 = 0;
    X4 = 0;
    Y4 = 0;
    D_Na = (da(1))*exp(-0.5*ds/Ta); 
    D_Nq = (dq(1))*exp(-0.5*ds/Ta); 
    D_Mq = 0; 
    CN_cir   = zeros(n_steps,1);  % 环量法向力系数
    CN_a_cir = zeros(n_steps,1);  % 环量项攻角贡献
    CN_q_cir = zeros(n_steps,1);  % 环量项pitch rate贡献
    CN_imp   = zeros(n_steps,1);  % 脉冲法向力系数
    CN_imp_a = zeros(n_steps,1);  % 脉冲项攻角贡献
    CN_imp_q = zeros(n_steps,1);  % 脉冲项pitch rate贡献
    CN_pot   = zeros(n_steps,1);  % 附着流法向力系数
    CC_pot   = zeros(n_steps,1);  % 附着流弦向力系数
    CM_a_cir = zeros(n_steps,1); 
    CM_a_imp = zeros(n_steps,1);
    CM_q_cir = zeros(n_steps,1);
    CM_q_imp = zeros(n_steps,1);
    CM_q     = zeros(n_steps,1); 
    CM_cir   = zeros(n_steps,1); 
    alpha_E  = zeros(n_steps,1);  % 3/4弦长处攻角
    %---------------------2.分离流----------------------
     
    Df = 0;
    alpha_f= zeros(n_steps,1);
    CN_lag = zeros(n_steps,1);  % 滞后法向力系数
    f_orig = zeros(n_steps,1);  % 定常分离点位置
    f      = zeros(n_steps,1);  % 非定常分离点位置
    f_lag  = zeros(n_steps,1);  % 非定常分离点位置
    CN_f   = zeros(n_steps,1);  % 分离流法向力系数
    CC_f   = zeros(n_steps,1);  % 分离流弦向力系数
    CM_f   = zeros(n_steps,1); 
    %---------------------3.涡脱落----------------------
    tau_v = zeros(n_steps,1);   % 前缘涡无量纲位置
    VRTX  = zeros(n_steps,1);   % 涡脱是否发生
    TESF  = zeros(n_steps,1);
    LESF  = zeros(n_steps,1);
    target= zeros(n_steps,1);
    Cv    = zeros(n_steps,1);               
    CC_V  = zeros(n_steps,1);   % 涡致弦向力系数
    CN_V  = zeros(n_steps,1);   % 涡致法向力系数
    CM_V  = zeros(n_steps,1);
    %---------------------4.总荷载----------------------
    CN_total = zeros(n_steps,1);
    CC_total = zeros(n_steps,1);
    CM_total = zeros(n_steps,1);
    
    %%%%%%%%%%%%%%%%%%%%时间步推进计算各成分%%%%%%%%%%%%%%%%%%%%
    for i = 1 : n_steps
        if i == 1
            %------------------------1.附着流-------------------------
            alpha_E (i) = (a(i)-X1-Y1-alpha0) ;
            CN_a_cir(i) = mCN*alpha_E(i)      ;
            CN_q_cir(i) = 0.5*mCN*(q(i)-X2-Y2);
            CN_cir  (i) = CN_a_cir(i)         ;
            CN_imp_a(i) = 4*Ta/M*(da(i)-D_Na)      ;
            CN_imp_q(i) = Tq/M*(dq(i)-D_Nq)        ;
            CN_imp  (i) = CN_imp_q(i) + CN_imp_a(i);
            CC_pot  (i) = CN_cir(i)*tan(alpha_E(i)+alpha0);
            CN_pot  (i) = CN_cir(i) + CN_imp(i);
  
            CM_a_cir(i)   = (xAC-0.25)*CN_a_cir(i);
            CM_q_cir(i)   = -slope_M/16/beta*(q(i));
            CM_a_imp(i)   = - Tam*Tl/2/M^2*(A3*b3*da(i)+A4*b4*da(i));
            CM_q_imp(i)   = - 7*Tqm*Tl/24/M*(dq(i));
            CM_cir(i) = CM_a_cir(i) + CM_a_imp(i) + CM_q_cir(i) + CM_q_imp(i);
            %------------------------2.分离流-------------------------
            Dp = (CN_pot(1))*exp(-0.5*ds/Tp);
            CN_lag(i) = CN_pot(i)-Dp;
            alpha_f(i)= CN_lag(i) / mCN + alpha0;
            f_orig(i) = Leishman_exponential_fitting(alpha0,alpha1,alpha2,a(i),S1,S2,S3,S4,n_steps);
            f(i)      = Leishman_exponential_fitting(alpha0,alpha1,alpha2,alpha_f(i),S1,S2,S3,S4,n_steps);
            
            f_lag(i)  = f(i);
            CN_f(i)   = CN_cir(i)*((1+sqrt(f_lag(i)))/2)^2;
            CC_f(i)   = yita*CC_pot(i)*(sqrt(f_lag(i))-0.2);
            Df = (f(1))*exp(-0.5*ds/Tf0);
            %------------------------3.涡脱落-------------------------
            Cv(i) = CN_cir(i)*(1-((1+sqrt(f_lag(i)))/2)^2);
            %Cv(i) = 0;
            CN_V(i) = 0;
            Tf  = Tf0;
            xcp_v = xcp_c*(1-cos(pi*tau_v(i)/Tvl));
            CM_V(i) = -xcp_v*CN_V(i);
            
            CC_total(i) = CC_f(i);
            CN_total(i) = CN_f(i) + CN_imp(i) + CN_V(i);
            CM  = CM_f(i) + CM_a_imp(i) + CM_q(i);
        else
            %------------------------1.附着流-------------------------
            X1 = X1*exp(-b1*beta^2*ds) + A1*(a(i)-a(i-1))*exp(-0.5*b1*beta^2*ds);
            Y1 = Y1*exp(-b2*beta^2*ds) + A2*(a(i)-a(i-1))*exp(-0.5*b2*beta^2*ds);
            X2 = X2*exp(-b1*beta^2*ds) + A1*(q(i)-q(i-1))*exp(-0.5*b1*beta^2*ds);
            Y2 = Y2*exp(-b2*beta^2*ds) + A2*(q(i)-q(i-1))*exp(-0.5*b2*beta^2*ds);
            X3 = X3*exp(-b5*beta^2*ds) + A5*(q(i)-q(i-1))*exp(-0.5*b5*beta^2*ds);
            X4 = X4*exp(-ds/(b3*Tam))+(da(i)-da(i-1))*exp(-ds/(2*b3*Tam));
            Y4 = Y4*exp(-ds/(b4*Tam))+(da(i)-da(i-1))*exp(-ds/(2*b4*Tam));

            alpha_E(i) = (a(i)-X1-Y1-alpha0);
        
            CN_a_cir(i) = mCN*alpha_E(i);
            CN_q_cir(i) = 0.5*mCN*(q(i)-X2-Y2);
            CN_cir  (i) = CN_a_cir(i);
            
            D_Na = D_Na*exp(-ds/Ta) + (da(i)-da(i-1))*exp(-0.5*ds/Ta);
            D_Nq = D_Nq*exp(-ds/Tq) + (dq(i)- dq(i-1))*exp(-0.5*ds/Tq);
            CN_imp_a(i) = 4*Ta/M*(da(i)-D_Na);
            CN_imp_q(i) = Tq/M *(dq(i) - D_Nq);
    
            CN_imp(i) = CN_imp_q(i) + CN_imp_a(i);
            CC_pot(i) = CN_cir(i)*tan(alpha_E(i)+alpha0);
            CN_pot(i) = CN_cir(i) + CN_imp(i);
    
            D_Mq = D_Mq*exp(-ds/Tqm)+(dq(i)-dq(i-1))*exp(-0.5*ds/Tqm);
            CM_a_cir(i)   = (xAC-0.25)*CN_a_cir(i);
            CM_q_cir(i)   = -slope_M/16/beta*(q(i));
            CM_a_imp(i)   = - Tam*Tl/2/M^2*(A3*b3*da(i)+A4*b4*da(i));
            CM_q_imp(i)   = - 7*Tqm*Tl/24/M*(dq(i));
            CM_cir(i) = CM_a_cir(i) + CM_a_imp(i) + CM_q_cir(i) + CM_q_imp(i);
            
            %------------------------2.分离流-------------------------
            Dp        = Dp*exp(-ds/Tp) + (CN_pot(i)-CN_pot(i-1))*exp(-0.5*ds/Tp);
            CN_lag(i) = CN_pot(i) - Dp;  
            alpha_f(i)= CN_lag(i) / mCN + alpha0;
            f(i)      = Leishman_exponential_fitting(alpha0,alpha1,alpha2,alpha_f(i),S1,S2,S3,S4,n_steps);
            f_orig(i) = Leishman_exponential_fitting(alpha0,alpha1,alpha2,a(i),S1,S2,S3,S4,n_steps);
    
            Tsh       = 2 * (1-f_lag(i-1)) / st;
            target(i) = Tsh + Tvl;
            
            if (a(i) > alpha0 && CN_lag(i) > CN1) || (a(i) < alpha0 && CN_lag(i) < CN2)
                LESF(i) = 1;
            else
                LESF(i) = -1;
            end
            
            if (LESF(i) == 1) || (tau_v(i-1) > 0)
                tau_v(i) = tau_v(i-1) + ds;
            else
                tau_v(i) = 0;
            end
    
            if tau_v(i) > 2*Tvl
                tau_v(i) = 0;
            end
    
            if tau_v(i) >= target(i) && LESF(i) == 1
                tau_v(i) = 0;
            end
    
            if tau_v(i) > 0 && tau_v(i) < 2*Tvl
                VRTX(i) = 1;
            else
                VRTX(i) = -1;
            end
    
            %[f_lag(i),Tf,Df] = cal_flag(f(i),f(i-1),Df,f_lag(i-1),LESF(i),VRTX(i),da(i),a(i),alpha0,Tf0,Tf,tau_v(i),Tvl,ds);
            % Df = Df*exp(-ds/Tf) + (f(i)-f(i-1))*exp(-0.5*ds/Tf);
            % f_lag(i)  = f(i) - Df;
    
            Df        = Df*exp(-ds/Tf) + (f(i)-f(i-1))*exp(-0.5*ds/Tf);
            f_lag(i)  = f(i) - Df;
            
            if f_lag(i) < f_lag(i-1)
                TESF = 1;
            else
                TESF = -1;
            end
            Tf     = select_Tf(TESF,f_lag(i),f_lag(i-1),VRTX(i),da(i),a(i),alpha0,Tf0,tau_v(i),Tvl);
    
    
            CN_f(i)   = CN_cir(i)*((1+sqrt(f_lag(i)))/2)^2;
            CC_f(i)   = yita*CC_pot(i)*(sqrt(f_lag(i))-0.2);
    
            xcp       = k0 + k1*(1-f_lag(i)) + k2*sin(pi*f_lag(i)^k3);
            CM_f(i) = CM0 - CN_cir(i)*(xcp-0.25);
    
            %------------------------3.涡脱落-------------------------
            Tv = select_Tv(tau_v(i),Tvl,f_lag(i),f_lag(i-1),da(i),a(i),alpha0,dq(i),Tv0);
            Cv(i) = CN_cir(i)*(1-((1+sqrt(f_lag(i)))/2)^2);
            if LESF(i) == 1
                if tau_v(i) > Tvl && (alpha_f(i)-alpha0)*(alpha_f(i)-alpha_f(i-1)) > 0
                    CN_V(i) = CN_V(i-1)*exp(-2*ds/Tv0); 
                else
                    CN_V(i) = CN_V(i-1)*exp(-ds/Tv) + (Cv(i)-Cv(i-1))*exp(-0.5*ds/Tv);
                end
            else
                CN_V(i) = CN_V(i-1)*exp(-2*ds/Tv0);
            end
            
            % if sign(CN_V(i)) ~= sign(CN_f(i))
            %     CN_V(i) = 0;
            % end
            
            xcp_v = xcp_c*(1-cos(pi*tau_v(i)/Tvl));
            CM_V(i) = -xcp_v*CN_V(i);
            
            CC_total(i) = CC_f(i);
            CN_total(i) = CN_f(i) + CN_imp(i) + CN_V(i);
            CM_total(i) = CM_f(i) + CM_a_imp(i) + CM_q(i);
    
        end
    end
    CL = CN_total.*cos(a)' + CC_total.*sin(a)';
    CD = CN_total.*sin(a)' - CC_total.*cos(a)' + CD0;
    CM = CM_total';

    

    % plot(a,CN_cir)
    % plot(a,CN_imp)
    % plot(a,CN_pot)
    % plot(a,CC_pot)
    % plot(a,f_orig,a,f)
    % plot(t,a,t,alpha_f)
    % plot(a,f_lag)
    % plot(a,CN_lag)
    % plot(a,CN_f)
    % plot(a,CC_f)
    % plot(Cv)
    % plot(VRTX)
    % plot(CN_V)
    % plot(a,CN_total)
    % plot(a,CC_total)
    % plot(a,CM_total)
end