classdef linear_svm
    %LINEAR_MSVM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        w   % linear classifier
        k   % number of classes
        n   % number of instances
        d   % number of features
        C   % regularizer
        
        x   % data matrix
        y   % label
        
        IC  % reflection code
    end
    
    methods
        function obj = linear_svm(x, y, k, C)
            %LINEAR_MSVM Construct an instance of this class
            %   Detailed explanation goes here
            obj.k = k;
            obj.C = C;
            obj.x = x;
            obj.y = y;
            obj.n = size(x,2);
            obj.d = size(x,1);
            IC = involution_code(k);
            obj.IC = IC;
        end
        
        function primal_val = primal_objective(obj)
            primal_val = 0;
            for i = 1:obj.n
                z = 1-obj.IC.rhos{obj.y(i)}*obj.w'*obj.x(:,i);
                primal_val = primal_val + max(max(z),0);
            end
            primal_val = obj.C*primal_val;
            primal_val = primal_val + (1/2)*trace(obj.w'*obj.w*obj.IC.B);
        end
        
        function y_pred = predict(obj, x_test)
%             KM = obj.ker_fun(x_test,obj.x);
%             n_test = size(x_test,2);
%             preds = [];
%             for i = 1:n_test
%                 pred = obj.IC.Bi*sum(reshape(obj.rho_sparse_mat*vec((obj.alphas).*KM(i,:)),2,obj.n),2);
%                 preds = [preds, pred];
%             end
            
            preds = obj.IC.Pi_inv*obj.w'*x_test;
            [~,y_pred] = max(preds,[],1);
        end
    end
end

