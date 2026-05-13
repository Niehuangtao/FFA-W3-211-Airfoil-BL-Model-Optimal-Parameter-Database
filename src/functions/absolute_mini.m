function mini = absolute_mini(x1,x2)
    X = [x1
        x2];
    mini = zeros(1,length(x1));
    for i = 1 : length(x1)
        [~, idx] = min(X(i,:));
        mini(i) = X(i,idx);
    end
end