function [x_test_min,y_test_min] = getMinXY(x,y)
    y_test_min = min(y);
    idx = y == y_test_min;
    x_test_min = x(idx);
end