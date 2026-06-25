function maxi = absolute_maxi(x1,x2)
    X = [x1,x2];
    maxi = zeros(1,length(x1));
    for i = 1 : length(x1)
        [~, idx] = max(X(i,:));
        maxi(i) = X(i,idx);
    end
end