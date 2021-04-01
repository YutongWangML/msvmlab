function plot_panels(x,y,model)
%PLOT_PANELS Plot a 2-by-2 panel of figures for the demos
% Starting from top-left panel, the function plots:
% - True labels: scatter plot of x colored by y
% - Decisions regions: the decision regions of model
% - Predicted labels: scatter plot of x colored by model.predict(x)
% - Support vectors: scatter plot of x where the radius of the points are
% the "size" of the block dual variables in model.

figure(1);clf;
mk_sz = 500; % marker size

subplot(2,2,1); 
scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'.'); 
title("True labels");

subplot(2,2,2); 
x_test = get_covering_grid(x,50);
y_test = model.predict(x_test);
y_pred = model.predict(x);
scatter(x_test(1,:),x_test(2,:),100,label2rgb(y_test),'+','LineWidth',0.75);
hold on 
scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'.');
title("Decision regions");

subplot(2,2,3); 
scatter(x(1,:),x(2,:),mk_sz,label2rgb(y_pred),'.');
title("Predicted labels");

subplot(2,2,4); 
alphas_sum = sum(model.alphas,1);
alphas_sum = alphas_sum/max(alphas_sum);
scatter(x(1,:),x(2,:),mk_sz*alphas_sum + eps,label2rgb(y),'.');
title("Support vectors (radius of sample ≈ \newline L1-norm of the block dual variable)");

end

