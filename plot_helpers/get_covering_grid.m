function x_grid = get_covering_grid(x,n)
%GET_COVERING_GRID Summary of this function goes here
%   Detailed explanation goes here


    xmin = min(x(1,:));
    xmax = max(x(1,:));
    xwidth = xmax-xmin;
    
    ymin = min(x(2,:));
    ymax = max(x(2,:));
    ywidth = ymax-ymin;
    
    [X,Y] = meshgrid(linspace(xmin-0.05*xwidth,xmax+0.05*xwidth,n), ...
        linspace(ymin-0.05*ywidth,ymax+0.05*ywidth,n));
    x_grid = [vec(X)';vec(Y)'];
end