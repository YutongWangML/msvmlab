function loss = loss_functions(loss_name)
    %KERNEL_FUNCTIONS 
    %   INPUTS
    %   kernel_name = name of the loss, e.g., 
    %       cs = Crammer-Singer, 
    %       ww = Weston-Watkins
    %
    %   OUTPUT
    %   loss = a function handle of a function that takes k-1 vector to a real number
    %   
    %   SUPPORTED LOSSES
    %   + Crammer-Singer
    %   | loss_name = 'cs'
    %   
    %   + Weston-Watkins
    %   | loss_name = 'ws'
    
    switch loss_name
        case 'cs'
%             disp("Crammer-Singer hinge");
            loss = @(z) max(max(z),0);
        case 'ww'
%             disp("Weston-Watkins hinge");
            loss = @(z) sum(max(z,0));
    end

end
