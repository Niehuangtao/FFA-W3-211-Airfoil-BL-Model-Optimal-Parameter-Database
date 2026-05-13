function config = bl_default_config(projectRoot)
%BL_DEFAULT_CONFIG Central configuration for the BL optimization workflow.

    if nargin < 1 || isempty(projectRoot)
        projectRoot = pwd;
    end

    config.projectRoot = projectRoot;
    config.outputDir = projectRoot;

    config.case.meanangle = 9.6;
    config.case.averageangle = 7;
    config.case.Re = 1e6;
    config.case.frequency = 0.6;
    config.case.chord = 0.6;
    config.case.nCycles = 10;
    config.case.nSteps = 5000;
    config.case.windowCycles = [7 8];

    config.files.airfoil = fullfile(projectRoot, 'FFA_W3_211.txt');
    config.files.reference = fullfile(projectRoot, 'reference_data', 're1e6_9.6_f0.6.txt');

    config.reference.type = 'alphaCoefficient';   % alphaCoefficient / timeSeries
    config.reference.coefficient = 'CN';          % CN, CL, CD, or CM for alphaCoefficient data
    config.reference.timeSeriesTargets = {'CL'};  % Sequential stages for timeSeries data: CL, CD, CM

    config.parameters.names = {'A1', 'b1', 'A2', 'b2', 'Tp', 'Tf0', 'Tvl', 'Tv0', 'yita'};
    config.parameters.lower = [0, 0, 0, 0, 0, 0, 0, 0, 0.85];
    config.parameters.upper = [0.8, 0.8, 0.8, 0.8, 10, 5, 15, 5, 0.95];
    config.parameters.default = [0.3, 0.3, 0.3, 0.3, 5, 1, 8, 2, 0.95];

    config.metrics = {'DTW', 'NOA'};

    config.ga.PopulationSize = 256;
    config.ga.MaxGenerations = 50;
    config.ga.FunctionTolerance = 1e-4;
    config.ga.ConstraintTolerance = 1e-4;
    config.ga.Display = 'iter';
    config.ga.UseParallel = true;
    config.ga.EnforceDefaultImprovement = false;

    config.plot.sampleStride = 10;
    config.plot.fontSize = 15;
    config.plot.lineWidth = 1.2;
    config.plot.fileBaseName = 'opt_compare';
end
