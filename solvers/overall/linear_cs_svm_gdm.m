classdef linear_cs_svm_gdm < linear_svm_gdm
    %LINEAR_MSVM_SP GDmax method for solving linear Crammer-Singer SVM
    
    properties
    end
    
    methods
        function obj = linear_cs_svm_gdm(x,y,k,C)
            obj@linear_svm_gdm(x, y, k, C, loss_functions('cs'));
            
        end
        
        
        function p = inner_max_solver(~,z)
            p = zeros(1,length(z));
            z = 1-z;
            [val,j] = max(z);
            if val>=0
                p(j) = 1;
            end
        end 
    end
end

