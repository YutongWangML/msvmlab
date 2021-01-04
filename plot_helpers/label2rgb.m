function out = label2rgb(y,CCM)
%LABEL2RGB Summary of this function goes here
%
%   usage example:
%       scatter(x(1,:),x(2,:),[],label2rgb(y));
%
%   y = vector of class labels from 1 to 3
%   CCM = class color matrix where CCM(i,:) is the vector of 

    if nargin < 2
        CCM = [0,0,0;230,159,0;86,180,233]/255;
    end
    out = CCM(y,:);
end

