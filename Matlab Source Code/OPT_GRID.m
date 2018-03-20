function f_opt = OPT_GRID(f,LB,UB)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Ródenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain

n_factor = length(LB);
if n_factor == 1
    iter = 1000;
elseif n_factor == 2
    iter = 50000;
elseif n_factor == 3
    iter = 50000;
end

diameter = sum(UB)-sum(LB);
h = diameter/(n_factor*(iter)^(1/n_factor));

if n_factor == 1 % one dimension
    X = LB:h:UB;
    m = length(X);
    for i = 1:m
        z(i) = f(X(i));
    end
    f_opt = min(z);
    
elseif n_factor == 2 % two dimension
    [X,Y] = meshgrid(LB(1):h:UB(1),LB(2):h:UB(2));
    [m,n] = size(X);
    for i = 1:m
        for j = 1:n
            z(i,j) = f([X(i,j),Y(i,j)]);
        end
    end
    f_opt = min(min(z));
    
elseif n_factor == 3 % three dimension
    [X,Y, Z] = meshgrid(LB(1):h:UB(1),LB(2):h:UB(2),LB(3):h:UB(3));
    [m,n,o] = size(X);
    for i = 1:m
        for j = 1:n
            for k = 1:o
                try
                    z(i,j,k) = f([X(i,j,k),Y(i,j,k),Z(i,j,k)]');
                catch
                    z(i,j,k) =inf;
                end
            end
        end
    end
    f_opt = min(min(min(z)));
end

end