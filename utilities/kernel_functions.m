function kernel = kernel_functions(kernel_name,varargin)
    %KERNEL_FUNCTIONS 
    %   INPUTS
    %   kernel_name = name of the kernel, e.g., rbf.
    %   varargin = options to be passed to constructing the kernel function.
    %
    %   OUTPUT
    %   kernel = a function that takes two matrices 
    %       x1 of size (d x n1)
    %       x2 of size (d x n2)
    %       returns a matrix kernel(x1, x2) of size (n1 x n2)
    %   
    %   SUPPORTED KERNELS
    %   + Radial basis kernel
    %   | kernel_name = 'rbf'
    %   | varargin{1} = sigma squared
    %   
    %   + Linear kernel
    %   | kernel_name = 'linear'
    %   | varagin = none
    
    switch kernel_name
        case 'rbf'
            disp("Radial basis kernel with sigma^2 = "+num2str(varargin{1}))
            kernel = radial_basis_kernel(varargin{1});
        case 'linear'
            disp("Linear kernel")
            kernel = linear_kernel();
    end

end

function out = radial_basis_kernel(sigma_squared)
    out = @(x1,x2) exp(-dist2(x1',x2')/(2*sigma_squared));
end

function out = linear_kernel()
    out = @(x1,x2) x1'*x2;
end