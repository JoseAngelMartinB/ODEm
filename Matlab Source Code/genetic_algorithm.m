function [ x_opt, f_opt, results, output_f ] = genetic_algorithm( f, LB, UB, population, opt, options_exact )

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   f - function to optimize
    %   LB - Lower bound to define space´s restrictions
    %   UB - Upper bound to define space´s restrictions
    %   population - matrix of population: each row is a set of points   
    %   opt - Options to configure different exact algorithms
    %       mfinal - maximum number of successful evaluations 
    %       display - in order to print results each iteration: 'iter', 'none'
    %       FE_max - maximum number of iterations to be reinitialized
    %       pob_size - absolute size of the population
    %       valgenlimit - number of populations without changes
    %       n - total number of variables: number of points per number of var
    %       tolfun - ........
    %   options_exact - options related to exact algorithms
    %
    %--- OUTPUT ------
    %   x_opt - is the solution vector of points
    %   f_opt - is the value of the optimized quality function
    %   results - funcion´s value of each iteration
    %   output_f - information about algorithms evaluations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%
    % Setting options
    %%%%%%%%%
    
    global best_solution_consola iter_cont_consola time_cont_consola;  % This variable is necesary to store the results to be shown by screen 
    best_solution_consola=[];   % Initialization
    iter_cont_consola=[];
    time_cont_consola = [];
    global GAdatos;              % Structure that contains the data for the GA
    
    GAdatos.M=0;    
    GAdatos.fval=realmax;
    GAdatos.funcCount = 0;
    GAdatos.Mfinal=opt.mfinal;
    GAdatos.fun=f;
    GAdatos.LB=LB;
    GAdatos.UB=UB;
    GAdatos.options_exact = options_exact;
    
    displ = opt.display;
    FE_max = opt.FE_max;
    PopulationSize = opt.pob_size;
    ValStallGenLimit = opt.valgenlimit;
    N = opt.n;
    tolfun = opt.tolfun;
    
    Generations= ceil(FE_max/PopulationSize); 
    
    options=gaoptimset('OutputFcn', @myoutputGA1,'Display',displ,'Generations',Generations,...
        'InitialPopulation',population,'PopulationSize',PopulationSize,'TolFun',tolfun,'StallGenLimit',ValStallGenLimit);
    
    %%%%%%%%%
    % Execution
    %%%%%%%%%
    
    tic;
    [x_opt,f_opt,exitFlag,output_f,population,scores]=ga(f,N,[],[],[],[],LB,UB,[],options);
  
    output_f.time = toc;
    output_f.funcCount = GAdatos.funcCount;
    
    results = [best_solution_consola; iter_cont_consola; time_cont_consola]';
 
    % Print total results
    
    if opt.mfinal == Inf
        msg = 'Genetic Algorithm';
    else
        msg = ['Genetic Algorithm', ' ', options_exact.alg];
    end
        
    disp(['*********  FINAL RESULTS ', msg, '  *************************']);
    g = sprintf('%f ', x_opt);
    fprintf('x opt: %s\n', g);
    fprintf('f value: %f\n', f_opt);
    fprintf('Number of evaluations: %d\n', output_f.funcCount);
    fprintf('Total time: %f seconds\n', output_f.time);
    disp('**********************************************************************');

end

