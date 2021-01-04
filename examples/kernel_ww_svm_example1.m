
ds = syn_data_2F_3C();

% [x,y]=sd.trefoil(33);
[x,y] = sd.nested_circle(50,pi/2);

k = 3;
C = 1;
sigma_squared = .25;
ker_fun = get_rbf_KM(sigma_squared);
kmsvm_qp = kernel_msvm_qp(x,y,k,C,ker_fun);
tic
kmsvm_qp.solve_CS();
toc
%%

marker_size = 500;
figure(1);clf;
subplot(2,2,1);

alphas_sum = sum(kmsvm_qp.alphas,1);
alphas_sum = alphas_sum/max(alphas_sum);
scatter(x(1,:),x(2,:),marker_size*alphas_sum ,label2rgb(y),'.');
% colorbar
subplot(2,2,2);
scatter(x(1,:),x(2,:),marker_size,label2rgb(y),'.');


y_pred = kmsvm_qp.predict(x);
subplot(2,2,3);
scatter(x(1,:),x(2,:),marker_size,label2rgb(y_pred),'.');


x_test = get_covering_grid(x,50);
y_test = kmsvm_qp.predict(x_test);

subplot(2,2,4);
s = scatter(x_test(1,:),x_test(2,:),100,label2rgb(y_test),'+','LineWidth',0.75);
hold on 
scatter(x(1,:),x(2,:),marker_size,label2rgb(y_pred),'.');
