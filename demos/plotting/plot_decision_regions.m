function plot_decision_regions(x,y,svm)
%PLOT_DECISION_REGION Summary of this function goes here
%   Detailed explanation goes here
mk_sz = 500;
x_test = get_covering_grid(x,50);
y_test = svm.predict(x_test);

scatter(x_test(1,:),x_test(2,:),100,label2rgb(y_test),'+','LineWidth',0.75);
hold on 
scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'.');
title("Decision regions");
end