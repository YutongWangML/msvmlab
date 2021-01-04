classdef parent < handle
    %PARENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = parent()
            %PARENT Construct an instance of this class
            %   Detailed explanation goes here
            
        end
        
        function out = stuff(obj)
            out = obj.Property1;
        end
    end
end

