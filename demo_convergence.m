%Synthetic data
close all; clear all
randn('seed',2018);rand('seed',2018)
data=abs(rand(20,5));
U_true = data;
n = size(data,1); r = 5;
%%
X = U_true*U_true';
U0 = rand(n,r); V0 = rand(n,r);
maxiter = 1e3; 
lambda = 1;
%%
[H,P,losses, losses_pure, time, H_list] = matrixFac_col(X, maxiter, U0, lambda, 1e-15);
%%
% --------pivoting ANLS----------
[Up,Vp,ep,tp,diffp] = PivotANLS(X,U0,V0,maxiter,lambda);
norm(Up-Vp,'fro')


%-----Lu ADMM------
rho = 10;
[Xa, ea,ta] = NS_ADMM(X, maxiter, U0,V0,rho);


%------NEWTON like-------
params.maxiter = 2*maxiter; params.Hinit = U0;
[Un, en,tn] = symnmf_newton(X, r, params);

%------PGD-----
[Ug,eg,tg] = PGD(X,U0,10*maxiter);
%%
figure(1)
semilogy(tp,ep,'r-.','LineWidth',1.5);hold on
semilogy(time,losses_pure,'m','LineWidth',1.5);
semilogy(ta,ea,'k--','LineWidth',1.5);
semilogy(tn,en,'b-','LineWidth',1.5);
semilogy(tg,eg,'g-.','LineWidth',1.5);
% set(gcf,'Position',[100 300 650 300]);
set(gca, 'LineWidth' , 1.5,'FontSize',20);
xlim([0 1])
ylim([1e-15 1])
xlabel('Time(s)','FontSize',20);
ylabel('$E^k$','FontSize',20,'Interpreter','LaTex');
legend('SymANLS','Ours','ADMM','SymNewton','PGD')