function [Phi,Eff,Phi_L] = Efficiency_YBT(X,omega,opt )
global design

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Ródenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% omega 		weights
% X 			A matrix with the support points. Each row is a point
% opt 			is a structure containing the parameters of the experiment
% opt.Ixi(x)    is the information matrix at a single point x
% opt.k         number of parameters
% opt.Der_g     derivatives of the fuction g(\theta) to be estimated
% opt.pro       weight of the prior design
% opt.I_xi_0    information matrix of the prior design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Impose that the sum of the probabillities is equal to 1
omega=omega/sum(omega);
m=length(omega);
I_xi=zeros(opt.k);

%%%%
%% Information matrix of the design
%%%%%%

for i=1:m
    I_xi=I_xi+omega(i)*opt.Ixi(X(i,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information matrix of the two stage design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_0=(opt.pro*opt.I_xi_0+(1-opt.pro)*I_xi)^(-1);
Sigma=opt.Der_g * I_0 * opt.Der_g';

%%%%%%%%%%%
% Calculation of the matrix A of YBT
%%%%%%%%%%%
p1=(opt.n1/(opt.n0+opt.n1));
A=@(x) p1*opt.Der_g *I_0*(opt.Ixi(x')-I_xi)*I_0*opt.Der_g';

if design.p==0
    Z_LB=@(x) -trace(Sigma^(-1)*A(x));
    
elseif design.p==1
    v=min(size(opt.Der_g));
    Z_LB=@(x) -trace(A(x))/v;
else
    v=min(size(opt.Der_g));
    p=design.p;
    Z_LB=@(x) -((trace(Sigma^p))^((1/p)-1))*trace(Sigma^(p-1)*A(x))/(v^(1/p));
end

%%%%%%%%%%%%%% Solution of model to obtain the lower bounds
aux=opt.bounds;
aux=aux(1:(size(aux,1)-1),:);
LB=aux(:,1);
UB=aux(:,2);
if length(LB)>=4
tolerancia=1e-5;
for i=1:3
    if i==1
        options = optimoptions('fmincon','Algorithm','active-set','Display','none','TolCon',tolerancia,'TolFun',tolerancia,'TolX',tolerancia,'MaxFunEvals',50000,'MaxIter', 10000);
    elseif i==2
        options = optimoptions('fmincon','Algorithm','interior-point','Display','none','TolCon',tolerancia,'TolFun',tolerancia,'TolX',tolerancia,'MaxFunEvals',50000,'MaxIter', 10000);
    elseif i==3
        options = optimoptions('fmincon','Algorithm','sqp','Display','none','TolCon',tolerancia,'TolFun',tolerancia,'TolX',tolerancia,'MaxFunEvals',50000,'MaxIter', 10000);
    end
    pto_ini=0.5*LB+0.5*UB;
    [x_opt,f_opt_aux(i), exitflag,output]=fmincon(Z_LB,pto_ini,[],[],[],[],LB,UB,[],options);
    
end

Z_p=@(x) Z_LB(x');
 
[x_opt,f_opt_aux(4)]=particleswarm(Z_p,length(LB),LB,UB);
else
 f_opt_aux=OPT_GRID(Z_LB,LB,UB);
end

 f_opt=min(f_opt_aux);
% fprintf('GRID = %12.8f ALGORITMO= %12.8f \n',f_opt_1,f_opt)
% f_opt=min([f_opt_aux,f_opt_1])

if design.p==0
  v=min(size(opt.Der_g));
    Phi_0=det(Sigma)^(1/v);
    Phi_0_tilde=log(det(Sigma));
    Eff_0=exp(f_opt/v);
    Phi_0_tilde_L=Phi_0_tilde+f_opt;
    Phi_0_L=Phi_0*Eff_0;
    Phi=Phi_0;
    Eff=Eff_0;
    Phi_L=Phi_0_L;
else
    %Phi_1=trace(Sigma)/size(opt.Der_g,1)
    v=min(size(opt.Der_g));
    Phi_p=((trace(Sigma^design.p))/v)^(1/design.p);
    Eff_p=1+f_opt/Phi_p;
    Phi_p_L=Phi_p+f_opt;
    Phi=Phi_p;
    Eff=Eff_p;
    Phi_L=Phi_p_L;
end

fprintf('%12.8f %12.8f %12.8f\n',Phi_L,Phi,Eff)

%if f_opt > 0 % f_opt must be negative
%    Eff=NaN;
%    Phi_L=Nan;
%else

end