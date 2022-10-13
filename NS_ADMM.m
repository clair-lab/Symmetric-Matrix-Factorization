function [X, e,t,acc] = NS_ADMM (A, maxIter, X0,Y0, rho,truelabel)
etime = tic;  e = []; t = [];
if nargin >= 6
    [~,label] = max(Y0, [], 2);
    tempacc = ClusteringMeasure(truelabel, label);
    acc(1) = tempacc(1);
end

[N K] = size(X0);
Z = ones(N,K);
X = X0;
Y = Y0;
e = [e 0.5*norm(A-X*Y','fro')^2/norm(A,'fro')^2]; t = [t 0];
for i=1:maxIter
    Y = updatey(A,X,Z,rho,Y,K);
    X = updatex(A,Y,Z,rho,K);
    Z = Z + rho*(Y-X);
    e = [e 0.5*norm(A-X*Y','fro')^2/norm(A,'fro')^2];
    t = [t toc(etime)];
    
    if nargin >= 6
        [~,label] = max(Y, [], 2);
        tempacc = ClusteringMeasure(truelabel, label);
        acc(i+1) = tempacc(1);
    end
end
norm(X-Y,'fro')/norm(Y,'fro')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  X-update
function aX = updatex(A,aY,aZ,rho,K)
ZX = A*aY + rho*aY + aZ;
AX = aY'*aY + rho*eye(K,K);
aX = ZX/AX;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Y-update
function aY = updatey(A,aY,aZ,rho,aX,K)
beta=6.1/rho*norm(aX*aY'-A,'fro')^2;
%beta=0;
newZ = aX'*A + (rho*aX-aZ)' + beta*aY';
newY = aX'*aX + (rho+beta)*eye(K,K);
newY_corr = chol(newY);
uY = nnlsm_blockpivot(newY_corr,newY_corr'\newZ,0,aX');
aY=uY';




