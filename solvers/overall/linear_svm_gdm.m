classdef linear_svm_gdm < linear_svm
    % GDmax method for solving generic linear SVM
    
    properties
        pT      % pT is a (n x k-1) matrix where each row pT(i,:) represents a probability vector with its last entry chopped off
        
        IAM % iterative algorithm manager
    end
    
    methods(Abstract)
        p = inner_max_solver(z)
    end
    
    methods
        function obj = linear_svm_gdm(x,y,k,C, loss)
            obj@linear_svm(x, y, k, C, loss);
            obj.w = randn(obj.d, obj.k-1);
            obj.pT = zeros(obj.n,obj.k-1);
            obj.IAM = iter_algo_mgr();
        end
        
        function obj = solve(obj,max_iter)
            
            if nargin < 2
                max_iter = 1;
            end
            
            if ~obj.IAM.algo_params.isKey("step_size")
                obj.IAM.algo_params("step_size") = 1;
            end
            if ~obj.IAM.algo_params.isKey("step_size_decay")
                obj.IAM.algo_params("step_size_decay") = 0.99;
            end
            
            obj.IAM.start_timer();
            for n_steps = 1:max_iter
                step_size = obj.IAM.algo_params("step_size");
                
                obj.step_GDmax(step_size);
                
                obj.IAM.algo_params("step_size") = step_size*obj.IAM.algo_params("step_size_decay");
                
                if obj.IAM.do_track()
                    obj.IAM.stop_timer();
                    val = obj.get_primal_objective();
                    obj.IAM.record_qty('primal_objective', val);
                    obj.IAM.start_timer();
                end
                obj.IAM.n_steps = obj.IAM.n_steps + 1;
                
            end
        end
        
        function obj = step_GDmax(obj,step_size)
            obj.update_pT();
            obj.update_w(step_size);
        end
        
        
        function obj = update_pT(obj)
            for i = 1:obj.n
                obj.pT(i,:) = obj.inner_max_solver(obj.IC.rhos{obj.y(i)}*obj.w'*obj.x(:,i));
            end
        end
        
        function obj = update_w(obj,step_size)
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
    end
end

