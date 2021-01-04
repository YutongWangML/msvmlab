function out = get_rbf_KM(sigma_squared)
% get RBF kernel matrix
    out = @(x1,x2) exp(-dist2(x1',x2')/(2*sigma_squared));
end

