function [para_local, result] = run_optimal_DTW(para_default, ~, lb, ub, setcase, varargin)
%RUN_OPTIMAL_DTW Legacy wrapper for DTW-based BL parameter optimization.

    [gaConfig, outputDir] = parse_legacy_optimizer_options(varargin{:});
    [para_local, result] = run_optimal_metric('DTW', para_default, lb, ub, setcase, gaConfig, outputDir);
end
