classdef kernel_cs_svm_qp < kernel_svm_qp
    %KERNEL_MSVM_QP solves kernel Multiclass SVMs via quadratic programs
    %
    %   Requires CVX
    %
    %   Current implementation supports
    %   - Crammer-Singer SVM
    %   - Weston-Watkins SVM
    %   
    
    properties
        

    end
    
    methods
        function obj = kernel_cs_svm_qp(x,y,k,C, ker_fun)
            % Constructor
            obj@kernel_svm_qp(x, y, k, C, ker_fun)
        end
        
        
        function obj = solve(obj)
            % solves the Crammer-Singer SVM via quadratic program using CVX
            %
            %   See https://web.eecs.umich.edu/~yutongw/post/2020/11/06/a-derivation-of-the-weston-watkins-svm-dual-problem/#primal-problem
            %   for the mathematical formula of the objective function
            R = (1:(obj.n))'==repelem(1:obj.n,obj.k-1);
            cvx_begin quiet
                variable a(obj.n*(obj.k-1))
                minimize( (1/2)*a'*obj.Q*a - sum(a) )
                subject to
                a >= 0
                R*a <= obj.C
            cvx_end
            
            obj.alphas = obj.reshape_dual_variables(a);
            obj.dual_objective = sum(a)-(1/2)*a'*obj.Q*a;
        end
        
    end
end

