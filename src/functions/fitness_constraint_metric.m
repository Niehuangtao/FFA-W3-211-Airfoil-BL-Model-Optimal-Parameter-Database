function [c, ceq] = fitness_constraint_metric(param, defaultFitness, setcase, metricName)
%FITNESS_CONSTRAINT_METRIC Optional guard that prevents candidates worse than the default fit.

    currentFitness = fitness_metric(param, setcase, metricName);
    c = currentFitness - defaultFitness;
    ceq = [];
end
