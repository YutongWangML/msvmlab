qp_solver = @kernel_cs_svm_qp;
bcd_solver = @linear_cs_svm_bcd;

% Get the dataset

ds = syn_data_2F_3C();
rng(0);
% [x,y] = ds.GMM(100);
[x,y] = ds.nested_circles(50,pi/6);
% [x,y] = ds.trefoil(33);

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
bcd.IAM.track_interval=10;
bcd.solve(1000);


% disp("BCD solution:");
% toc

% Display the results
figure(1);
plot_panels1(x,y,bcd);


figure(2);clf;
% subplot(2,2,1);
semilogy(bcd.IAM.tracked_time("primal_objective"),...
         bcd.IAM.tracked_qty("primal_objective") - qp.dual_objective);
title("Primal suboptimality");
