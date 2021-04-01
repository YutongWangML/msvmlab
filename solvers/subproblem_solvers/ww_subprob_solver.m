function beta = ww_subprob_solver(v,C)
% MATLAB implementation of the algorithm in
% https://arxiv.org/abs/2102.05640
% 
% Solves the subproblem of the Weston-Watkins SVM
% The time complexity is O(k log k) where k is the number of classes

    num_up = 0;
    num_mi = 0;
    sum_v_mi = 0;

    [v,vdx]=sort(v,'desc');
    k = length(v)+1;

    vals_unsrt = [v;v-C];

    [~,idx] = sort(vals_unsrt,'desc');
%     UP = 0;
    beta = zeros(k-1,1);
    for i = 1:(2*k-2)
        % main loop
        if idx(i) > k-1
            UP = 1;
        else
            UP = 0;
        end

        if UP
            sum_v_mi = sum_v_mi - v(num_up+1);
            num_up = num_up + 1;
            num_mi = num_mi - 1;
        else
            sum_v_mi = sum_v_mi + v(num_up+num_mi+1);
            num_mi = num_mi + 1;
        end
        
        gam = (C*num_up + sum_v_mi)/(num_mi+1);
        num_dn = k - 1 - num_up - num_mi;
        
        
        % check KKT condition
        kkt = 1;
        if num_up > 0
            kkt = kkt * ((C+gam) <= v(num_up));
        end
        
        if num_mi > 0
            kkt = kkt * ((C+gam) >= v(num_up+1));
            kkt = kkt * ((gam) <= v(num_up+num_mi));
        end
        
        if (num_dn > 0) || (num_up+num_mi + 1 <= k-1)
            kkt = kkt * ((gam) >= v(num_up+num_mi+1));
        end
        
        if kkt
            beta(vdx(1:num_up)) = C;
            beta(vdx((num_up+1):(num_up + num_mi))) = ...
                v((num_up+1):(num_up + num_mi)) - gam; 
            break;
        end
        
    end

end

