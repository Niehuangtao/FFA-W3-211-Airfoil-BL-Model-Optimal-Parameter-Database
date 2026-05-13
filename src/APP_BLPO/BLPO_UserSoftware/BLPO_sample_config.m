function cfg = BLPO_sample_config()
%BLPO_SAMPLE_CONFIG Default UI/CLI configuration.

root = fileparts(mfilename("fullpath"));

cfg.meanAngleDeg = 5;
cfg.amplitudeDeg = 10;
cfg.phaseDeg = 0;
cfg.Re = 1e6;
cfg.rho = 1.225;
cfg.mu = 1.8e-5;
cfg.chord = 1;
cfg.soundSpeed = 340.3;
cfg.U = 10;
cfg.reducedFrequency = 0.31;
cfg.frequencyHz = NaN;
cfg.useFrequencyHz = false;
cfg.cycles = 10;
cfg.stepsPerCycle = 500;

cfg.polarFile = fullfile(root, "sample_data", "FFA_W3_211.txt");
cfg.CD0 = 1.5;
cfg.CM0 = 0.01;
cfg.alpha1Deg = 12;
cfg.alpha2Deg = -10;
cfg.CN1 = 1.7;
cfg.CN2 = -1;
cfg.slope = 7;
cfg.xAC = 0.25;
cfg.xcpC = 0.2;
end
