function Fitness = fitness_MSE(param, setcase)
%FITNESS_MSE Legacy wrapper for the shared MSE objective.

    Fitness = fitness_metric(param, setcase, 'MSE');
end
