function plot_panels1(x,y,svm)
%PLOT_PANELS Plot a 2-by-2 panel of figures for the demos
% Starting from top-left panel, the function plots:
% - True labels: scatter plot of x colored by y
% - Decisions regions: the decision regions of svm
% - Predicted labels: scatter plot of x colored by svm.predict(x)
% - Support vectors: scatter plot of x where the radius of the points are
% the "size" of the block dual variables in svm.

    [padded_xlims,padded_ylims] = get_padded_lims(x);

    clf;
    mk_sz = 50; % marker size

    subplot(2,2,1); 
    scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'filled');
    xlim(padded_xlims);ylim(padded_ylims);
    title("True labels");

    subplot(2,2,2); 
    plot_decision_regions(x,svm);
    hold on
    scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'filled', 'MarkerEdgeColor', 'w', 'LineWidth',1.5);
    title("Decision regions");

    subplot(2,2,3); 
    y_pred = svm.predict(x);
    scatter(x(1,:),x(2,:),mk_sz,label2rgb(y_pred),'filled');
    xlim(padded_xlims);ylim(padded_ylims);
    title("Predicted labels");

    subplot(2,2,4); 
    plot_decision_regions(x,svm);
    hold on
    plot_support_vectors(x,y,svm,mk_sz);
    xlim(padded_xlims);ylim(padded_ylims);
    title("Support vectors (radius of sample ≈ \newline L1-norm of the block dual variable)");

end

