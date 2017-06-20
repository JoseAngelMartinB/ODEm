function xnew = NeigborhoodSA (optimValues,PROBLEMDATA,opt)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% global opt
% %choose a random support point 
% opt.m=7;
% opt.co=2;
% opt.bounds=[0     1;
%      0     1;

    N=opt.m*opt.co;  
    Xrand=(opt.bounds(:,1)+(opt.bounds(:,2)-opt.bounds(:,1)).*rand(opt.co,1))';

    xnew = optimValues.x;
    i=randi(opt.m);
    c_ini=((i-1)*opt.co+1);
    c_fin=c_ini+(opt.co-1);

    index=c_ini:1:c_fin;
    xnew(index)=Xrand;
end

% OPTIMVALUES
% ?  optimvalues ? Structure containing information about the current state of the solver. The structure contains the following fields:
% o	x ? Current point
% o	fval ? Objective function value at x
% o	bestx ? Best point found so far
% o	bestfval ? Objective function value at best point
% o	temperature ? Current temperature, a vector the same length as x
% o	iteration ? Current iteration
% o	funccount ? Number of function evaluations
% o	t0 ? Start time for algorithm
% o	k ? Annealing parameter, a vector the same length as x
% PROBLEMDATA
% problemData is a structure containing the following information:
% ?	objective: function handle to the objective function 
% ?	x0: the start point
% ?	nvar: number of decision variables
% ?	lb: lower bound on decision variables
% ?	ub: upper bound on decision variables
% 
