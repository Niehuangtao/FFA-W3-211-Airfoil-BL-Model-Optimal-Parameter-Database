function [modelCoeff, refCoeff] = resample_coefficients(modelCoeffRaw, refCoeffRaw, nSamples)
%RESAMPLE_COEFFICIENTS Put model and reference curves on a common normalized axis.

    if nargin < 3 || isempty(nSamples)
        nSamples = 500;
    end

    xCommon = linspace(1, numel(refCoeffRaw), nSamples);
    xModel = linspace(1, numel(refCoeffRaw), numel(modelCoeffRaw));
    xRef = linspace(1, numel(refCoeffRaw), numel(refCoeffRaw));

    modelCoeff = interp1(xModel, modelCoeffRaw(:), xCommon, 'linear', 'extrap');
    refCoeff = interp1(xRef, refCoeffRaw(:), xCommon, 'linear', 'extrap');

    modelCoeff = modelCoeff(:);
    refCoeff = refCoeff(:);
end
