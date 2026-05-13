function Fitness = fitness_DTW(param, setcase)
%FITNESS_DTW Legacy wrapper for the shared DTW objective.

    Fitness = fitness_metric(param, setcase, 'DTW');
end
