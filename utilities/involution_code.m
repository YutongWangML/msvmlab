classdef involution_code < handle
    
    % implements the tools associated with the involution code, a framework
    % for working with multiclass learning algorithms
    
    properties
        k % number of classes
        rhos % rhos{1} = rho1 and so on
        R % [rho1; rho2; ...; rhok] matrix
        
        Pi % v-to-z transformation
        Pi_inv % z-to-v transformation
        B
        Bi % B inverse matrix
        
    end
    
    properties (Access = private)
        
    end
    
    methods
        
        function obj = involution_code(k)
            % involution_code constructor
            obj.k = k;
            obj.rhos = {}; % this is initialized in make_R()
            obj.R = obj.make_R();
            
            obj.Pi = [ones(k-1,1), -eye(k-1)];
            obj.Pi_inv = pinv(obj.Pi);
            obj.Bi = ones(k-1,k-1) + eye(k-1);
            obj.B = inv(obj.Bi);
        end
        
    end
    
    
    
    methods (Access = private)
        
        
        function R = make_R(obj)
            I = eye(obj.k-1);
            R = I;
            obj.rhos{1} = sparse(I);
            for i = 1:(obj.k-1)
                A = I;
                A(:,i) = -1;
                obj.rhos{i+1} = sparse(A);
                R = [R; A];
            end
        end
    end
end

