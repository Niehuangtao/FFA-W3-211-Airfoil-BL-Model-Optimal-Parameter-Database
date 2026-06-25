clear; clc; close all;

repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(repoRoot, 'src')));

% Parameter order:
% [A1, b1, A2, b2, Tp, Tf0, Tvl, Tv0, yita]
lb = [0, 0, 0, 0, 0, 0, 0, 0, 0.85];
ub = [0.8, 0.8, 0.8, 0.8, 10, 5, 15, 5, 0.95];
para_init = [0.3, 0.3, 0.3, 0.3, 5, 1, 8, 2, 0.95];
Npara = numel(lb);

meanangle = -9.4;
averageangle = 7;
conditions = input_condition(meanangle, averageangle);
airfoildata = input_afdata();

setcase.meanangle = meanangle;
setcase.averageangle = averageangle;
setcase.conditions = conditions;
setcase.airfoldata = airfoildata;
setcase.CFDdatapath = resolve_data_file('re5e5_i9.4_f2.4.txt', 'cfd');

objectiveName = 'MSE'; % Options: MSE, DTW, ARE, GZ

switch upper(objectiveName)
    case 'MSE'
        para_local = run_optimal_MSE(para_init, Npara, lb, ub, setcase);
        compare_optimal_result_MSE(para_local, para_init, setcase);
    case 'DTW'
        para_local = run_optimal_DTW(para_init, Npara, lb, ub, setcase);
        compare_optimal_result_DTW(para_local, para_init, setcase);
    case 'ARE'
        para_local = run_optimal_ARE(para_init, Npara, lb, ub, setcase);
        compare_optimal_result_ARE(para_local, para_init, setcase);
    case 'GZ'
        para_local = run_optimal_GZ(para_init, Npara, lb, ub, setcase);
        compare_optimal_result_GZ(para_local, para_init, setcase);
    otherwise
        error('Unsupported objective: %s', objectiveName);
end
