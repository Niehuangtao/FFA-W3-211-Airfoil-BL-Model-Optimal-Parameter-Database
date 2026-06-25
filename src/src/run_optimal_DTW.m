function para_local = run_optimal_DTW(para_init,Npara,lb,ub,setcase)
    tic
    % 4. Objective function
    fitnessFcn = @(param) fitness_DTW(param,setcase);
    initial_fitness = fitness_DTW(para_init,setcase);
    nonlcon = @(param) fitness_constraint_DTW(param, initial_fitness,setcase);
    
    % 5. Global optimization and genetic algorithm settings 
    globaloptions = optimoptions('ga',    ...
        'PopulationSize', 256,      ...     % Population size
        'MaxGenerations', 50,      ...     % Maximum generations
        'FunctionTolerance',1e-4,   ...    
        'ConstraintTolerance',1e-4, ...  
        'Display','iter',           ...   
        'InitialPopulationMatrix', para_init, ...
        'UseParallel',true);         
    
    % 6. Run evolutionary optimization
    fprintf('===== Starting dynamic-stall BL parameter optimization [CFD fit + area similarity] =====\n'); 
    [para_local, fitness_opt] = ga(fitnessFcn, Npara, [], [], [], [], lb, ub, nonlcon, globaloptions);
    fprintf('===== Optimization completed. Best fitness = %.8f =====\n', fitness_opt);
    
    % % 7. Local optimization
    % fminconOpts = optimoptions('fmincon', ...
    %     'Algorithm', 'sqp', ...
    %     'Display', 'iter', ... 
    %     'MaxFunctionEvaluations', 50, ... 
    %     'OptimalityTolerance', 1e-8, ...
    %     'StepTolerance', 1e-10,...
    %     'UseParallel',true);
    % 
    % % 8. Run local optimization
    % fprintf('===== Starting fmincon local optimization =====\n');
    % para1 = para_global;  % Use the GA optimum as the initial point
    % [para_local, f_opt] = fmincon(fitnessFcn, para1, [], [], [], [], lb, ub, nonlcon, fminconOpts);
    % fprintf('===== Local optimization completed: best fitness = %.10f =====\n', f_opt);
    
    % 7. Print and save results
    para_label = {'A1','b1','A2','b2','Tp','Tf0','Tvl','Tv0','yita'};
    fprintf('\n==================== Initial vs Optimized Parameter Comparison ====================\n');
    fprintf('Initial fitness=%.6f | Optimized fitness=%.6f\n', fitness_DTW(para_init,setcase), fitness_DTW(para_local,setcase));
    for i = 1:Npara
        fprintf('%5s : Initial value=%.6f | Optimized value=%.6f\n', para_label{i}, para_init(i), para_local(i));
    end
    [A1,b1,A2,b2,Tp,Tf0,Tvl,Tv0,yita] = deal(para_local(:));
    outputFile = fullfile(generated_results_dir(), 'bl_cfd_final_optimized_parameters_DTW.mat');
    save(outputFile,'para_local','fitness_opt');
    fprintf('\nOptimization results saved to: %s\n', outputFile);
    toc
end
