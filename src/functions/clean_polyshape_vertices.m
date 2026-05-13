function [xClean, yClean] = clean_polyshape_vertices(x, y)
%CLEAN_POLYSHAPE_VERTICES Remove invalid and repeated adjacent vertices.

    points = [x(:), y(:)];
    points = points(all(isfinite(points), 2), :);

    if isempty(points)
        xClean = [];
        yClean = [];
        return;
    end

    tolerance = max(eps(max(abs(points), [], 'all')), eps);
    keep = [true; any(abs(diff(points, 1, 1)) > tolerance, 2)];
    points = points(keep, :);

    if size(points, 1) > 1 && all(abs(points(1, :) - points(end, :)) <= tolerance)
        points(end, :) = [];
    end

    xClean = points(:, 1);
    yClean = points(:, 2);
end
