function [ x_opt, f_opt, results, output_f ] = spso( f, LB, UB, population, opt, options_exact )

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Ródenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   f - function to optimize
    %   LB - Lower bound to define space�s restrictions
    %   UB - Upper bound to define space�s restrictions
    %   population - matrix of population: each row is a set of points   
    %   opt - Options to configure different exact algorithms
    %       err - error value related to spso algorithm
    %       opt_f - value ......
    %       norm - ........
    %       FE_max - maximum number of iterations to be reinitialized
    %       nc - number of successful evaluations
    %       pob_size - absolute size of the population
    %       n - total number of variables: number of points per number of var
    %       display - in order to print results each iteration: 'iter', 'none'
    %       mfinal - maximum number of successful evaluations
    %   options_exact - options related to exact algorithms
    %
    %--- OUTPUT ------
    %   x_opt - is the solution vector of points
    %   f_opt - is the value of the optimized quality function
    %   results - funcion�s value of each iteration
    %   output_f - information about algorithms evaluations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Setting options
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    err = opt.err;
    opt_f = opt.opt_f;
    normalize = opt.norm;
    FE_max = opt.FE_max;
    nc = opt.nc;
    PopulationSize = opt.pob_size;
    N = opt.n;
    global more_opt;
    displ = more_opt.iter_results;
    %displ = opt.display;
    Mfinal = opt.mfinal;
    
    % Enviroment size
    if (nc==3)
        K=3;
    else
        K=PopulationSize;
    end
    
    %%%%%%%%%
    % Execution
    %%%%%%%%%
    
    tic;
    [x_opt, f_opt, max_FEs, evolt, evolbest_f, evolt_time] = SPSO2011_NM(PopulationSize,N, FE_max, f, err, LB, UB, opt_f,normalize,Mfinal,population,K,displ,options_exact);
    
    output_f.time = toc;
    evolt(find(evolt<0))=[];
    evolbest_f=evolbest_f(1:length(evolt));
    results = [evolbest_f; evolt; evolt_time]';
    output_f.funcCount = max_FEs;
    
    % Print final results
   
    if opt.mfinal == Inf
        msg = 'SPSO 2011';
    else
        msg = ['SPSO 2011', ' ', options_exact.alg];
    end
    
    disp(['*********  FINAL RESULTS ', msg, '  *************************']);
    g = sprintf('%f ', x_opt);
    fprintf('x opt: %s\n', g);
    fprintf('f value: %f\n', f_opt);
    fprintf('Number of evaluations: %d\n', output_f.funcCount);
    fprintf('Total time: %f seconds\n', output_f.time);
    disp('**********************************************************************');

end

