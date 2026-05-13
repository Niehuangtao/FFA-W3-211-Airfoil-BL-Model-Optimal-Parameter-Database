function [c, ceq] = fitness_constraint_DTW(param, default_fitness, setcase)
%FITNESS_CONSTRAINT_DTW Legacy wrapper for the shared DTW constraint.

    [c, ceq] = fitness_constraint_metric(param, default_fitness, setcase, 'DTW');
end
