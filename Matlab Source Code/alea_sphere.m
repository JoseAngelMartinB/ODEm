function [x] = alea_sphere(D, radius)

%  ******* Random point in a hypersphere ********
% Put  a random point inside the hypersphere S(0,radius) (center 0, radius 1).
% Uniform distribution % Developed by: Maurice Clerc (May 2011)
    
x = zeros(1,D); %**

% --------- Step 1. Direction

l = 0; 

for j=1:1:D
   % x(j) = randn; %?
    x(j)=alea_normal(0,1); %**
    l = l + x(j)*x(j);
end
    
l=sqrt(l);

% --------- Step 2. Random radius

r=alea(0,1);

x= r*radius*x/l;
    
end