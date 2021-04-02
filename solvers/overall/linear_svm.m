classdef linear_svm < handle
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
        
        function val = normIC(obj)
            % Calculate the involution-code norm of w

%             val = trace(obj.w'*obj.w*obj.IC.B); 

            val = sum(sum_square(obj.w*(obj.IC.Pi_inv)')); %  Identity: IC.B = (IC.Pi_inv)'*(IC.Pi_inv)
        end
        
        function y_pred = predict(obj, x_test)
            preds = obj.IC.Pi_inv*obj.w'*x_test;
            [~,y_pred] = max(preds,[],1);
        end
    end
end

