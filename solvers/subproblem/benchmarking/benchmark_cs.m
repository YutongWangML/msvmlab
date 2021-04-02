km1 = 100;
Bi = ones(km1,km1) + eye(km1);

walrus_times = [];
cvx_times = [];
discrepancies = [];

C = 1;
for i = 1:5
    v = randn(km1,1);

    tic
    a1 = cs_subprob_solver_ANA(v,C);
    % toc;
    walrus_times = [walrus_times, toc];

    tic
    a2 = cs_subprob_solver_CVX(v,C,Bi);
    cvx_times = [cvx_times, toc];
%     toc;
    discrepancies = [discrepancies, sum_square(a1-a2)];
end
disp('Average time for CVX to solve the subproblem QP:')
mean(cvx_times)

disp('Average time for analytic solver:')
mean(walrus_times)

disp('Difference between CVX and analytic:')
max(discrepancies)
