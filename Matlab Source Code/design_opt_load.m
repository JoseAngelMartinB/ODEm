function opt=design_opt_load(file,line)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function return a structure containing the following elements:
% opt.Ixi(x) is the information matrix at a single point x
% opt.Der_g derivatives of the fuction g(\theta) to be estimated
% opt.pro weight of the prior design
% opt.I_xi_0 information matrix of the prior design
% opt.k      number of parameters
% opt.n1     number of new observations
% opt.n0     number of initial observations
% opt.m      number of support-points 
% opt.co     number of covariates
% opt.bounds matrix of bounds which defines the design space of covariates
%            and bounds 0/1 of the proabilities. Each row is associated
%            with a covariate and the last row is the probability [0,1]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    n_problem = 0;
    error = 0;
    problem_finded = false;
    problem_line = -1;
    % Open file and search for problems
    fd = fopen(file,'r');
    if fd == -1
        error = 1;
    else
        Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
        CStr = Data{1};
        fclose(fd); 
        
        if strcmp(CStr(line + 2), 'linear_model')
            f_cell = CStr(line + 3);
            f = str2func(f_cell{:});
            opt.f = f;
            opt.Ixi = @(x) f(x)*f(x)';            
        elseif strcmp(CStr(line + 2), 'non-linear_model')
            useIxi_cell = CStr(line + 3);
            useIxi = str2num(useIxi_cell{:});
            line = line + 1;
            line_of_f = line + 3;
            theta_0_cell = CStr(line + 4);
            theta_0 = str2num(theta_0_cell{:});
            theta_str = ['theta = [' theta_0_cell{:} ']'];
            eval(theta_str);
            
            % Auxiliar functions
            n_auxiliarf = 0;
            line = line + 1;
            n_auxiliarf_cell = CStr(line + 4);
            n_auxiliarf = str2num(n_auxiliarf_cell{:});
            for i = 1:n_auxiliarf
                line = line + 1;
                auxiliarf_cell = CStr(line + 4);
                eval(auxiliarf_cell{:});                   
            end           
                        
            f_cell = CStr(line_of_f);
            f = str2func(f_cell{:});
            
            if n_auxiliarf >= 1
                f_str = ['opt.f = ' f_cell{:}];
                eval(f_str);
                if useIxi == 0 % The gradient vector is inserted
                    opt.Ixi = @(x) opt.f(x,theta_0)*opt.f(x,theta_0)';
                else % If the information matrix is inserted directly
                    f_str = ['opt.Ixi = ' f_cell{:}];
                    eval(f_str);
                end
            else
                if useIxi == 0 % The gradient vector is inserted
                    opt.f=@(x) f(x,theta_0);
                    opt.Ixi = @(x) f(x,theta_0)*f(x,theta_0)';
                else % If the information matrix is inserted directly
                    f_str = ['opt.Ixi = ' f_cell{:}];
                    eval(f_str);
                end
            end
            
            
        end
        
        k_cell = CStr(line + 5);
        opt.k = str2num(k_cell{:});
        
        m_cell = CStr(line + 6);
        opt.m = str2num(m_cell{:});
        
        co_cell = CStr(line + 7);
        opt.co = str2num(co_cell{:});

        Der_g_cell = CStr(line + 8);
        opt.Der_g = str2num(Der_g_cell{:});
        
        bounds_cell = CStr(line + 9);
        opt.bounds = str2num(bounds_cell{:});
        
        
        if strcmp(CStr(line + 10), 'one-stage')
            % No initial observations
            opt.I_xi_0=zeros(opt.k); 
            opt.n0=0;  	% Number of initial observations: non prior experiment
            opt.n1=1; 	% Number of new observations
            opt.pro= opt.n0/(opt.n0+opt.n1);
            
        elseif strcmp(CStr(line + 10), 'multistage')
            opt.I_xi_0 = zeros(opt.k);
            
            n0_cell = CStr(line + 11);
            opt.n0 = str2num(n0_cell{:});
            
            n1_cell = CStr(line + 12);
            opt.n1 = str2num(n1_cell{:});
            
            omega_0_cell = CStr(line + 13);
            omega_0 = str2num(omega_0_cell{:});
            
            X_0_cell = CStr(line + 15);
            opt.X_0 = str2num(X_0_cell{:});
            
            opt.pro= opt.n0/(opt.n0+opt.n1);
            
            for i=1:size(opt.X_0,1)
                opt.I_xi_0=opt.I_xi_0+omega_0(i)*opt.Ixi(opt.X_0(i,:));
            end  
            
        end
    end

end
