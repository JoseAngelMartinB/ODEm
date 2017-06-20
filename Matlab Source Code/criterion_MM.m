function Phi = criterion_MM(X,omega,theta,opt )
global design

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta         vector of parameter 
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
    I_xi=I_xi+omega(i)*opt.Ixi_MM(X(i,:),theta);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information matrix of the two stage design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Sigma=opt.Der_g* (opt.pro*opt.I_xi_0+(1-opt.pro)*I_xi)^(-1)*opt.Der_g';
if design.p==0
    Phi=log(det(Sigma));
elseif design.p>0
    Phi=((trace(Sigma^design.p))/size(opt.Der_g,1))^(1/design.p);
end


end


