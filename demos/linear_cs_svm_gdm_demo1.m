
ds = syn_data_2F_3C();

% [x,y] = ds.GMM(100);
[x,y] = ds.nested_circles(50,pi/3);
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
gdm.solve(1000);

figure(1);clf;
plot_panels2(x,y,gdm);
subplot(2,2,1);
semilogy(gdm.IAM.tracked_time("primal_objective"),...
         gdm.IAM.tracked_qty("primal_objective") - qp.dual_objective);
title("Primal suboptimality");
