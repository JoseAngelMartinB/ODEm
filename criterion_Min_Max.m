function Phi_MM_max=criterion_Min_Max(X,omega,opt)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% theta is a vector of parameters that will be formated to a two column
% matrix, one column per category

tolerancia=1e-3;
    f_MM=@(theta) -criterion_MM(X,omega,reshape(theta,[opt.co+1,2]),opt ); 
      for i=1:3  
          if i==1
    options = optimoptions('fmincon','Algorithm','active-set','Display','None','TolCon',tolerancia,'TolFun',tolerancia,'TolX',tolerancia);   
          elseif i==2
    options = optimoptions('fmincon','Algorithm','interior-point','Display','None','TolCon',tolerancia,'TolFun',tolerancia,'TolX',tolerancia);     
          elseif i==3
    options = optimoptions('fmincon','Algorithm','sqp','Display','None','TolCon',tolerancia,'TolFun',tolerancia,'TolX',tolerancia);
          end
          if i==1
      PUNTO_INICIAL=zeros(1,opt.k);
          else
              PUNTO_INICIAL=x_opt;
          end
        
    LB=opt.bounds_MM(:,1);
    UB=opt.bounds_MM(:,2);
    %tic
    [x_opt,Phi_MM_aux, exitflag,output]=fmincon(f_MM, PUNTO_INICIAL,[],[],[],[],LB,UB,[],options);
    Phi_MM(i)=-Phi_MM_aux;
      end
      Phi_MM
Phi_MM_max=max(Phi_MM);
end

 %toc

    