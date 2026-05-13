function [c, ceq] = fitness_constraint_DTW(param, initial_fitness,setcase)
    current_fitness = fitness_DTW(param,setcase);
    c = current_fitness - initial_fitness;
    ceq = [];
end