function [ x_opt, f_opt, results, output_f] = simulated_annealing( f, LB, UB, population, opt, options_exact )

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
    %       display - in order to print results each iteration: 'iter', 'none'
    %       FE_max - maximum number of iterations to be reinitialized
    %       FE_max_SA - number of iterations of the SA to be reinitialized
    %       in SA, to consider a number of population
    %       pob - size of the population
    %       nc - number of successful evaluations
    %       mfinal - maximum number of successful evaluations
    %       problem - characteristics of the objetive function
    %   options_exact - options related to exact algorithms
    %
    %--- OUTPUT ------
    %   x_opt - is the solution vector of points
    %   f_opt - is the value of the optimized quality function
    %   results - funcion´s value of each iteration
    %   output_f - information about algorithms evaluations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%
    % Setting options
    %%%%%%
    global  best_solution_consola_sa best_fval_sa;
    best_solution_consola_sa = [];
    best_fval_sa = realmax;
    
    pob = opt.pob;
    nc = opt.nc;
    FE_max_SA = opt.FE_max_SA;
    FE_max = opt.FE_max;
    lim_max_evals = 0;
    displ = opt.display;
    Mfinal = opt.mfinal;
    problem = opt.problem;

    if problem.type == 1 %(pob<=1 && nc<=2) % standard enviroment SA
        options = saoptimset('Display',displ,'MaxFunEvals',FE_max_SA,'InitialTemperature',0.001);
        lim_max_evals = FE_max_SA;
    elseif problem.type == 2 %(pob<=1 && nc>=3) % standard enviroment SA
        options = saoptimset('Display',displ,'MaxFunEvals',FE_max,'OutputFcn', @myoutputSA,'InitialTemperature',0.001);
        lim_max_evals = FE_max;
    elseif problem.type == 3 %(pob>=2 && nc<=2) % special enviroment SA
        NSA=@(inpt1,inpt2) NeigborhoodSA(inpt1,inpt2,problem);
        options = saoptimset('Display',displ,'MaxFunEvals',FE_max_SA,'AnnealingFcn', NSA,'InitialTemperature',0.001);
        lim_max_evals = FE_max_SA;
    elseif problem.type == 4 %(pob>=2 && nc>=3) % special enviroment SA
        NSA=@(inpt1,inpt2) NeigborhoodSA(inpt1,inpt2,problem);
        options = saoptimset('OutputFcn', @myoutputSA,'Display',displ,'MaxFunEvals',FE_max,'AnnealingFcn', NSA);
        lim_max_evals = FE_max;
    end
    
    %%%%%%%%%%%
    % Execution
    %%%%%%%%%%%

    EvaActual=0;
    M=0;
    results=[]; % Storing the results
    fval2=realmax;
    best_x=population(1,:);

    tic;
    while FE_max>EvaActual

        [x,fval,exitFlag,output_h]=simulannealbnd(f,best_x,LB,UB,options);
        
        if (isfield(output_h, 'funcCount') == 0)
            output_h.funcCount = lim_max_evals;
        end
        
        EvaActual=EvaActual+output_h.funcCount;

        if fval<fval2
            fval2=fval;
            M=M+1;
            if nc == 3
                results = [results; best_solution_consola_sa];
            else
                results=[results; [fval,EvaActual,toc]];
            end
            best_x=x;
        end

        if(M==Mfinal)
            
            [ alfas, fval, exitflag, output] = optExact( f, LB, UB, best_x, options_exact );

            EvaActual=EvaActual+output.funcCount;
            M=0;
            
            if fval < fval2
                best_x=alfas;
                fval2 = fval;
                results=[results;[fval,EvaActual,output.time]];
            end
            
        end % if MFinal
        
    end % While FEMax
    
    output_f.time = toc;
    x_opt = best_x;
    f_opt = fval2;
    output_f.funcCount = EvaActual; % Number of real evaluations of the function
    
    % Print final results
    
    if opt.mfinal == Inf
        msg = 'Simulated Annealing';
    else
        msg = ['Simulated Annealing', ' ', options_exact.alg];
    end
    
    disp(['*********  FINAL RESULTS ', msg, '  *************************']);
    g = sprintf('%f ', x_opt);
    fprintf('x opt: %s\n', g);
    fprintf('f value: %f\n', f_opt);
    fprintf('Number of evaluations: %d\n', output_f.funcCount);
    fprintf('Total time: %f seconds\n', output_f.time);
    disp('**********************************************************************');
  
end

