function para_local = run_optimal_ARE(para_init,Npara,lb,ub,setcase)
    tic
    % 4. 目标函数
    fitnessFcn = @(param) fitness_ARE(param,setcase);
    initial_fitness = fitness_ARE(para_init,setcase);
    nonlcon = @(param) fitness_constraint_ARE(param, initial_fitness,setcase);
    
    % 5. 全局优化，遗传算法配置 
    globaloptions = optimoptions('ga',    ...
        'PopulationSize', 256,      ...     % 种群规模
        'MaxGenerations', 50,      ...     % 迭代次数
        'FunctionTolerance',1e-4,   ...    
        'ConstraintTolerance',1e-4, ...  
        'Display','iter',           ...   
        'InitialPopulationMatrix', para_init, ...
        'UseParallel',true);         
    
    % 6. 运行进化算法寻优
    fprintf('===== 动态失速BL模型参数优化开始【CFD拟合+面积相似度】 =====\n'); 
    [para_local, fitness_opt] = ga(fitnessFcn, Npara, [], [], [], [], lb, ub, nonlcon, globaloptions);
    fprintf('===== 优化完成！最优适应度值 = %.8f =====\n', fitness_opt);
    
    % % 7. 局部优化
    % fminconOpts = optimoptions('fmincon', ...
    %     'Algorithm', 'sqp', ...
    %     'Display', 'iter', ... 
    %     'MaxFunctionEvaluations', 50, ... 
    %     'OptimalityTolerance', 1e-8, ...
    %     'StepTolerance', 1e-10,...
    %     'UseParallel',true);
    % 
    % % 8. 运行局部最优化
    % fprintf('===== fmincon 局部优化开始 =====\n');
    % para1 = para_global;  % 使用 GA 的最优解作为初始值
    % [para_local, f_opt] = fmincon(fitnessFcn, para1, [], [], [], [], lb, ub, nonlcon, fminconOpts);
    % fprintf('===== 局部优化完成：最优适应度值 = %.10f =====\n', f_opt);
    
    % 7. 结果输出+保存
    para_label = {'A1','b1','A2','b2','Tp','Tf0','Tvl','Tv0','yita'};
    fprintf('\n==================== 原始参数 ↔ 优化后最优参数 对比表 ====================\n');
    fprintf('原始适应度=%.6f | 优化适应度=%.6f\n', fitness_ARE(para_init,setcase), fitness_ARE(para_local,setcase));
    for i = 1:Npara
        fprintf('%5s : 原始值=%.6f | 优化值=%.6f\n', para_label{i}, para_init(i), para_local(i));
    end
    [A1,b1,A2,b2,Tp,Tf0,Tvl,Tv0,yita] = deal(para_local(:));
    save('BL模型_CFD拟合_最终优化参数_ARE.mat','para_local','fitness_opt');
    fprintf('\n优化结果已保存至：BL模型_CFD拟合_最终优化参数.mat\n');
    toc
end