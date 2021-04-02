ds = syn_data_2F_3C();

[x,y] = ds.GMM(100);
% [x,y] = ds.nested_circles(50,pi/3);
% [x,y] = ds.trefoil(33);

k = 3;
C = 1;

% Solve the Kernel CS-SVM via QP using linear kernel to get the exact
% minimum value
ker_fun = kernel_functions("linear");
qp = kernel_cs_svm_qp(x,y,k,C,ker_fun);
tic
qp.solve();
toc
qp.dual_objective



% Run GDmax
gdm = linear_cs_svm_gdm(x,y,k,C);
gdm.IAM.track_interval = 10;
gdm.IAM.algo_params("step_size") = 1;
gdm.IAM.algo_params("step_size_decay") = 0.99;
gdm.solve(2000);


% Run BCD
bcd = bcd_solver(x,y,k,C);
bcd.IAM.track_interval=10;
bcd.solve(1000);


%%
figure(3);clf;
% subplot(2,2,1);
semilogy(gdm.IAM.tracked_time("primal_objective"),...
         gdm.IAM.tracked_qty("primal_objective") - qp.dual_objective);
hold on 

semilogy(bcd.IAM.tracked_time("primal_objective"),...
         bcd.IAM.tracked_qty("primal_objective") - qp.dual_objective);
legend('GDmax', 'BCD');
title("Primal suboptimality");
