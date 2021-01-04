classdef kernel_msvm_qp
    %KERNEL_MSVM_QP solves kernel Multiclass SVMs via quadratic programs
    %
    %   Requires CVX
    %
    %   Current implementation supports
    %   - Crammer-Singer SVM
    %   - Weston-Watkins SVM
    %   
    
    properties
        k   % number of classes
        n   % number of instances
        
        KM  % n x n kernel matrix, where n is the number of instances
        y   % n vector of class labels from 1 to k
        
        C   % regularization parameter
        Q   % QP matrix
    end
    
    methods
        function obj = kernel_msvm_qp(KM,y,k,C)
            %KERNEL_MSVM_QP Construct an instance of this class
            
            obj.KM = KM;
            obj.y = y;
            obj.k = k;
            obj.C = C;
            
            rc = reflection_code(k);

            Bi = rc.Bi;

            obj.n = length(y);
            obj.Q = [];
            for i = 1:n
                R = [];
                for j = 1:n
                    R =  [R, K(i,j)*rc.rhos{y(i)}*Bi*rc.rhos{y(j)}'];
                end
                obj.Q = [obj.Q;R];
            end
        end
        
        function [x, dual_obj] = solve_WW(obj)
            % solves the Weston-Watkins SVM via quadratic program using CVX
            %
            %   See https://web.eecs.umich.edu/~yutongw/post/2020/11/06/a-derivation-of-the-weston-watkins-svm-dual-problem/#primal-problem
            %   for the mathematical formula of the objective function

            cvx_begin
                variable x(n*(k-1))
                minimize( (1/2)*x'*obj.Q*x - sum(x) )
                subject to
                x >= 0
                x <= obj.C
            cvx_end

            dual_obj = sum(x) - (1/2)*x'*obj.Q*x;
        end
    end
end

