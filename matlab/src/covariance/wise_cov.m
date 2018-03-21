function [ est ] = wise_cov( S_hat, rho, eig_tol, bisection_tol )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRO Covariance Matrix Estimation
% Viet Anh NGUYEN, Peyman MOHAJERIN, Daniel KUHN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 
%
% Input:
% S_hat: the sample covariance matrix
% rho: the radius of the Wasserstein ambiguity set 
% eig_tol: tolerance for the positive eigenvalues (optional, default: 1e-14)
% bisection_tol: tolerance for bisection search(optional, default: 1e-5)
%
% Output: and estimator object
% est.value: the covariance matrix estimator
% est.x: the eigenvalues of the estimator
% est.eigbasis: the eigenbasis of the estimator
% est.gamma: the optimal dual variable
% est.min_gamma, est.max_gamma: the range of gamma used for bisection
% est.msg: output message
    

    % Eigenvalue decomposition of the sample covariance matrix
    [W, D] = mexeig_dgesdd(S_hat);
   
    lambda = diag(D);
    p = length(lambda);
    
    good_idx = find(lambda > eig_tol);
    null_idx = find(lambda <= eig_tol);
    
    if rho < 1e-3
        % Singular sample covariance matrix and rho close to 0
        est.value = S;
        est.msg = 'rho too close to 0. The optimal estimator is the sample average.';
        est.eigbasis = W;
        est.eig = lambda;
    else
        lambda_bar = lambda(good_idx);

        % Find the range for gamma search
        min_gamma = 0;
        max_gamma = 1e5;
        % do a little search for the upper bound of gamma
        while wise_cov_func_gamma(max_gamma, lambda_bar, rho) < 0
            max_gamma = 10*max_gamma;
        end
       
        % Calculate lambda from bisection
        gamma = wise_bisect(@wise_cov_func_gamma, lambda_bar, rho, [min_gamma, max_gamma], bisection_tol);

        % Calculate the eigenvalues
        y = zeros(p, 1);     % eigenvalues of the precision matrix estimator
        for i = 1:length(good_idx)
            y(good_idx(i)) = wise_cov_find_y(lambda(good_idx(i)), gamma);
        end

        for i = 1:length(null_idx)
            y(null_idx(i)) = 0;
        end
        
        est.value = W*diag(y)*W';
        est.msg = 'Shrinkage covariance matrix estimator available';
        est.eig = y;
        est.eigbasis = W;
        est.gamma = gamma;
        
    end

end

