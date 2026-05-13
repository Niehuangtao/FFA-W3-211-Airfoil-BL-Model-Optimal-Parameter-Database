function [c, ceq] = fitness_constraint_MSE(param, default_fitness, setcase)
%FITNESS_CONSTRAINT_MSE Legacy wrapper for the shared MSE constraint.

    [c, ceq] = fitness_constraint_metric(param, default_fitness, setcase, 'MSE');
end
