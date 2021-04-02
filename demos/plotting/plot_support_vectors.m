function plot_support_vectors(x,y,svm,mk_sz)
%PLOT_SUPPORT_VECTORS Summary of this function goes here
%   Detailed explanation goes here
    alphas_sum = sum(svm.alphas,1);
    alphas_sum = alphas_sum/max(alphas_sum);
    alphas_sum = abs(alphas_sum);
    scatter(x(1,:),x(2,:),mk_sz*alphas_sum + eps,label2rgb(y),'filled', 'MarkerEdgeColor', 'w', 'LineWidth',1.5);
end

