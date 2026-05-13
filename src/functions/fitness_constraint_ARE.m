function [c, ceq] = fitness_constraint_ARE(param, default_fitness, setcase)
%FITNESS_CONSTRAINT_ARE Legacy wrapper for the shared ARE constraint.

    [c, ceq] = fitness_constraint_metric(param, default_fitness, setcase, 'ARE');
end
