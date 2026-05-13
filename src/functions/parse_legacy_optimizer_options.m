function [gaConfig, outputDir] = parse_legacy_optimizer_options(varargin)
%PARSE_LEGACY_OPTIMIZER_OPTIONS Optional args shared by legacy wrappers.

    gaConfig = struct();
    outputDir = pwd;

    if nargin >= 1 && ~isempty(varargin{1})
        gaConfig = varargin{1};
    end

    if nargin >= 2 && ~isempty(varargin{2})
        outputDir = varargin{2};
    end
end
