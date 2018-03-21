function [ value ] = dro_function_prec_gamma( gamma, lambda, rho )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRO Precision Matrix Estimation
% Viet Anh NGUYEN, Peyman MOHAJERIN, Daniel KUHN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function used for bisection (used to find gamma in the precision matrix problem)
%
% Input: 
% gamma: current value of the dual variable
% lambda: vector containing the eigenvalues of the sample covariance
% rho: size of the Wasserstein ambiguity set

    temp = 0;
    
    for i = 1:length(lambda)
        temp = temp + gamma*lambda(i)*sqrt(1 + 4/gamma/lambda(i));
    end
    value = (rho^2 - sum(lambda)/2)*gamma - length(lambda) + temp/2;
end

