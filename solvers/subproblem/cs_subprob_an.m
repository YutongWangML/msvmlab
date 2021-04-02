function beta = cs_subprob_an(v,C)
% MATLAB implementation of the Crammer-Singer subproblem solver
% 
% Solves the subproblem of the Crammer-Singer SVM
% The time complexity is O(k log k) where k is the number of classes

    num_pos = 0;
    sum_v_pos = 0;

    [v,vdx]=sort(v,'desc');
    k = length(v)+1;

    beta = zeros(k-1,1);
    
    if v(1) > 0
        for i = 1:(k-2)
            % main loop
            num_pos = num_pos + 1;
            sum_v_pos = sum_v_pos + v(i);


            sum_b_pos = sum_v_pos/(1+num_pos);
            if sum_b_pos <= C
                % lambda = 0 case:
                if (v(i) - sum_b_pos >= 0) && (v(i+1) - sum_b_pos <= 0)
                    % KKT conditions satisfied, return
                    beta(vdx(1:num_pos)) = v(1:num_pos) - sum_b_pos;
                    return;
                end
            else
                % lambda > 0 case:
                lam = (sum_v_pos -C)/num_pos - C;
                if lam >= 0 && (v(i) - (lam+C) >= 0) && (v(i+1) - (lam+C) <= 0)
                    % KKT conditions satisfied, return
                    beta(vdx(1:num_pos)) = v(1:num_pos) - (lam+C);
                    return;
                end
            end
        end
        % last iteration of the loop i = k-1 is slightly different:
        i = k-1;
        num_pos = num_pos + 1;
        sum_v_pos = sum_v_pos + v(i);


        sum_b_pos = sum_v_pos/(1+num_pos);
        if sum_b_pos <= C
            % lambda = 0 case,
            % check the other conditions
            if (v(i) - sum_b_pos >= 0)
                % KKT conditions satisfied, return
                beta(vdx(1:num_pos)) = v(1:num_pos) - sum_b_pos;
                return;
            end
        else
            % lambda > 0
            lam = (sum_v_pos -C)/num_pos - C;
            if lam >= 0 && (v(i) - (lam+C) >= 0)
                % KKT conditions satisfied, return
                beta(vdx(1:num_pos)) = v(1:num_pos) - (lam+C);
                return;
            end
        end
    end

end

