function plot_decision_regions(x,svm,grid_width)
%PLOT_DECISION_REGION Color the decision regions of svm
    if nargin < 3
        grid_width = 100;
    end
    [x_test,xlin,ylin] = get_covering_grid(x,grid_width);
    y_test = svm.predict(x_test);

    C = label2rgb(y_test);
    Cmat = zeros(grid_width,grid_width,3);
    for i = 1:3
        Cmat(:,:,i) = reshape(C(:,i),grid_width,grid_width);
    end
    imagesc(xlin,ylin,Cmat, 'AlphaData', .5);
    set(gca,'YDir','normal'); % See the link below
    % https://www.mathworks.com/matlabcentral/answers/94170-how-can-i-reverse-the-y-axis-when-i-use-the-image-or-imagesc-function-to-display-an-image-in-matlab
end