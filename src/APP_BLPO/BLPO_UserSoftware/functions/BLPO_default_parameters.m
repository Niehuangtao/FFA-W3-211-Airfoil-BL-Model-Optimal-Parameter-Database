function params = BLPO_default_parameters()
%BLPO_DEFAULT_PARAMETERS Return baseline BL model parameters and bounds.

params.lagLabels = {'S1','S2','S3','S4'};
params.clLabels = {'A1','b1','A2','b2','Tp','Tf0','Tvl','Tv0','yita'};
params.cmLabels = {'A3','b3','A4','b4','A5','b5','k0','k1','k2','k3','xcp'};
params.labels = [params.lagLabels, params.clLabels, params.cmLabels];

params.lag = [2 5 2 5];
params.cl = [0.3 0.3 0.3 0.3 5 1 8 2 0.95];
params.cm = [0.2 0.1 0.1 0.1 0.1 0.3 0.02 0.02 0.02 0.02 0.2];
params.vector = [params.lag, params.cl, params.cm];

params.lbLag = [0 0 0 0];
params.ubLag = [40 40 40 40];
params.lbCl = [0 0 0 0 0 0 0 0 0.80];
params.ubCl = [0.8 0.8 0.8 0.8 10 5 15 5 0.95];
params.lbCm = [0 0 0 0 0 0 0 0 0 0 0];
params.ubCm = [0.5 0.5 0.5 0.5 0.5 0.5 1 1 1 1 0.5];
params.lb = [params.lbLag, params.lbCl, params.lbCm];
params.ub = [params.ubLag, params.ubCl, params.ubCm];
end
