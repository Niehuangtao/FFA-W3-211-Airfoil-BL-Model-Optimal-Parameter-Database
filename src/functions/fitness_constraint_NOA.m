function [c, ceq] = fitness_constraint_NOA(param, default_fitness, setcase)
%FITNESS_CONSTRAINT_NOA Wrapper for the shared NOA constraint.

    [c, ceq] = fitness_constraint_metric(param, default_fitness, setcase, 'NOA');
end
