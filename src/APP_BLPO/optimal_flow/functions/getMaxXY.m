function [x_test_max,y_test_max] = getMaxXY(x,y)
    y_test_max = max(y);
    idx = y == y_test_max;
    x_test_max = x(idx);
end