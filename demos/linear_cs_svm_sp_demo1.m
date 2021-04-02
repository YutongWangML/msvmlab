
ds = syn_data_2F_3C();

% [x,y] = ds.GMM(33);
% [x,y] = ds.nested_circles(50,pi/3);
[x,y] = ds.trefoil(33);

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

% Solve the same problem, but now using GDmax
svm = linear_cs_svm_sp(x,y,k,C);
tic
svm.solve(1000);
toc

plot_panels2(x,y,svm);
subplot(2,2,1);
semilogy(svm.primal_objectives - qp.dual_objective);
title("Primal suboptimality");
