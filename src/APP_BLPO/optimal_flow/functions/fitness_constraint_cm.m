function [c, ceq] = fitness_constraint_cm(para_local_lag,para_local_cl,para_init_cm, initial_fitness,setcase)
    current_fitness = fitness_lag(para_local_lag,para_local_cl,para_init_cm,setcase);
    c = current_fitness - initial_fitness;
    ceq = [];
end