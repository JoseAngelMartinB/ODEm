function [global_data, CPU] = Fmin_Experiments( f, xlow, xup, varargin )

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

%%%%%%%%%%%%%%%%%%%%%%%%%
% - Opt:
%   * fun
%   * xlow
%   * xup
%   * N
%   * info_problem
%       . co
%       . bounds
%       . m
%%%%%%%%%%%%%%%%%%%%%%%%%

    opt.fun = f;
    opt.xlow = xlow;
    opt.xup = xup;
    
    if size(xlow, 2) == size(xup, 2)
        opt.N = size(xlow, 2);
    else
        fprintf('Error: The xlow and xup vectors must be the same.\n'); 
    end

    file_names.ficheroExp = './all_experiments.mat';
    file_names.directory_res = './Results/';
    
    if mod(size(varargin, 2), 2) ~= 0
       fprintf('Error: The optional parameters must have a string and a value.\n'); 
       return;
    end
    
    list_params = {};
    
    for idx = 1 : 2 : size(varargin, 2)
        switch varargin{idx}
            case 'Iters'
                exp_conf.iter_max =  varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'ItersExact'
                exp_conf.iter_exact =  varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'Alg'
                exp_conf.alg_types = varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'AlgExact'
                exp_conf.alg_exacts = varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'Pop'
                exp_conf.list_pob =  varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'Nc'
                exp_conf.list_nc =  varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'name-problem'
                name_problem = varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'OptSa'
                opt.info_problem = varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            case 'replicas'
                exp_conf.replicas = varargin{idx + 1};
                list_params{length(list_params) + 1} = varargin{idx};
            otherwise
                fprintf('Error: %s is a unknown parameter.\n', varargin{idx}); 
                return;    
        end
    end
    
    list_all_params = {'Iters', 'ItersExact', 'Alg', 'AlgExact', 'Pop', 'Nc', 'name-problem', 'OptSa', 'replicas'};
    
    for idx = 1 : size(list_all_params, 2)
        if ~ismember(list_all_params{idx}, list_params)
            switch list_all_params{idx}
                case 'Iters'
                    exp_conf.iter_max =  500;
                case 'ItersExact'
                    exp_conf.iter_exact =  100;
                case 'Alg'
                    exp_conf.alg_types = 2;
                case 'AlgExact'
                    exp_conf.alg_exacts = 2;
                case 'Pop'
                    exp_conf.list_pob =  50;
                case 'Nc'
                    exp_conf.list_nc =  5;
                case 'name-problem'
                    name_problem = 'Design-Experiments';
                case 'OptSa'
                    opt.info_problem = 0;
                case 'replicas'
                    exp_conf.replicas = 1;
            end
        end
    end
    
    [global_data, CPU] = Experiments( name_problem, opt, file_names, exp_conf );
    
end

