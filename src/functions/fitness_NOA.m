function Fitness = fitness_NOA(param, setcase)
%FITNESS_NOA Wrapper for the shared non-overlap-area objective.

    Fitness = fitness_metric(param, setcase, 'NOA');
end
