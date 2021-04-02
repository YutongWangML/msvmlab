qp_solver = @kernel_ww_svm_qp;
bcd_solver = @linear_ww_svm_bcd;

% Get the dataset
rng(0);
ds = syn_data_2F_3C();
% [x,y] = ds.GMM(33);
% [x,y] = ds.nested_circles(50,pi/3);
[x,y] = ds.trefoil(33);

k = 3;
C = 1;

% Get the exact solution using QP
ker_fun = kernel_functions("linear");
qp = qp_solver(x,y,k,C,ker_fun);
tic
qp.solve();
disp("CVX solution:");
toc

% Run BCD
bcd = bcd_solver(x,y,k,C);
tic
bcd.solve(100);
disp("BCD solution:");
toc

% Display the results
figure(1);
plot_panels1(x,y,bcd);


figure(2);clf;
semilogy(bcd.primal_objectives - qp.dual_objective);
title("Primal suboptimality");