function [c, ceq] = fitness_constraint_lag(para_init_lag,para_init_cl,para_init_cm, initial_fitness,setcase)
    current_fitness = fitness_lag(para_init_lag,para_init_cl,para_init_cm,setcase);
    c = current_fitness - initial_fitness;
    ceq = [];
end