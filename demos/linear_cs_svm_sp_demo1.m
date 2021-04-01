
ds = syn_data_2F_3C();

[x,y] = ds.GMM(33);
% [x,y] = ds.nested_circles(50,pi/3);
% [x,y] = ds.trefoil(33);

k = 3;
C = 1;

% Solve the Kernel CS-SVM via QP using linear kernel to get the exact
% minimum value
ker_fun = kernel_functions("linear");
qp = kernel_cs_svm_qp(x,y,k,C,ker_fun);
tic
primal_exact = qp.solve();
toc

% Solve the same problem, but now using GDmax
svm = linear_cs_svm_sp(x,y,k,C);
[svm, primal_approx] = svm.solve(1000);

% Plot the results
figure(1);clf;
mk_sz = 500;

subplot(2,2,1);
semilogy(primal_approx-primal_exact);
title("Primal suboptimality");

subplot(2,2,2);
scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'.');
title("True labels");

subplot(2,2,3);
y_pred = svm.predict(x);
scatter(x(1,:),x(2,:),mk_sz,label2rgb(y_pred),'.');
title("Predicted labels");

subplot(2,2,4);
plot_decision_regions(x,y,svm);
title("Decision regions");