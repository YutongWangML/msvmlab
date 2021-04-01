rng(0);
ds = syn_data_2F_3C();

[x,y]=ds.trefoil(30);
% [x,y] = ds.nested_circle(50,pi/2);
n = size(x,2);


k = 3;
C = 1;
sigma_squared = .25;
ker_fun = kernel_functions("rbf",sigma_squared);

tic
svm = kernel_ww_svm_dc(x,y,k,C,ker_fun);
svm.solve();
toc

plot_panels(x,y,svm);