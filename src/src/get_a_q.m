function [a,da,q,dq] = get_a_q(Am,A,w,c,U,t)
    syms time
    a_sym  = Am + A * sin(w * time);
    da_sym = diff(a_sym, time)     ;  
    q_sym  = da_sym * c / U        ;
    dq_sym = diff(q_sym, time)     ;
    
    a_sym_val  = subs(a_sym, time, t) ;
    da_sym_val = subs(da_sym, time, t);
    q_sym_val  = subs(q_sym, time, t) ;
    dq_sym_val = subs(dq_sym, time, t);
    
    a  = deg2rad(double(a_sym_val)) ;
    da = deg2rad(double(da_sym_val));
    q  = deg2rad(double(q_sym_val)) ;
    dq = deg2rad(double(dq_sym_val));
end