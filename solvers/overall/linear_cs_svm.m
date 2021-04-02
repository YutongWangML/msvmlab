classdef linear_cs_svm < linear_svm
    %LINEAR_MSVM Crammer-Singer linear SVM base class
    % Implements the primal_objective function
    
    properties
    end
    
    methods
        function obj = linear_cs_svm(x, y, k, C)
            obj@linear_svm(x, y, k, C)
        end
        
        function primal_val = get_primal_objective(obj)
            primal_val = 0;
            for i = 1:obj.n
                z = 1-obj.IC.rhos{obj.y(i)}*obj.w'*obj.x(:,i);
                primal_val = primal_val + max(max(z),0);
            end
            primal_val = obj.C*primal_val;
            
%             primal_val = primal_val + (1/2)*trace(obj.w'*obj.w*obj.IC.B);
            primal_val = primal_val + (1/2)*obj.normIC();
        end
    end
end

