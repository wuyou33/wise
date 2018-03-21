function [ mid ] = dro_bisect( func_name, lambda, rho, range, tol )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRO Precision Matrix Estimation
% Viet Anh NGUYEN, Peyman MOHAJERIN, Daniel KUHN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Bisection function (used to find gamma)
%
% Input:
% func_name: the name of function to bisect
% lambda: the vector containing the eigenvalues of the sample covariance
% rho: size of the Wasserstein ambiguity set
% range: a vector containing the initial lower and upper bound for bisection
% tol: tolerance 

    done = 0;
    lower = range(1);
    upper = range(2);
    mid = (lower+upper)/2;
    while done < 1
        
        if func_name(mid, lambda, rho) > 0
            upper = mid;
        else
            lower = mid;
        end
        mid = (lower+upper)/2;
        
        
        if upper - lower < tol
            done = 2;
        end
    end


end
