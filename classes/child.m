classdef child < parent
    %CHILD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property2
    end
    
    methods
        function obj = child(inputArg1,inputArg2)
            %CHILD Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function obj = hi(obj, inputArg1,inputArg2)
            %CHILD Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
    end
end

