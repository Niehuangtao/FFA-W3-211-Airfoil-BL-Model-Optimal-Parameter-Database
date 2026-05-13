function [para_local, result] = run_optimal_MSE(para_default, ~, lb, ub, setcase, varargin)
%RUN_OPTIMAL_MSE Legacy wrapper for MSE-based BL parameter optimization.

    [gaConfig, outputDir] = parse_legacy_optimizer_options(varargin{:});
    [para_local, result] = run_optimal_metric('MSE', para_default, lb, ub, setcase, gaConfig, outputDir);
end
