function generate_tex_table(file)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Ródenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain

global results problem_name design alg algs_exacts opt solution alg_exacts alg_types exp_conf hybrid;

% Design    
if design.p == 0
    design_str = 'D-optimal design';
    phi_design = '\Phi_0';
    design_eff = 'D-Eff';
elseif design.p == 1
    design_str = 'A-optimal design';
    phi_design = '\Phi_1';
    design_eff = 'A-Eff';
else
    design_str = ['Other design: p = ' num2str(design.p)];
    phi_design = ['\Phi_' num2str(design.p)];
    design_eff = 'E-Eff';
end

% Variable initialization
n_results = size(results,2);
list_alg = exp_conf.alg_types;
list_exacts = exp_conf.alg_exacts;
list_popul = exp_conf.list_pob;
l_nc = exp_conf.list_nc;
Nreplicas = exp_conf.replicas;

N = opt.m*(opt.co+1);
auxX=@(x) reshape(x(1:(N-opt.m)),[opt.m,opt.co]);
auxW=@(x) reshape(x(N-opt.m+1:N),[opt.m,1])/sum(reshape(x(N-opt.m+1:N),[opt.m,1]));
I_xi=zeros(opt.k);
Sigma=opt.Der_g* (opt.pro*opt.I_xi_0+(1-opt.pro)*I_xi)^(-1)*opt.Der_g';

% Get index
i_index = [];
j_index = [];
if hybrid.hybrid == 1 % It is an hybrid experiment 
    for algorithm = alg
        if algorithm < 4 % Heuristic algorithm of the hybrid
            for algorithm_exact = algs_exacts % Exact algorithm of the hybrid 
                i_index = [i_index algorithm];
                j_index = [j_index algorithm_exact];
            end
        end
    end
else
    for algorithm = alg
        i_index = [i_index algorithm];
        if algorithm > 3
            j_index = [j_index 1];
        else
            j_index = [j_index 2];
		end
    end
end

i_max = max(i_index);
j_max = max(j_index);
pop_max = size(list_popul, 2);
nc_max = size(l_nc, 2);


% Count the number of fails and get mean values
table_1 = [];
best_Phi_L = 0;
Phi_array = zeros(size(i_index, 2),pop_max,nc_max,Nreplicas);

for alg_index = 1:size(i_index, 2)
    i = i_index(alg_index);
    j = j_index(alg_index);
    for pop = 1:pop_max
        for nc = 1:nc_max            
            for replica = 1:Nreplicas
                %%%%% Efficiency_YBT
                try
                    aux_X = auxX(solution.CPU{i,j,pop,nc,replica,2});
                    aux_W = auxW(solution.CPU{i,j,pop,nc,replica,2});
                    [Phi, ~, Phi_L] = Efficiency_YBT(aux_X,aux_W,opt);
                    if not(isreal(Phi))
                        Phi = nan;
                    end
                catch
                    Phi_L = nan;
                    Phi = nan;
                end
                
                Phi_array(alg_index,pop,nc,replica) = Phi;                           
                if Phi_L > best_Phi_L
                    best_Phi_L = Phi_L;
                end
            end            
        end
    end
   
end
% calculate row table
for alg_index = 1:size(i_index, 2)
    i = i_index(alg_index);
    j = j_index(alg_index);
    a = [];
    t = [];
    iter = [];
    for pop = 1:pop_max
        for nc = 1:nc_max
            %a = [a solution.CPU{i,j,pop,nc,:,1}];   % f_opt per replica
            t = [t solution.CPU{i,j,pop,nc,:,5}];   % time per replica
            iter = [iter solution.CPU{i,j,pop,nc,:,3}]; % iterations per replica
        end
    end  
    [Phi_m,Eff,CPU,iter_media, success] = Table1_row(Phi_array(alg_index,pop,nc,:),t,iter,best_Phi_L)  
    table_1 = [table_1; Phi_m Eff CPU iter_media success];
end

