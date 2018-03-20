function Ix=Ix_app(eta,theta_0,x)
% ejemplo
% f = @(x,w)1/(1+exp(-w(1)-w(2)*x))
% Ix=Ix_app(f,[0;1],[1])

% x and theta_0 are two column vectors
x=x';
theta_0=theta_0';
g=@(theta) eta(x,theta);
grad=gradest(g,theta_0);
Ix=grad'*grad;

end