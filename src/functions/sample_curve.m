function sampledData = sample_curve(data, stride)
%SAMPLE_CURVE Downsample a curve without closing the loop.

    if nargin < 2 || isempty(stride)
        stride = 1;
    end

    data = data(~any(~isfinite(data), 2), :);
    if isempty(data)
        sampledData = data;
        return;
    end

    sampledData = data(1:stride:end, :);
end
