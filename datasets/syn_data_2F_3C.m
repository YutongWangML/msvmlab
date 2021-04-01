classdef syn_data_2F_3C < handle
    % Synthetic datasets with 2 features, 3 classes
    
    properties
        k
        IC
    end
    
    methods
        function obj = syn_data_2F_3C()
            % Construct an instance of this class
            obj.k = 3;
            obj.IC = involution_code(3);
        end
        
        function [x,y] = circle(obj,n)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            thetas = linspace(0,2*pi,n);
            x = [cos(thetas);sin(thetas)];
            [~,y] = max(obj.IC.Pi_inv*x,[],1);
        end
        
        
        function [x,y] = nested_circles(obj,n,ang)
            % Two ciICles inside one another
            if nargin < 3
                ang = pi/4;
            end
            
            [x1,y1] = circle(obj,n);
            [x2,y2] = circle(obj,n);
            x2 = 0.5*x2;
            R = [cos(ang),-sin(ang);sin(ang),cos(ang)];
            x2 = R*x2;
            x = [x1,x2];
            y = [y1,y2];
        end
        
        
        function [x,y] = trefoil(~,n,p)
            if nargin < 3
                p = 1.25;
            end
            thetas = linspace(0,2*pi,4);
            
            centers = [cos(thetas(1:3)); sin(thetas(1:3))];
            x = [];
            y = [];
            for i = 1:3
                thetas = linspace(-pi/2,pi,n)+(i-1)*(2*pi/3);
                x = [x,p*[cos(thetas); sin(thetas)]+centers(:,i)];
                y = [y,i*ones(1,n)];
            end
        end
        
        
        function [x,y] = GMM(~,n,p)
            if nargin < 3
                p = 0.5;
            end
            thetas = linspace(0,2*pi,4);
            
            centers = [cos(thetas(1:3)); sin(thetas(1:3))];
            x = [];
            y = [];
            for i = 1:3
                x = [x,p*randn(2,n)+centers(:,i)];
                y = [y,i*ones(1,n)];
            end
        end
    end
end

