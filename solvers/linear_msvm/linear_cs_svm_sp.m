classdef linear_cs_svm_sp < linear_svm
    %LINEAR_MSVM_SP Saddle-point method for solving linear MSVM
    
    properties
        pT      % pT is a (n x k-1) matrix where each row pT(i,:) represents a probability vector with its last entry chopped off
    end
    
    methods
        function obj = linear_cs_svm_sp(x,y,k,C)
            obj@linear_svm(x, y, k, C)

            obj.w = randn(obj.d, obj.k-1);
            obj.pT = zeros(obj.n,obj.k-1);
        end
        
        function [obj,primal_approx] = solve(obj,max_iter, gam, decay)
            if nargin < 2
                max_iter = 1000;
            end
            if nargin < 3
                gam = 1;
            end
            if nargin < 4
                decay = 0.99;
            end
            primal_approx = [];

            for n_steps = 1:max_iter
                obj = obj.step_GDmax(gam);
                val = obj.primal_objective();
                primal_approx = [primal_approx,val];
                gam = decay*gam;
            end
        end
        
        function obj = step_GDmax(obj,step_size)
            obj = obj.update_pT();
            obj = obj.update_w_GD(step_size);
        end
        
        function obj = update_pT(obj)
            for i = 1:obj.n
                obj.pT(i,:) = zeros(1,obj.k-1);
                z = 1-obj.IC.rhos{obj.y(i)}*obj.w'*obj.x(:,i);
                [val,j] = max(z);
                if val>=0
                    obj.pT(i,j) = 1;
                end
            end
        end
        
        function obj = update_w_GD(obj,step_size)
            grad = zeros(obj.d, obj.k-1);
            for i = 1:obj.n
                xi = obj.x(:,i);
                piT = obj.pT(i,:);
                rho_yi = obj.IC.rhos{obj.y(i)};
                grad = grad + xi*piT*rho_yi;
            end
            grad = -obj.C*grad;
            grad = grad + obj.w*obj.IC.B;
            obj.w = obj.w - step_size*grad;
        end
        
        
%         function obj = step_minmax(obj)
%             obj = obj.update_pT();
%             obj = obj.update_w_min();
%         end
%         function obj = update_w_min(obj)
%             w_new = zeros(obj.d, obj.k-1);
%             for i = 1:obj.n
%                 xi = obj.x(:,i);
%                 piT = obj.pT(i,:);
%                 rho_yi = obj.IC.rhos{obj.y(i)};
%                 w_new = w_new + xi*piT*rho_yi;
%             end
%             obj.w = obj.C*w_new*obj.IC.Bi;
%         end
        
        

    end
end

