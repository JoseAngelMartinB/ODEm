function [global_data, CPU] = Experiments( name_problem, opt, file_names, exp_conf )

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% --------- PARAMETERS OF THE NUMERICAL EXPERIMENTS ------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global alg_exacts alg_types; %list_pob list_nc;

ficheroExp = file_names.ficheroExp;
directory_res = file_names.directory_res;

list_alg = exp_conf.alg_types;
list_exacts = exp_conf.alg_exacts;
list_popul = exp_conf.list_pob;
l_nc = exp_conf.list_nc;

alg_exacts = {'active-set'; % E - 1
    'interior-point';       % E - 2
    'sqp';                  % E - 3
    'nealder-mead';         % E - 4
    'pattern-search'};      % E - 5

alg_types = {'SPSO','SPSO 2011';                % H - 1
    'GA','Genetic Algorithm';                   % H - 2
    'SA','Simulated Annealing';                 % H - 3
    'active-set','Active Set';                  % E - 4
    'interior-point','Interior Point';          % E - 5
    'sqp','Sequential Quadratic Programming';   % E - 6
    'nealder-mead','Nealder Mead';              % E - 7
    'pattern-search','Pattern Search'};         % E - 8

Nreplicas = exp_conf.replicas;             % Number of replicas
nc_min = 1;
nc_max = length(l_nc);   
PobMin = 1;
PobMax = length(list_popul);
AlgMin = 1;
AlgMax = size(alg_types, 1);
AlgMinExac = 1;
AlgMaxExac = size(alg_exacts,1);
%%%%%%%%%%%%%%%
FE_max = exp_conf.iter_max;
FE_max_SA = 50; % Number of iterations of the SA to be reinitialized - 50
FE_max_ex = exp_conf.iter_exact; % Maximum number of evaluations of exacts algorithms in heuristics alg.-100
%%%%%%%%%%%%%%%
ficheroRes = [directory_res 'Res_' name_problem '.mat'];
displ='iter';
%%%%%%%%%%%%%%%
PopulationSize_Max = 125;
fich_popul = [directory_res 'Population_' name_problem '.mat'];
Generation_population = 'yes';    % 'yes' or 'no'
%%%%%%%%%%%%%%%
ValStallGenLimit = 100;    % Number of populations without change
%%% Options for exact algorithms without heuristic algs.
options_exact.display = displ;
options_exact.tolcon = 1e-12;
%%%%%%%%%%%%%%%
N = opt.N;
LB = opt.xlow;
UB = opt.xup;
fun = opt.fun;
extra_sa = opt.info_problem;
%%%%%%%%%%%%%%%
global_data.best_value = Inf;
global_data.best_solution = zeros(1, N);
CPU = {};
%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ---------------- LOADING EXPERIMENTS ----------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l_experiments = {};

if exist(ficheroExp, 'file') == 2
    load(ficheroExp, 'l_experiments'); % load all experiments
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ---------------- DEFINICION INITIAL POPULATION ------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

population=zeros(PopulationSize_Max,N);

if (strcmp(Generation_population,'yes'))
   for i_aux=1:PopulationSize_Max
       population(i_aux,:)=rand(1,N).*(UB-LB)+LB;
   end
   population_ini=population;
   %save(fich_popul,'population');
