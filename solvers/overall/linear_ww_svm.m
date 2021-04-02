classdef linear_ww_svm < linear_svm
    %LINEAR_MSVM Weston-Watkins linear SVM base class
    % Implements the primal_objective function
    
    properties
    end
    
    methods
        function obj = linear_ww_svm(x, y, k, C)
            obj@linear_svm(x, y, k, C,loss_functions('ww'))
        end
    end
end

