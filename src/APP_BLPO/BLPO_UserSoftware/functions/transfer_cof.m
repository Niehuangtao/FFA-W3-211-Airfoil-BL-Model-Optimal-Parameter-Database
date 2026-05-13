function [Cn , Ct] = transfer_cof(data)
    a     = data(:,1)*pi/180;
    cl    = data(:,2);
    cd    = data(:,3);

    Cn = zeros(length(a),1);
    Ct = zeros(length(a),1);

    for i = 1 : length(a)
        cn = cd(i) * sin(a(i)) + cl(i) * cos(a(i));
        ct = cl(i) * sin(a(i)) - cd(i) * cos(a(i));
        Cn(i) = cn;
        Ct(i) = ct;
    end

end