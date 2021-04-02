classdef kernel_svm < handle
    %KERNEL_MSVM
    %   abstract base class for the kernel MSVM
    
    properties
        k   % number of classes
        n   % number of instances
        C   % regularizer
        
        x   % data matrix
        y   % label
        
        IC  % involution code
        
        ker_fun     % kernel function
        rho_sparse_mat  %
        
        alphas  % dual variables
    end
    
    
    methods
        function obj = kernel_svm(x, y, k, C, ker_fun)
            %KERNEL_MSVM Construct an instance of this class
            %   Detailed explanation goes here
            obj.k = k;
            obj.C = C;
            obj.x = x;
            obj.y = y;
            obj.n = size(x,2);
            obj.ker_fun = ker_fun;
            obj.IC = involution_code(k);
            obj.rho_sparse_mat = sparse(blkdiag(obj.IC.rhos{y}))';
            
        end
        
        
        function alphas_shaped = reshape_dual_variables(obj, a)
            alphas_shaped = reshape(a,obj.k-1,obj.n);
        end
        
        
        

        function y_pred = predict(obj, x_test)
            KM = obj.ker_fun(x_test,obj.x);
            n_test = size(x_test,2);
            preds = [];
            for i = 1:n_test
                pred = obj.IC.Bi*sum(reshape(obj.rho_sparse_mat*vec((obj.alphas).*KM(i,:)),2,obj.n),2);
                preds = [preds, pred];
            end
            
            preds = obj.IC.Pi_inv*preds;
            [~,y_pred] = max(preds,[],1);
        end
    end
end

