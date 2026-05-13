function [overlap_area,RMSE] = area_overlap(x,x1,y1_data,x2,y2_data)
    y1 = interp1(x1,y1_data,x,'spline','extrap');
    y2 = interp1(x2,y2_data,x,'spline','extrap');
    RMSE = sqrt(mean(y2-y1).^2);
    y_min = min(y1,y2);
    overlap_area = trapz(x,y_min);
end