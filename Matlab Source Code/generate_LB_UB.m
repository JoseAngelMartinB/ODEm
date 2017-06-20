function [ LB, UB ] = generate_LB_UB( bounds, co, m, type )

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

if type == 1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % ------------------ Options for general problems -----------
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    LB= [];                	% vector of lower bounds on the variables
    UB= [];               	% vector of upper bounds on the variables
    N = co * m;    			% total number of variables

    for i=1:N
        LB = [LB bounds(mod(i-1, co) + 1, 1)];
        UB = [UB bounds(mod(i-1, co) + 1, 2)];
    end

elseif type == 2

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % ------------------ Design Experiments -------------------
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    N=m*(co+1);      % Number total of variables
    % Bounds on the variables
    LB= []; % vector of lower bounds on the variables
    UB= []; % vector of upper bounds on the variables
    for i=1:(co+1)
        LB= [LB ones(1,m)*bounds(i,1)];
        UB= [UB ones(1,m)*bounds(i,2)];
    end

end
    
end

