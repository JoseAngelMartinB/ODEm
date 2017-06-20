function [ x_opt, f_opt, results, output_f ] = solver( current_alg, fun, LB, UB, population_ini, opt_h, options_exact )

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   current_alg - structure of the current algorithm
%       type - identifier for if conditions
%       name - complete name of the algorithm
%   fun - function to optimize
%   LB - Lower bound to define space´s restrictions
%   UB - Upper bound to define space´s restrictions
%   population_ini - matrix of initial population: each row is a set of points   
%   opt_h - Options to configure different exact algorithms (See each info algorithm)
%   options_exact - options related to exact algorithms
%
%--- OUTPUT ------
%   x_opt - is the solution vector of points
%   f_opt - is the value of the optimized quality function
%   results - funcion´s value of each iteration
%   output_f - information about algorithms evaluations
%       funcCount - number of evaluations including exact and heuristic
%       algorithms
%       time - time of executing the algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global alg_exacts;

algorithm = current_alg.type;
c_name_alg = current_alg.name;

%% Print information about the algorithms execution 

disp('----------------------------------------------------------------------');
disp(['------------------------- ', c_name_alg,' ------------------------']);

if(~ismember(algorithm, alg_exacts) && opt_h.mfinal ~= Inf)
    disp('----------------------------  +  -------------------------------------');
    disp(['------------------------ ', options_exact.alg,' ------------------------']); 
end

disp('----------------------------------------------------------------------');
fprintf('Poblacion: %d\n', opt_h.pob_size);
fprintf('Numero de exitos: %d\n', opt_h.mfinal);
fprintf('Replica: %d\n', opt_h.replica);


%%     G A   

if  (strcmp(algorithm,'GA'))   
   
    [ x_opt, f_opt, results, output_f ] = genetic_algorithm( fun, LB, UB, population_ini, opt_h, options_exact );

    
%%    S P S O    

elseif  (strcmp(algorithm,'SPSO'))
    
    [ x_opt, f_opt, results, output_f ] = spso( fun, LB, UB, population_ini, opt_h, options_exact );


%%    S A  
elseif  (strcmp(algorithm,'SA'))
    
    [ x_opt, f_opt, results, output_f] = simulated_annealing( fun, LB, UB, population_ini, opt_h, options_exact );
    
    
%%   E X A C T   M E T H O D S 

elseif (ismember(algorithm, alg_exacts))
  
    options_exact.alg = algorithm;
    
    [ x_opt, f_opt, results, output_f ] = optExact( fun, LB, UB, population_ini, options_exact );
        
end % type of algorithm

end

