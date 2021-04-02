function [x_grid,xlin,ylin]= get_covering_grid(dataset,n)
%GET_COVERING_GRID get a n-by-n grid of points that covers the dataset
% OUTPUT:
% x_grid is a matrix of size n^2-by-2
% xlin is the vector of the unique values x_grid(:,1);
% ylin is the vector of the unique values x_grid(:,2);
    
    [padded_xlims,padded_ylims] = get_padded_lims(dataset);
    
    xlin = linspace(padded_xlims(1),padded_xlims(2),n);
    ylin = linspace(padded_ylims(1),padded_ylims(2),n);
    
    [X,Y] = meshgrid(xlin,ylin);
    x_grid = [vec(X)';vec(Y)'];
end