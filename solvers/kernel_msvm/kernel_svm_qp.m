classdef kernel_svm_qp < kernel_svm
    %KERNEL_MSVM_QP abstract base class for solving kernel Multiclass SVMs via quadratic programs
    %
    %   Current implementation supports
    %   - Crammer-Singer SVM
    %   - Weston-Watkins SVM
    
    properties
        
        KM  % n x n kernel matrix, where n is the number of instances
        Q   % QP matrix, the Hessian of the quadratic program

    end
    
    methods
        function obj = kernel_svm_qp(x,y,k,C, ker_fun)
            %KERNEL_MSVM_QP Construct an instance of this class
            obj@kernel_svm(x, y, k, C, ker_fun)
            
            obj.KM = ker_fun(x,x);
            
            IC = obj.IC;

            Bi = IC.Bi;

            obj.n = length(y);
            obj.Q = [];
            for i = 1:obj.n
                R = [];
                for j = 1:obj.n
                    R =  [R, obj.KM(i,j)*IC.rhos{y(i)}*Bi*IC.rhos{y(j)}'];
                end
                obj.Q = [obj.Q;R];
            end

        end
    end
end

