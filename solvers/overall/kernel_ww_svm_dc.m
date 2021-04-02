classdef kernel_ww_svm_dc < kernel_svm
    %KERNEL_MSVM_DECOMP Decomposition method based solver for the
    %Weston-Watkins SVM
    
    properties
        grad            % gradient of the dual objective
        ws              % working set
        KMws            % row of the kernel matrix corresponding to the current working set
        alpha_ws_new    % the updated block dual variables over the working set
        Kjjs            % the diagonal entries of the kernel matrix
        gap1            % first part of the duality gap
        gap2            % second part of the duality gap
        gaps            % trajectory of gaps
    end
    
    methods
        function obj = kernel_ww_svm_dc(x,y,k,C, ker_fun)
            % constructor
            
            % initialize superclass
            obj@kernel_svm(x, y, k, C, ker_fun);
            
            % initialize parameters
            obj.alphas = zeros(obj.k-1, obj.n);
            obj.grad = ones(obj.k-1, obj.n);
            
            % precompute the diagonal kernels
            obj.Kjjs = zeros(1,obj.n);
            for j = 1:obj.n
                xj = obj.x(:,j);
                obj.Kjjs(j) = obj.ker_fun(xj,xj);
            end
            
            % since the alphas are initialized to zero, we can set the
            % working set arbitrarily to be the first data point
            obj.ws = 1;
            
            obj.update_KMws();
            
            obj.alpha_ws_new = obj.get_alphaj_new(obj.ws);
            
            obj.gap1 = 0;
            obj.gap2 = obj.C*obj.n*(obj.k-1);
            obj.gaps = [];
        end
        
        function [dual_objective,obj] = solve(obj,max_iter)
            % solves the Weston-Watkins SVM via quadratic program using CVX
            %
            %   See https://web.eecs.umich.edu/~yutongw/post/2020/11/06/a-derivation-of-the-weston-watkins-svm-dual-problem/#primal-problem
            %   for the mathematical formula of the objective function
            
            if nargin < 2
                max_iter = 1000;
            end
            for i = 1:max_iter
                obj.solve_iter();
                obj.gaps = [obj.gaps, (obj.gap1+obj.gap2)];
            end
            
            dual_objective = 0; 
        end
        
        function alphaj_new = get_alphaj_new(obj,j)
            % solves the dual subproblem at the j-th block dual variable
            
            Kjj = obj.Kjjs(j);
            v = (obj.grad(:,j) + ...
                    (obj.IC.Bi)...
                    *obj.alphas(:,j)...
                    *Kjj)...
                /Kjj;
            alphaj_new = ww_subprob_an(v, obj.C);
        end
        
        function obj = update_grad(obj,deltaj)
            % updates the 'grad' property (full gradient of the dual objective)
            % updates the 'gap1' and 'gap2' property as well
            
            j = obj.ws;
            Kjj = obj.Kjjs(j);
            
            obj.gap1 = obj.gap1 - deltaj'...
                    *(2*obj.grad(:,j) - 1 ...
                        - Kjj*obj.IC.Bi*deltaj);
            
            obj.gap2 = 0;
            j = obj.ws;
            for s = 1:obj.n
                obj.grad(:,s) = obj.grad(:,s) ...
                    - obj.KMws(s)...
                        *((obj.IC.rhos{obj.y(s)})...
                        *((obj.IC.Bi)...
                        *((obj.IC.rhos{obj.y(j)})'... % note the transpose
                        *deltaj)));
                obj.gap2 = obj.gap2 + obj.C*sum(max(0,obj.grad(:,s)));
            end
            
        end
        
        
        function obj = update_ws(obj)
            % updates the 'ws' property (index of the working set of size 1)
            % according to the maximum gain criterion
            
            % see the following reference for theory
            % Steinwart, Ingo, Don Hush, and Clint Scovel. "Training SVMs Without Offset." Journal of Machine Learning Research 12.1 (2011).
            
            best_gain = 0;
            
            for j = 1:obj.n
                alphaj_new = obj.get_alphaj_new(j);
                Kjj = obj.Kjjs(j);
                deltaj = alphaj_new - obj.alphas(:,j);
                gain_at_j = deltaj'...
                    *(obj.grad(:,j) ...
                        - (1/2)*Kjj*obj.IC.Bi*deltaj);
                if(gain_at_j > best_gain)
                    obj.alpha_ws_new = alphaj_new;
                    best_gain = gain_at_j;
                    obj.ws = j;
                end
            end
        end
        
        function obj = update_KMws(obj)
            % update the 'KMws' property (row of the kernel matrix
            % corresponding to the current working set
            
            obj.KMws = obj.ker_fun(obj.x(:,obj.ws), obj.x);
        end
        
        
        function obj = solve_iter(obj)
            j = obj.ws;
            
            alphaj_cur = obj.alphas(:,j);
            alphaj_new = obj.alpha_ws_new;
            
            % update grad AND gap2
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