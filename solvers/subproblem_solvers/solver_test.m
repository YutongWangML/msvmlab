km1 = 1000;
Bi = ones(km1,km1) + eye(km1);
Walrus_time= [];
MOSEK_time = [];
discrep = [];

% v = [0.507233,0.281202,-0.048962,-0.062557,-0.117048,-0.008917,-0.061194,-0.050570,-0.040375,-0.077025,-0.056031,-0.314523,-0.187464,-0.065952,-0.189959,-0.085937,-0.106328,-0.084399,-0.104548]';

C = 1;

for i = 1:100
v = randn(km1,1);

tic
a1 = ww_subprob_solver(v,C);
Walrus_time = [Walrus_time,toc];

tic
a2 = ww_subprob_solver_CVX(v,C,Bi);
MOSEK_time = [MOSEK_time,toc];
% toc
% sum(a1>0)
discrep = [discrep, sum((a1-a2).^2)];
end

%%
% format longG

disp([mean(Walrus_time), std(Walrus_time)])

disp([mean(MOSEK_time), std(MOSEK_time)])
