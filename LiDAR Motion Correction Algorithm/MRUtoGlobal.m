function [wn, ww, wz] = MRUtoGlobal(N, gamma, beta, alpha, ux, uy, uz)
    
    wn = zeros(N, 12);
    ww = zeros(N, 12);
    wz = zeros(N, 12);
    W = zeros(3, 1);
    A = zeros(3, 3);
    
    for i = 1:N
        for k = 1:12
            W(1) = ux(i, k);
            W(2) = uy(i, k);  % Negating to match the transformation direction
            W(3) = uz(i, k);  % Negating to match the transformation direction
           % Define matrix A
            A(1, 1) = cos(alpha(i)) * cos(beta(i));
            A(1, 2) = cos(alpha(i)) * sin(beta(i)) * sin(gamma(i)) - sin(alpha(i)) * cos(gamma(i));
            A(1, 3) = cos(alpha(i)) * sin(beta(i)) * cos(gamma(i)) + sin(alpha(i)) * sin(gamma(i));
            
            A(2, 1) = sin(alpha(i)) * cos(beta(i));
            A(2, 2) = sin(alpha(i)) * sin(beta(i)) * sin(gamma(i)) + cos(alpha(i)) * cos(gamma(i));
            A(2, 3) = sin(alpha(i)) * sin(beta(i)) * cos(gamma(i)) - cos(alpha(i)) * sin(gamma(i));
            
            A(3, 1) = -sin(beta(i));
            A(3, 2) = cos(beta(i)) * sin(gamma(i));
            A(3, 3) = cos(beta(i)) * cos(gamma(i));
            
            % Multiply the matrix A by the vector W to get the wind components in the global frame
            W_global = A * W;
            
            % Assign the results to the output arrays
            wn(i, k) = W_global(1);  % Vnorth
            ww(i, k) = W_global(2);  % Vwest
            wz(i, k) = W_global(3);  % Vzenith
        end
    end
end


