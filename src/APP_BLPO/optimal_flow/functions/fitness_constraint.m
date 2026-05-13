function [c, ceq] = fitness_constraint(param, initial_fitness,setcase)
    current_fitness = fitness(param,setcase);
    c = current_fitness - initial_fitness;
    ceq = [];
end