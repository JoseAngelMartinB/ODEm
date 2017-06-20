function y1= alea_normal (mean, std_dev) 

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% Use the polar form of the Box-Muller transformation to obtain a pseudo
% random number from a Gaussian distribution
%
% Developed by: Maurice Clerc (May 2011)
    
    w=2;
    
    while w>=1    
        x1 = 2.0 * alea (0, 1) - 1.0;
        x2 = 2.0 * alea (0, 1) - 1.0;
        w = x1 * x1 + x2 * x2;     
    end
    
    w = sqrt (-2.0 * log (w) / w);
    y1 = x1 * w;
    
    if alea(0,1)<0.5
        y1=-y1; 
    end
    
    y1 = y1 * std_dev + mean;
    
end
    