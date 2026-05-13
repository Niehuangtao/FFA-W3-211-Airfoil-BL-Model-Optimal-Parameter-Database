function [para_local, result] = run_optimal_ARE(para_default, ~, lb, ub, setcase, varargin)
%RUN_OPTIMAL_ARE Legacy wrapper for ARE-based BL parameter optimization.

    [gaConfig, outputDir] = parse_legacy_optimizer_options(varargin{:});
    [para_local, result] = run_optimal_metric('ARE', para_default, lb, ub, setcase, gaConfig, outputDir);
end
