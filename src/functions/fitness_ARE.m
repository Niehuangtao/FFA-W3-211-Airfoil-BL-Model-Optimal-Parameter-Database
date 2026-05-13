function Fitness = fitness_ARE(param, setcase)
%FITNESS_ARE Legacy wrapper for the shared ARE objective.

    Fitness = fitness_metric(param, setcase, 'ARE');
end
