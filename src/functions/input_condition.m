function conditions = input_condition(meanangle, averageangle, caseConfig)
%INPUT_CONDITION Build kinematic and flow conditions for the BL model.

    if nargin < 3 || isempty(caseConfig)
        caseConfig = struct();
    end

    Re = get_struct_value(caseConfig, 'Re', 1e6);
    miu = get_struct_value(caseConfig, 'miu', 1.8e-5);
    rho = get_struct_value(caseConfig, 'rho', 1.225);
    c = get_struct_value(caseConfig, 'chord', 0.6);
    as = get_struct_value(caseConfig, 'soundSpeed', 340.3);
    ff = get_struct_value(caseConfig, 'frequency', 0.6);
    nCycles = get_struct_value(caseConfig, 'nCycles', 10);
    n_steps = get_struct_value(caseConfig, 'nSteps', 5000);

    U = Re * miu / rho / c;
    M = U / as;
    beta = sqrt(1 - M^2);
    k = pi * ff * c / U;
    w = 2 * pi * ff;

    T = 2 * pi / w * nCycles;
    t = linspace(0, T, n_steps);
    s = 2 * U * t / c;
    ds = s(2) - s(1);
    dt = t(2) - t(1);

    [a, da, q, dq] = get_a_q(meanangle, averageangle, w, c, U, t);

    conditions.a = a;
    conditions.da = da;
    conditions.q = q;
    conditions.dq = dq;
    conditions.as = as;
    conditions.beta = beta;
    conditions.n_steps = n_steps;
    conditions.nCycles = nCycles;
    conditions.ds = ds;
    conditions.dt = dt;
    conditions.U = U;
    conditions.M = M;
    conditions.s = s;
    conditions.t = t;
    conditions.w = w;
    conditions.ff = ff;
    conditions.k = k;
    conditions.Re = Re;
    conditions.c = c;
end
