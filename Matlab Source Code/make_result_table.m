function make_result_table()

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

global alg hybrid_combinations hybrid algs_exacts results;

%%% 0. Initialize data structures %%%
results = {};

%%% Iterate over all the methods %%%
if hybrid.hybrid == 1 % It is an hybrid experiment
    hybrid_combinations = [];
    counter = 1;
    for algorithm = alg
        if algorithm < 4 % Heuristic algorithm of the hybrid
            for algorithm_exact = algs_exacts % Exact algorithm of the hybrid 
                hybrid_combinations = [hybrid_combinations; algorithm algorithm_exact];
                generate_results(algorithm, algorithm_exact, counter);
                counter = counter + 1;
            end
        end
    end
else
    for algorithm = alg
        generate_results(algorithm, 0, 1);
    end
end

end 


function generate_results(algorithm, algorithm_exact,counter)
global solution opt design hybrid_combinations hybrid alg_names alg_types results;

if hybrid.hybrid == 1 % It is an hybrid experiment
    long_alg_name = strcat(alg_types{algorithm,2}, {' + '}, alg_types{algorithm_exact + 3,2},' (',alg_names{algorithm,1},'+',alg_names{algorithm_exact + 3,1},')' );
    short_alg_name = strcat(alg_names{algorithm,1}, '+', alg_names{algorithm_exact + 3,1});
    algorithm = counter;
else
    long_alg_name = strcat(alg_types{algorithm,2},' (',alg_names{algorithm,1},')');
    short_alg_name = alg_names{algorithm,1};
end


%%% 1. Generate result table %%%

    N = opt.m*(opt.co+1);
    auxX=@(x) reshape(x(1:(N-opt.m)),[opt.m,opt.co]);
    auxW=@(x) reshape(x(N-opt.m+1:N),[opt.m,1])/sum(reshape(x(N-opt.m+1:N),[opt.m,1]));

    if hybrid.hybrid == 1 % It is an hybrid experiment

        aux_x = auxX(solution.CPU{hybrid_combinations(algorithm, 1),hybrid_combinations(algorithm, 2),1,1,1,2});
        aux_w = auxW(solution.CPU{hybrid_combinations(algorithm, 1),hybrid_combinations(algorithm, 2),1,1,1,2});
    else
        if algorithm > 3
            aux_x = auxX(solution.CPU{algorithm,1,1,1,1,2});
            aux_w = auxW(solution.CPU{algorithm,1,1,1,1,2});
        else
            aux_x = auxX(solution.CPU{algorithm,2,1,1,1,2});
            aux_w = auxW(solution.CPU{algorithm,2,1,1,1,2});
        end
    end

    data_not_order = [aux_w, aux_x];
    [rows, cols] = size(data_not_order);

    data = sortrows(data_not_order, (2:cols));
    % Remove rows with weigth 0 and join similar points
    if design.exact == 0
        condition = data(:,1) == 0;
        data(condition,:) = [];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Join similar points
        epsilon = 1e-3; % Minimun distance to considerate two points different
        D = squareform(pdist(data(:,2:size(data,2)),'euclidean'));

        rows = size(data,1);
        i = 1;
        j = 2;
        while i < rows
            while j <= rows
                if D(i,j) < epsilon
                    e = mean([data(i,:);data(j,:)]);
                    e(1) = 2*e(1);
                    % Remove this row
                    data(j,:) = [];
                    D(:,j) = [];
                    rows = rows - 1;
                    % Change the row
                    data(i,:) = e;
                else
                    j = j + 1;
                end
            end 
            i = i + 1;
            j = i + 1;
            D = squareform(pdist(data(:,2:size(data,2)),'euclidean'));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    
%%% 2. Calculate Efficiency %%%
    try
        N = opt.m*(opt.co+1);
        auxX=@(x) reshape(x(1:(N-opt.m)),[opt.m,opt.co]);
        auxW=@(x) reshape(x(N-opt.m+1:N),[opt.m,1])/sum(reshape(x(N-opt.m+1:N),[opt.m,1]));
        if design.exact == 0
            if hybrid.hybrid == 1 % It is an hybrid experiment
                [Phi, efficiency, Phi_L] = Efficiency_YBT(auxX(solution.CPU{hybrid_combinations(algorithm, 1),hybrid_combinations(algorithm, 2),1,1,1,2}),auxW(solution.CPU{hybrid_combinations(algorithm, 1),hybrid_combinations(algorithm, 2),1,1,1,2}),opt);
            else
                if algorithm > 3
                    [Phi, efficiency, Phi_L] = Efficiency_YBT(auxX(solution.CPU{algorithm,1,1,1,1,2}),auxW(solution.CPU{algorithm,1,1,1,1,2}),opt);
                else
                    [Phi, efficiency, Phi_L] = Efficiency_YBT(auxX(solution.CPU{algorithm,2,1,1,1,2}),auxW(solution.CPU{algorithm,2,1,1,1,2}),opt);
                end
            end
        else
            if hybrid.hybrid == 1 % It is an hybrid experiment
                [Phi, efficiency, Phi_L] = Efficiency_YBT(auxX(solution.CPU{hybrid_combinations(algorithm, 1),hybrid_combinations(algorithm, 2),1,1,1,2}),(1/opt.m)*ones(1,opt.m),opt);
            else
                if algorithm > 3
                    [Phi, efficiency, Phi_L] = Efficiency_YBT(auxX(solution.CPU{algorithm,1,1,1,1,2}),(1/opt.m)*ones(1,opt.m),opt);
                else
                    [Phi, efficiency, Phi_L] = Efficiency_YBT(auxX(solution.CPU{algorithm,2,1,1,1,2}),(1/opt.m)*ones(1,opt.m),opt);
                end
            end
        end
    catch
        Phi = -1;
        efficiency = -2;
        Phi_L = 0;    
    end
	
    
%%% 3. Calculate Z %%%
    if hybrid.hybrid == 1 % It is an hybrid experiment
        f_opt = solution.CPU{hybrid_combinations(algorithm,1),hybrid_combinations(algorithm,2),1,1,1,1};
    else
        f_opt = solution.CPU{algorithm,1,1,1,1,1};
    end
	
	
%%% 4. Calculate time %%%
    if hybrid.hybrid == 1 % It is an hybrid experiment    
		time = solution.CPU{hybrid_combinations(algorithm,1),hybrid_combinations(algorithm,2),1,1,1,5};
	else
		if algorithm > 3
			time = solution.CPU{algorithm,1,1,1,1,5};
		else
			time = solution.CPU{algorithm,2,1,1,1,5};
		end
	end
    

%%% 5. Store the data %%%
    f1 = 'hybrid';      v1 = hybrid.hybrid;
    f2 = 'sortName';    v2 = short_alg_name;
    f3 = 'longName';    v3 = long_alg_name;
    f4 = 'data';        v4 = data;
    f5 = 'Phi';         v5 = Phi;
    f6 = 'efficiency';  v6 = efficiency;
    f7 = 'Phi_L';       v7 = Phi_L;
    f8 = 'f_opt';       v8 = f_opt;
	f9 = 'time';       	v9 = time;

    data_structure = struct(f1, v1, f2, v2, f3, v3, f4, v4, f5, v5, f6, v6, f7, v7, f8, v8, f9, v9); 
    results{end + 1} = data_structure;

end