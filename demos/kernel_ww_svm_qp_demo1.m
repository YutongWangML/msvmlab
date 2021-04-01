ds = syn_data_2F_3C();

[x,y] = ds.trefoil(33);
% [x,y] = ds.nested_circles(50,pi/3);

k = 3;
C = 1;

sigma_squared = .25;
ker_fun = kernel_functions("rbf",sigma_squared);
svm = kernel_ww_svm_qp(x,y,k,C,ker_fun);

tic
svm.solve()
toc

plot_panels(x,y,svm);