elseif (strcmp(Generation_population,'no') && exist(fich_popul, 'file') == 2)
   %load(fich_popul,'population');
   %population_ini=population;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% -------------- EXPERIMENTS INITIALIZATION  -----------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = AlgMin : AlgMax     % number of algorithms % Use algorithm-> SPSO, GA, SA todos (all)
    
    if (j<=0) || ~ismember(j, list_alg)
        continue;
    elseif(j>size(alg_types,1))
        break;
    end
    
    current_alg.type = alg_types{j,1};
    current_alg.name = alg_types{j,2};
    
    if (ismember(current_alg.type, alg_exacts)) % to ignore parameters related to heuristic alg.
        AlgMinExac_aux = 1;
        AlgMaxExac_aux = 1;
        PobMin_aux = 1;
        PobMax_aux = 1;
        nc_min_aux = 1;
        nc_max_aux = 1;
        options_exact.fe_max = FE_max;
        options_exact.into_heuristic = 0;
    else
        AlgMinExac_aux = AlgMinExac;
        AlgMaxExac_aux = AlgMaxExac;
        PobMin_aux = PobMin;
        PobMax_aux = PobMax;
        nc_min_aux = nc_min;
        nc_max_aux = nc_max;
        options_exact.fe_max = FE_max_ex;
        options_exact.into_heuristic = 1;
    end
    
    for j_e = AlgMinExac_aux : AlgMaxExac_aux
        
        if ((j_e<=0) || ~ismember(j_e, list_exacts)) && ~(AlgMinExac_aux == 1 && AlgMaxExac_aux == 1)
            continue;
        elseif(j_e>size(alg_exacts,1))
            break;
        end
        
        for pob = PobMin_aux : PobMax_aux

            PopulationSize = list_popul(pob);

            for nc = nc_min_aux : nc_max_aux
                
                Mfinal = l_nc(nc);

                for replica = 1 : Nreplicas

                    % configure the options for heuristic algorithm
                    % SPSO
                    opt_h.err=1e-10;
                    opt_h.opt_f=1e-10;
                    opt_h.norm=0;
                    % GA
                    opt_h.valgenlimit = ValStallGenLimit;
                    opt_h.tolfun = 1.e-20;
                    % SA
                    opt_h.problem = extra_sa;
                    opt_h.FE_max_SA = FE_max_SA;
                    % ALL
                    opt_h.pob = pob;
                    opt_h.replica = replica;
                    opt_h.FE_max = FE_max;
                    opt_h.nc = nc;
                    opt_h.pob_size = PopulationSize;
                    opt_h.n = N;
                    opt_h.display = displ;
                    opt_h.mfinal = Mfinal;
                    options_exact.alg = alg_exacts{j_e};

                    [ x_opt, f_opt, results, output_f ] = solver( current_alg, fun, LB, UB, population_ini, opt_h, options_exact );

                    % save solver results in a cell 
                    CPU{j,j_e,pob,nc,replica,1} = f_opt;
                    CPU{j,j_e,pob,nc,replica,2} = x_opt;
                    CPU{j,j_e,pob,nc,replica,3} = output_f.funcCount;
                    CPU{j,j_e,pob,nc,replica,4} = results;
                    CPU{j,j_e,pob,nc,replica,5} = output_f.time;
                    
                    % save the best value of the objetive function
                    if (global_data.best_value > f_opt)
                        global_data.best_value = f_opt;
                        global_data.best_solution = x_opt;
                    end

                    % save partial results in a file and its state
                    % save(ficheroRes, 'CPU', 'global_data', 'j', 'j_e', 'pob', 'nc', 'replica'); 

                end   
                
                % Save into a file all posible experiments
                if (options_exact.into_heuristic)
                    str_experiments = sprintf('%s_%s_%s_%s', alg_types{j,1}, alg_exacts{j_e}, num2str(list_popul(pob)), num2str(l_nc(nc)));
                else
                    str_experiments = sprintf('%s', alg_types{j,1});
                end
                
                if isempty(l_experiments)
                    aux_strs = {};
                else
                    aux_strs = {l_experiments{:,1}}; 
                end

                if ismember(str_experiments, aux_strs) == 0

                    index_exp = size(l_experiments, 1) + 1;
                    l_experiments{index_exp, 1} = str_experiments;

                    str.type = j;
                    str.exact = j_e;
                    str.pob = pob;
                    str.nc = nc;
                    l_experiments{index_exp, 2} = str;

                    save(ficheroExp, 'l_experiments');
                end
                
            end % nc
        end % pob
    end % exact
end % heuristic

end