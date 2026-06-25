function [overlap_area,ARE] = area_overlap_ARE(x,x1,y1_data,x2,y2_data)
    y1 = interp1(x1,y1_data,x,'linear','extrap');
    y2 = interp1(x2,y2_data,x,'linear','extrap');
    meandist = mean((y2-y1).^2);
    ARE = mean(abs((y2-y1)./y1));
    y_min = min(y1,y2);
    overlap_area = trapz(x,y_min);
end  