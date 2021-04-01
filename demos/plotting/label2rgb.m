function out = label2rgb(y,CCM)
%LABEL2RGB Converts tri-ary label, i.e., k = 3, to RGB code
%
%   usage example:
%       scatter(x(1,:),x(2,:),[],label2rgb(y));
%
%   y = vector of class labels from 1 to 3
%   CCM = class color matrix where CCM(i,:) is the vector of 

    if nargin < 2
        % Colorblind palette take from Figure 2 of Wong 2011
        % https://www.nature.com/articles/nmeth.1618
        % Black, Orange and Sky blue
        CCM = [0,0,0;230,159,0;86,180,233]/255; 
    end
    
    out = CCM(y,:);
end

