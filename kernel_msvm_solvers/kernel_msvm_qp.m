classdef kernel_msvm_qp < kernel_msvm
    %KERNEL_MSVM_QP solves kernel Multiclass SVMs via quadratic programs
    %
    %   Requires CVX
    %
    %   Current implementation supports
    %   - Crammer-Singer SVM
    %   - Weston-Watkins SVM
    %   
    
    properties
        
        KM  % n x n kernel matrix, where n is the number of instances
        Q   % QP matrix

    end
    
    methods
        function obj = kernel_msvm_qp(x,y,k,C, ker_fun)
            %KERNEL_MSVM_QP Construct an instance of this class
            obj@kernel_msvm(x, y, k, C, ker_fun)
            
            obj.KM = ker_fun(x,x);
            
            rc = obj.rc;

            Bi = rc.Bi;

            obj.n = length(y);
            obj.Q = [];
            for i = 1:obj.n
                R = [];
                for j = 1:obj.n
                    R =  [R, obj.KM(i,j)*rc.rhos{y(i)}*Bi*rc.rhos{y(j)}'];
                end
                obj.Q = [obj.Q;R];
            end

        end

        
        function [dual_objective,obj] = solve_WW(obj)
            % solves the Weston-Watkins SVM via quadratic program using CVX
            %
            %   See https://web.eecs.umich.edu/~yutongw/post/2020/11/06/a-derivation-of-the-weston-watkins-svm-dual-problem/#primal-problem
            %   for the mathematical formula of the objective function

            cvx_begin
                variable a(obj.n*(obj.k-1))
                minimize( (1/2)*a'*obj.Q*a - sum(a) )
                subject to
                a >= 0
                a <= obj.C
            cvx_end
            
            obj.alphas = obj.reshape_dual_variables(a);
            dual_objective = sum(a)-(1/2)*a'*obj.Q*a;
        end
        
        
        
        function [dual_objective, obj] = solve_CS(obj)
            % solves the Crammer-Singer SVM via quadratic program using CVX
            %
            %   See https://web.eecs.umich.edu/~yutongw/post/2020/11/06/a-derivation-of-the-weston-watkins-svm-dual-problem/#primal-problem
            %   for the mathematical formula of the objective function
            R = (1:(obj.n))'==repelem(1:obj.n,obj.k-1);
            cvx_begin
                variable a(obj.n*(obj.k-1))
                minimize( (1/2)*a'*obj.Q*a - sum(a) )
                subject to
                a >= 0
                R*a <= obj.C
            cvx_end
            
            obj.alphas = obj.reshape_dual_variables(a);
            dual_objective = sum(a)-(1/2)*a'*obj.Q*a;
        end
        
    end
end

