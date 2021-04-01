function x = ww_subprob_solver_CVX(v,C, Bi)
%WW_SUBPROB_SOLVER_CVX Summary of this function goes here
%   Detailed explanation goes here
km1 = length(v);
if nargin < 3
    Bi = ones(km1,km1) + eye(km1);
end
cvx_begin quiet
    variable x(km1)
    minimize( (1/2)*x'*Bi*x - v'*x )
    subject to
    x >= 0
    x <= C
cvx_end
end
