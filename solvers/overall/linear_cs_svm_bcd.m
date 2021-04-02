classdef linear_cs_svm_bcd < linear_svm_bcd
    properties
    end
    
    methods
        function obj = linear_cs_svm_bcd(x, y, k, C)
            obj@linear_svm_bcd(x, y, k, C, loss_functions('cs'), @cs_subprob_an);
        end
    end
end

