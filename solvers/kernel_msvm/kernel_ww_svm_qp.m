classdef kernel_ww_svm_qp < kernel_svm_qp
    %KERNEL_MSVM_QP solves kernel WW SVMs via quadratic programs
    %
    %   Requires CVX
    %
    
    properties
        
    end
    
    methods
        function obj = kernel_ww_svm_qp(x,y,k,C, ker_fun)
            % Constructor
            obj@kernel_svm_qp(x, y, k, C, ker_fun)
        end
        
        
        
        function [dual_objective,obj] = solve(obj)
            % solves the Weston-Watkins SVM via quadratic program using CVX
            %
            %   See https://web.eecs.umich.edu/~yutongw/post/2020/11/06/a-derivation-of-the-weston-watkins-svm-dual-problem/#primal-problem
            %   for the mathematical formula of the objective function

            cvx_begin quiet
                variable a(obj.n*(obj.k-1))
                minimize( (1/2)*a'*obj.Q*a - sum(a) )
                subject to
                a >= 0
                a <= obj.C
            cvx_end
            
            obj.alphas = obj.reshape_dual_variables(a);
            dual_objective = sum(a)-(1/2)*a'*obj.Q*a;
        end
        
    end
end

