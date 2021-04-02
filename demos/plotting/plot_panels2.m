function plot_panels2(x,y,svm)
%PLOT_PANELS Plot a 2-by-2 panel of figures for the demos
% Starting from top-left panel, the function plots:
% - Empty slot for plotting anything
% - True labels: scatter plot of x colored by y
% - Decisions regions: the decision regions of svm
% - Predicted labels: scatter plot of x colored by svm.predict(x)

    [padded_xlims,padded_ylims] = get_padded_lims(x);
    % Plot the results
    figure(1);clf;
    mk_sz = 50;

    subplot(2,2,2);
    scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'filled');
    xlim(padded_xlims);ylim(padded_ylims);
    title("True labels");

    subplot(2,2,3);
    y_pred = svm.predict(x);
    scatter(x(1,:),x(2,:),mk_sz,label2rgb(y_pred),'filled');
    xlim(padded_xlims);ylim(padded_ylims);
    title("Predicted labels");

    subplot(2,2,4);
    plot_decision_regions(x,svm);
    hold on
    scatter(x(1,:),x(2,:),mk_sz,label2rgb(y),'filled', 'MarkerEdgeColor', 'w', 'LineWidth',1.5);
    xlim(padded_xlims);ylim(padded_ylims);
    title("Decision regions");
end

