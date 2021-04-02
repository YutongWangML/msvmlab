km1 = 10;
Bi = ones(km1,km1) + eye(km1);

C = 1;

v = randn(km1,1);

tic
a1 = ww_subprob_solver(v,C);
% a1'
toc;

tic
a2 = ww_subprob_solver_CVX(v,C,Bi);
% a2'
toc;
[a1';a2']