% Calculate the best solution
best_sol = [1, 1, 1, 1];
best_phi = Inf;
for alg_index = 1:size(i_index, 2)
    for pop = 1:pop_max
        for nc = 1:nc_max
            for replica = 1:Nreplicas
                if (Phi_array(alg_index,pop,nc,replica) ~= 0) & isreal(Phi_array(alg_index,pop,nc,replica)) & ~isnan(Phi_array(alg_index,pop,nc,replica))
                    if Phi_array(alg_index,pop,nc,replica) < best_phi
                       best_phi =  Phi_array(alg_index,pop,nc,replica);
                       best_sol = [alg_index,pop,nc,replica];
                    end
                end
            end
        end
    end
end


% LaTeX document Initialization
CStr = {'\documentclass[12px]{article}',
    '',
    '% ODEm (Optimal Design Experiments with Matlab)',
    '% Automated LaTeX file',
    '% For more info visit: https://github.com/JoseAngelMartinB/ODEm',
    '',
    '% Packets',
    '\usepackage[pdftex,breaklinks,colorlinks,',
    '   colorlinks=true,       % false: boxed links; true: colored links',
    '   linkcolor=red,          % color of internal links (change box color with linkbordercolor)',
    '   citecolor=green,        % color of links to bibliography',
    '   filecolor=blue,      % color of file links',
    '   urlcolor=cyan,           % color of external links',
    '   pdftex]{hyperref}',
    '\usepackage[latin1]{inputenc}',
    '\usepackage{float}',
    '\usepackage{rotating}',
    '\usepackage{multirow}',
    '',
    '% Opening'};

CStr{end+1} = sprintf('\\title{%s}', problem_name);
CStr{end+1} = '\author{\href{https://github.com/JoseAngelMartinB/ODEm}{ODEm (Optimal Design Experiments with Matlab)}}';
CStr{end+1} = '';
CStr{end+1} = '\begin{document}';
CStr{end+1} = '\maketitle';
CStr{end+1} = '';

% Table: Algorithm comparison
CStr{end+1} = '\newpage';
CStr{end+1} = '\section{Algorithm comparison}';
CStr{end+1} = '\begin{table}[H]';
CStr{end+1} = '	  \caption{Algorithm comparison}';
CStr{end+1} = '   {\scriptsize';
CStr{end+1} = '      \centering';
CStr{end+1} = '      \begin{turn}{90}';
CStr{end+1} = '         \begin{tabular}{|cl|rrrrr|}';
CStr{end+1} = '            \hline';
CStr{end+1} = sprintf('            && \\multicolumn{5}{|c|}{\\bf %s}\\\\', design_str);
CStr{end+1} = sprintf('            Problem&Algorithm & $%s$&%s&CPU(s)& \\# Iter.& Success', phi_design, design_eff);
CStr{end+1} = '            \\';
CStr{end+1} = '            \hline';

% Iterate over the algorithms
for i = 1:n_results
    if i == ceil(n_results/2)
       CStr{end+1} = sprintf('            {\\bf {\\large 1}}');
    end
    
    % Store the name of the algorithm
    alg_name = results{i}.sortName;
    
    % Store the results
    CStr{end+1} = sprintf('            & %s   & %.4f &  %.4f & $%.2f$ &$    %d$ &$    %.1f$  \\\\', alg_name, table_1(i,1), table_1(i,2), table_1(i,3), table_1(i,4), table_1(i,5));   
end

CStr{end+1} = '         \hline';
CStr{end+1} = '         \end{tabular}';
CStr{end+1} = '      \end{turn}';
CStr{end+1} = '   }';
CStr{end+1} = '\end{table}';





% Table: Best result for the problem
best_alg = best_sol(1);
best_pop = best_sol(2);
best_nc = best_sol(3);
best_replica = best_sol(4);
i = i_index(best_alg);
j = j_index(best_alg);

aux_X = auxX(solution.CPU{i,j,best_pop,best_nc,best_replica,2});
aux_W = auxW(solution.CPU{i,j,best_pop,best_nc,best_replica,2});

% Order the results and join similar points
data_not_order = [aux_W, aux_X];
[rows, cols] = size(data_not_order);

