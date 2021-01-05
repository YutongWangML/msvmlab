classdef kernel_msvm_decomp < kernel_msvm
    %KERNEL_MSVM_DECOMP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = kernel_msvm_decomp(x,y,k,C, ker_fun)
            %KERNEL_MSVM_DECOMP Construct an instance of this class
            %   Detailed explanation goes here
            
            obj@kernel_msvm(x, y, k, C, ker_fun);
        end
        
    end
end

