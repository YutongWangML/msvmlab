classdef linear_svm_bcd < linear_svm
    %LINEAR_MSVM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        subprob_solver
        alphas
        
        IAM % iterative algorithm manager
    end
    
    methods
        function obj = linear_svm_bcd(x, y, k, C, loss, subprob_solver)
            obj@linear_svm(x, y, k, C, loss);
            obj.subprob_solver = subprob_solver;
            obj.IAM = iter_algo_mgr();
        end
        
        
        function obj = solve(obj,maxiter)
            if nargin == 0
                maxiter = 1;
            end
            
            if obj.IAM.algo_params.isKey("w_init")
                obj.w = obj.IAM.algo_params.isKey("w_init");
                obj.alphas = obj.IAM.algo_params.isKey("alphas_init");
            else
                obj.w = zeros(obj.d,obj.k-1);
                obj.alphas = zeros(obj.k-1,obj.n);
            end

            obj.IAM.start_timer();
            for j = 1:maxiter
                shuff = randperm(obj.n);
                for i = shuff
                    xi = obj.x(:,i);    
                    nsi = sum(xi.^2);   %norm squared
                    yi = obj.y(i);      
                    alphai_old = obj.alphas(:,i);

                    v = (1 - (obj.IC.rhos{yi}*(obj.w'*xi) - obj.IC.Bi*alphai_old*nsi))/nsi;
                    alphai_new = obj.subprob_solver(v,obj.C);
        
                    % update w
                    obj.w = obj.w + xi*(alphai_new-alphai_old)'*obj.IC.rhos{yi}*obj.IC.Bi;
                    % update alpha(:,i)
                    obj.alphas(:,i) = alphai_new;
                end
                
                if obj.IAM.do_track()
                    obj.IAM.stop_timer();
                    val = obj.get_primal_objective();
                    obj.IAM.record_qty('primal_objective', val);
                    obj.IAM.start_timer();
                end
                obj.IAM.n_steps = obj.IAM.n_steps + 1;
            end
        end
        
    end
end

