function [c, ceq] = fitness_constraint_GZ(param, initial_fitness,setcase)
    current_fitness = fitness_GZ(param,setcase);
    c = current_fitness - initial_fitness;
    ceq = [];
end