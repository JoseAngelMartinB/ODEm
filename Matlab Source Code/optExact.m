function [ x_opt, f_opt, results, output_f] = optExact( f, LB, UB, population, opt )

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   f - function to optimize
%   LB - Lower bound to define space´s restrictions
%   UB - Upper bound to define space´s restrictions
%   population - population   
%   opt - Options to configure different exact algorithms
%       alg - the name of the exact algorithm: 'active-set', 'interior-point', 'sqp', 'nealder-mead', 'pattern-search' 
%       display - in order to print results each iteration: 'iter', 'none'
%       tolcon - specifies ..... : '1e-12'
%       fe_max - maximum number of the objective function evaluations
%       into_heuristic - the case in which the alg. accelerates an alg.heuristic
%
%--- OUTPUT ------
%   x_opt - is the solution vector of points
%   f_opt - is the value of the optimized quality function
%   results - evolution of values objetive function 
%   output_f - information about algorithms evaluations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%
    %   Setting options
    %%%%%%%%

    alg_exacts = {'active-set','interior-point','sqp'};
    
    algorithm = opt.alg;
    display = opt.display;
    tolCon = opt.tolcon;
    FE_max = opt.fe_max;
    into_heuristic = opt.into_heuristic;
 
    rows = size(population, 1);
    x_opt = population(randi(rows),:);
    f_opt = realmax;
    output_f.time = 0;
    
    if into_heuristic
        disp(' - - - - - - - - - - - - - - - - - - -');
        disp(['Ejecutando: ' algorithm]);
    end
    
    %%%%%%%%%%
    %   Execution
    %%%%%%%%%%
    
    if strcmp(algorithm,'nealder-mead')
        
        f_nm = @(x) f(max(min(x,UB),LB)); % projections on the feasible set (NM Algorithm)
        options = optimset('Display',display,'MaxFunEvals',FE_max);
        
        if ~into_heuristic
            tic;
        end
        
        [x_opt, f_opt, exitflag, output_f]=fminsearch(f_nm,population(randi(rows),:),options);
        output_f.time = toc;
        
        x_opt = max(min(x_opt,UB),LB);
    
    elseif strcmp(algorithm,'pattern-search')
  
        options=psoptimset('MaxFunEvals',FE_max,'Display',display,'PollingOrder','Success');
        
        if ~into_heuristic
            tic;
        end
        
        [x_opt, f_opt, exitflag, output_f]=patternsearch(f,population(randi(rows),:),[],[],[],[],LB,UB,[],options);
        output_f.time = toc;
        
    elseif (ismember(algorithm, alg_exacts))
       
        options = optimoptions('fmincon', 'Algorithm', algorithm, 'Display', display, 'TolCon', tolCon);
        options.MaxFunEvals = FE_max;
        
        if ~into_heuristic
            tic;
        end
        
%         population_aux = max(min(population(randi(rows),:),UB-+10^(-6)),LB+10^(-6))';
        
        [x_opt, f_opt, exitflag, output_f]=fmincon(f,population(randi(rows),:),[],[],[],[],LB,UB,[],options);
        output_f.time = toc;
        
    end
    
    if (isfield(output_f, 'funcCount') == 0) % number of real evaluations of the function
        output_f.funcCount = FE_max;
    end
    
    results = [f_opt, output_f.funcCount, output_f.time]; % only the final result
    
    % print final results
    
    if into_heuristic
        msg_time = 'Time elapsed';
        msg_start = ['- - - - - - ', algorithm, ' - - - - - -'];
        msg_final = '- - - - - - - - - - - - - - - - - - - -';
    else
        msg_time = 'Total time';
        msg_start = ['*********  FINAL RESULTS ', algorithm, '*************************'];
        msg_final = '**********************************************************************';
    end
    
    disp(msg_start);
    g = sprintf('%f ', x_opt);
    fprintf('x opt: %s\n', g);
    fprintf('f value: %f\n', f_opt);
    fprintf('Number of evaluations: %d\n', output_f.funcCount);
    fprintf('%s: %f seconds\n', msg_time, output_f.time);
    disp(msg_final);
   
end

