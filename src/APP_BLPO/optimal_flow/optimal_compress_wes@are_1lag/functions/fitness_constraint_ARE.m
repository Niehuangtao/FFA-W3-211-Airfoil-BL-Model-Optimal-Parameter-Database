function [c, ceq] = fitness_constraint_ARE(param, initial_fitness,setcase)
    current_fitness = fitness_ARE(param,setcase);
    c = current_fitness - initial_fitness;
    ceq = [];
end