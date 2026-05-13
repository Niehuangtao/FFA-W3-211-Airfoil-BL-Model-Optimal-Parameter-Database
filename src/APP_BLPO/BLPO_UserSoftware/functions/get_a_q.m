function [a,da,q,dq] = get_a_q(Am,A,w,c,U,t)
    a_deg  = Am + A * sin(w * t);
    da_deg = A * w * cos(w * t);
    q_deg  = da_deg * c / U;
    dq_deg = -A * w^2 * c / U * sin(w * t);

    a  = deg2rad(a_deg);
    da = deg2rad(da_deg);
    q  = deg2rad(q_deg);
    dq = deg2rad(dq_deg);
end
