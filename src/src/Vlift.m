function Vlift(start,n_steps,ds,Tv0,CN_V,Cv)
    if start == 2
        CN_V(start-1) = Cv(start-1)*exp(-2*ds/Tv0);
    end
    for i = start : n_steps
        CN_V(i) = CN_V(i) + CN_V(i-1)*exp(-2*ds/Tv0);
    end
end