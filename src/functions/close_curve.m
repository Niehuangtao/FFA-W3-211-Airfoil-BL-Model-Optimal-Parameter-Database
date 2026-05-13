function closedData = close_curve(data, stride)
%CLOSE_CURVE Downsample a hysteresis curve and append the first point.

    if nargin < 2 || isempty(stride)
        stride = 1;
    end

    data = data(~any(~isfinite(data), 2), :);
    if isempty(data)
        closedData = data;
        return;
    end

    idx = 1:stride:size(data, 1);
    closedData = data(idx, :);

    if any(closedData(end, :) ~= data(1, :))
        closedData = [closedData; data(1, :)];
    end
end
