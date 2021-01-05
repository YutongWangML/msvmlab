classdef kernel_msvm_decomp < kernel_msvm
    %KERNEL_MSVM_DECOMP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        grad    % gradient
        ws      % working set
        KMws    % row of the kernel matrix corresponding to the current working set
        alpha_ws_new %
        Kjjs % the diagonal entries of the kernel matrix
    end
    
    methods
        function obj = kernel_msvm_decomp(x,y,k,C, ker_fun)
            %KERNEL_MSVM_DECOMP Construct an instance of this class
            %   Detailed explanation goes here
            
            obj@kernel_msvm(x, y, k, C, ker_fun);
            
            obj.alphas = zeros(obj.k-1, obj.n);
            obj.grad = ones(obj.k-1, obj.n);
            
            
            % initialize the diagonal kernels
            obj.Kjjs = zeros(1,obj.n);
            for j = 1:obj.n
                xj = obj.x(:,j);
                obj.Kjjs(j) = obj.ker_fun(xj,xj);
            end
            
            
            obj.ws = 1;
            
            obj.update_KMws();
            
            obj.alpha_ws_new = obj.get_alphaj_new(obj.ws);
            
        end
        
        function [dual_objective,obj] = solve_WW(obj,max_iter)
            % solves the Weston-Watkins SVM via quadratic program using CVX
            %
            %   See https://web.eecs.umich.edu/~yutongw/post/2020/11/06/a-derivation-of-the-weston-watkins-svm-dual-problem/#primal-problem
            %   for the mathematical formula of the objective function
            
            if nargin < 2
                max_iter = 1000;
            end
            for i = 1:max_iter
                obj.solve_WW_iter();
            end
            
            dual_objective = 0; 
        end
        
        function alphaj_new = get_alphaj_new(obj,j)
            Kjj = obj.Kjjs(j);
            v = (obj.grad(:,j) + ...
                    (obj.rc.Bi)...
                    *obj.alphas(:,j)...
                    *Kjj)...
                /Kjj;
            alphaj_new = ww_subprob_solver(v, obj.C);
        end
        
        function obj = update_grad(obj,deltaj)
            j = obj.ws;
            for s = 1:obj.n
                obj.grad(:,s) = obj.grad(:,s) ...
                    - obj.KMws(s)...
                        *(obj.rc.rhos{obj.y(s)})...
                        *(obj.rc.Bi)...
                        *(obj.rc.rhos{obj.y(j)})'...
                        *deltaj;
            end
        end
        
        
        function obj = update_ws(obj)
            best_gain = 0;
            
            for j = 1:obj.n
                alphaj_new = obj.get_alphaj_new(j);
                Kjj = obj.Kjjs(j);
                deltaj = alphaj_new - obj.alphas(:,j);
                gain_at_j = deltaj'...
                    *(obj.grad(:,j) ...
                        - (1/2)*Kjj*obj.rc.Bi*deltaj);
                if(gain_at_j > best_gain)
                    obj.alpha_ws_new = alphaj_new;
                    best_gain = gain_at_j;
                    obj.ws = j;
                end
            end
        end
        
        function obj = update_KMws(obj)
            obj.KMws = obj.ker_fun(obj.x(:,obj.ws), obj.x);
        end
        
        
        function obj = solve_WW_iter(obj)
            j = obj.ws;
            
            alphaj_cur = obj.alphas(:,j);
            alphaj_new = obj.alpha_ws_new;
            
            % update grad
            obj.update_grad(alphaj_new - alphaj_cur);
            
            % update alpha
            obj.alphas(:,j) = alphaj_new;
            
            % update working set
            obj.update_ws();
            
            % update kernel vector
            obj.update_KMws();
        end
        
        
    end
end

