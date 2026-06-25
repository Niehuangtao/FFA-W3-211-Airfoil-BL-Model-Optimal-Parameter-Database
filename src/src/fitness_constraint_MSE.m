function [c, ceq] = fitness_constraint_MSE(param, initial_fitness,setcase)
    current_fitness = fitness_MSE(param,setcase);
    c = current_fitness - initial_fitness;
    ceq = [];
end