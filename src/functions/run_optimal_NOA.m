function [para_local, result] = run_optimal_NOA(para_default, ~, lb, ub, setcase, varargin)
%RUN_OPTIMAL_NOA Wrapper for non-overlap-area BL parameter optimization.

    [gaConfig, outputDir] = parse_legacy_optimizer_options(varargin{:});
    [para_local, result] = run_optimal_metric('NOA', para_default, lb, ub, setcase, gaConfig, outputDir);
end
