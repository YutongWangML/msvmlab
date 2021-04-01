function [w,alphas] = train_McLinearWW(x,y,k,C,maxiter,w_init,alphas_init)
    n = size(x,2);
    d = size(x,1);
    ww = ww_loss(k);
    A = pinv(ww.Pi');
    B = A*A';
    Brt = sqrtm(B);
    Bi = B^(-1);


    if nargin > 5
        w = w_init;
        alphas = alphas_init;
    else
        w = zeros(d,k-1);
        alphas = zeros(k-1,n);
    end


    for j = 1:maxiter
        shuff = randperm(n);
%         shuff = 1:n;
        for i = shuff
            xi = x(:,i);
            nsi = sum(xi.^2); %norm squared
            yi = y(i);
            
            alphai_old = alphas(:,i);

            v = (ones(k-1,1) - (ww.rhos{yi}*(w'*xi) - Bi*alphai_old*nsi))/nsi;

            alphai_new = proj_to_wedge5(v,C);
%             alphai_new = proj_WW(v,C);
%             i-1
%             [v,alphai_new]

%             dd = xi*(alphai_new-alphai_old)'*ww.rhos{yi};
%             w = w + dd + sum(dd,2);
            w = w + xi*(alphai_new-alphai_old)'*ww.rhos{yi}*Bi;
            alphas(:,i) = alphai_new;
        end
    end
end



function [beta_true,i] = proj_WW(v,C)
%PROJ_TO_WEDGE4 Summary of this function goes here
%   Detailed explanation goes here
vals = [v;v-C];

beta_true = zeros(length(v),1);

for i = 1:(2*length(vals))
    j = ceil(i/2);
    if mod(i,2) == 0 
        pat = pat_fun(v - vals(j),C);
    else
        pat = pat_fun(v - vals(j)+eps,C);
    end
    % create the candidate
    beta = pat2beta(pat,v, C);
    
    % check the KKT condition
    if all(beta <= C) && all(beta >= 0) 
        Obeta = beta + sum(beta);
        if all(Obeta(pat==1)<=v(pat==1)) && all(Obeta(pat==-1)>=v(pat==-1)) 
            beta_true = beta;
            break
        end
    end
end
end

function pat = pat_fun(x,C)
    pat = -1*(x<=0) + 1*(x>= C);
end



