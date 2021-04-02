function [padded_xlims, padded_ylims] = get_padded_lims(dataset)
%GET_COVERING_GRID get x and y plotting limits of the dataset
% OUTPUT:
% padded_xlims is a length 2 vector such that 
% padded_xlims(1) <= dataset(:,1) <= padded_xlims(2)
%
% padded_ylims is a length 2 vector such that 
% padded_ylims(1) <= dataset(:,1) <= padded_ylims(2)


    xmin = min(dataset(1,:));
    xmax = max(dataset(1,:));
    xwidth = xmax-xmin;
    
    ymin = min(dataset(2,:));
    ymax = max(dataset(2,:));
    ywidth = ymax-ymin;
    padded_xlims = [xmin-0.05*xwidth,xmax+0.05*xwidth];
    padded_ylims = [ymin-0.05*ywidth,ymax+0.05*ywidth];
end


