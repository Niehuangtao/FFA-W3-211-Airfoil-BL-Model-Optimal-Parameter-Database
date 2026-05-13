function conditions = BLPO_build_condition(cfg)
%BLPO_BUILD_CONDITION Create a user-defined pitching-motion condition.

arguments
    cfg.MeanAngleDeg (1,1) double = 5
    cfg.AmplitudeDeg (1,1) double = 10
    cfg.PhaseDeg (1,1) double = 0
    cfg.Re (1,1) double = 1e6
    cfg.Rho (1,1) double = 1.225
    cfg.Mu (1,1) double = 1.8e-5
    cfg.Chord (1,1) double = 1
    cfg.SoundSpeed (1,1) double = 340.3
    cfg.U (1,1) double = 10
    cfg.ReducedFrequency (1,1) double = 0.31
    cfg.FrequencyHz (1,1) double = NaN
    cfg.UseFrequencyHz (1,1) logical = false
    cfg.Cycles (1,1) double = 10
    cfg.StepsPerCycle (1,1) double = 500
end

U = cfg.U;
if ~isfinite(U) || U <= 0
    U = cfg.Re * cfg.Mu / (cfg.Rho * cfg.Chord);
end

if cfg.UseFrequencyHz && isfinite(cfg.FrequencyHz) && cfg.FrequencyHz > 0
    w = 2 * pi * cfg.FrequencyHz;
    ff = cfg.FrequencyHz;
    k = pi * ff * cfg.Chord / U;
else
    k = cfg.ReducedFrequency;
    w = 2 * k * U / cfg.Chord;
    ff = w / (2 * pi);
end

nCycles = max(1, round(cfg.Cycles));
stepsPerCycle = max(50, round(cfg.StepsPerCycle));
n_steps = nCycles * stepsPerCycle + 1;
period = 2 * pi / w;
t = linspace(0, period * nCycles, n_steps);
s = 2 * U * t / cfg.Chord;
ds = s(2) - s(1);
dt = t(2) - t(1);

phase = deg2rad(cfg.PhaseDeg);
aDeg = cfg.MeanAngleDeg - cfg.AmplitudeDeg * sin(w * t + phase);
daDeg = -cfg.AmplitudeDeg * w * cos(w * t + phase);
qDeg = daDeg * cfg.Chord / U;
dqDeg = cfg.AmplitudeDeg * w^2 * cfg.Chord / U * sin(w * t + phase);

M = U / cfg.SoundSpeed;
beta = sqrt(max(0, 1 - M^2));

conditions.a = deg2rad(aDeg);
conditions.da = deg2rad(daDeg);
conditions.q = deg2rad(qDeg);
conditions.dq = deg2rad(dqDeg);
conditions.as = cfg.SoundSpeed;
conditions.beta = beta;
conditions.n_steps = n_steps;
conditions.ds = ds;
conditions.dt = dt;
conditions.U = U;
conditions.M = M;
conditions.s = s;
conditions.t = t;
conditions.w = w;
conditions.ff = ff;
conditions.k = k;
conditions.Re = cfg.Re;
conditions.meanAngleDeg = cfg.MeanAngleDeg;
conditions.amplitudeDeg = cfg.AmplitudeDeg;
conditions.phaseDeg = cfg.PhaseDeg;
conditions.cycles = nCycles;
conditions.stepsPerCycle = stepsPerCycle;
end