data = sortrows(data_not_order, (2:cols));
% Remove rows with weigth 0 and join similar points
if design.exact == 0
    condition = data(:,1) == 0;
    data(condition,:) = [];

    % Join similar points
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
end

n_covariates = size(data, 2) - 1;
list_covariates = '';
list_weights = '';
n_results = size(data,1);
for cov_i = 1:n_covariates
    for cov_j = 1:n_results
        list_covariates = [list_covariates sprintf('%.5f',data(cov_j, cov_i + 1))];
        if cov_j ~= n_results
            list_covariates = [list_covariates ' &']; 
        end
    end
    list_covariates = [list_covariates ' \\'];
end

for cov_j = 1:n_results
    list_weights = [list_weights sprintf('%.5f',data(cov_j,1))];
    if cov_j ~= n_results
        list_weights = [list_weights  ' &'];
    end
end

phi_0 = best_phi;
lb_ = best_Phi_L;
eff_ = best_Phi_L/Phi_array(best_alg,best_pop,best_nc,best_replica)*100;

CStr{end+1} = '';
CStr{end+1} = '';
CStr{end+1} = '\section{Best result for the problem}';
CStr{end+1} = '';
CStr{end+1} = '\begin{table}[H]';
CStr{end+1} = '	\caption{Best result for the problem}';
CStr{end+1} = '	{\scriptsize';
CStr{end+1} = '		\centering';
CStr{end+1} = '		\begin{turn}{90}';
CStr{end+1} = '			\begin{tabular}{|lc|}';
CStr{end+1} = '				\hline';
CStr{end+1} = sprintf('				& {\\bf %s}\\\\', design_str);
CStr{end+1} = '				\hline & \\';
CStr{end+1} =  sprintf('				{\\bf %s}& $', problem_name);
CStr{end+1} = '				\begin{array}  {c}';
CStr{end+1} = '				\xi_0=\left [';
CStr{end+1} = sprintf('				\\begin{array}{%s}', repmat('r',1,n_results));
CStr{end+1} = sprintf('				%s \\hline', list_covariates);
CStr{end+1} = sprintf('				%s\\\\', list_weights);
CStr{end+1} = '				\end{array}';
CStr{end+1} = '				\right ]  \\';
CStr{end+1} = sprintf('				\\Phi_0(\\xi_0) = %.10f \\\\', phi_0);
CStr{end+1} = sprintf('				LB_{\\Phi_0} = %.10f \\\\', lb_);
CStr{end+1} = sprintf('				Eff_{\\Phi_0} = %.5f \\\\', eff_);
CStr{end+1} = '				\end{array}$\\';
CStr{end+1} = '				&\\';
CStr{end+1} = '				\hline';
CStr{end+1} = '				\hline';
CStr{end+1} = '		    \end{tabular}';
CStr{end+1} = '		\end{turn}';
CStr{end+1} = '	}';
CStr{end+1} = '\end{table}';
CStr{end+1} = '';

% Close Latex file
CStr{end+1} = '';
CStr{end+1} = '\end{document}';

% Store file
fd = fopen(file,'w');
if fd == -1
    display(sprintf('Cannot create file: %s', file));
else
    fprintf(fd, '%s\n',CStr{:});
    fclose(fd);
end

end

function [Phi_m,Eff,CPU,iter_media, success] = Table1_row(a,t,iter,Phi_L)
    % a -> Vector of Phi calculated by the algorithm
    % t -> Vector of time for each replica of the algorithm
    % iter -> Vector of the iterations for each replica of the algorithm
    % Phi_L -> The lower bound of the algorithm
    
    N = length(a);
    condicion = not(isnan(a)) & not(isinf(a)) & isreal(a) & a>0;
    ind = find(condicion == 1);
    a = a(ind);
    t = t(ind);
    iter = iter(ind);
    ind = find(Phi_L./a > 0.5);
    success = (length(ind)/N)*100;
    Phi_m = mean(a(ind));
    Eff = mean(Phi_L./a(ind))*100;
    CPU = mean(t(ind));
    iter_media = ceil(mean(iter(ind)));
end