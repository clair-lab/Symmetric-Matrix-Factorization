function [U,V,e,t,diff,acc] = PivotANLS(X,U,V,maxiter,lambda,truelabel);

if size(V,1)<size(V,2)
    V = V';
end

[n,r] = size(V);

% Initialization
etime = tic; 
e = []; t = []; diff=[]; iter = 0; 

%initial error
e = [e 0.5*norm(X-U*V','fro')^2/norm(X,'fro')^2]; 
diff = [diff norm(U-V,'fro')^2]; 
t = [t 0];

if nargin >= 6
    [~,label] = max(V, [], 2);
    tempacc = ClusteringMeasure(truelabel, label);
    acc(1) = tempacc(1);
end

% % Scaling, p. 72 of the thesis
% A = X*V; B = V'*V; 
% scaling = sum(sum(A.*U))/sum(sum( B.*(U'*U) )); U = U*scaling; 
% Main loop
while iter <= maxiter 
    % Update of U
    UT = nnlsm_blockpivot( [V;sqrt(lambda)*eye(r)], [X';sqrt(lambda)*V'], 0, U' );
    U = UT';
    % Update of V
    VT = nnlsm_blockpivot( [U;sqrt(lambda)*eye(r)],[X;sqrt(lambda)*U'], 0, V' );
    V = VT';
    % Evaluation of the error e at time t
    if nargout >= 3
        e = [e 0.5*norm(X-U*V','fro')^2/norm(X,'fro')^2];
        diff = [diff norm(U-V,'fro')^2]; 
        t = [t toc(etime)];
        if nargin >= 6
            [~,label] = max(V, [], 2);
            tempacc = ClusteringMeasure(truelabel, label);
            acc(iter+2) = tempacc(1);
        end
    end
    iter = iter + 1; 
    
%     %checking optimality(FOR PHASE TRASITION ONLY)
%     E_U = max(U - (U*V'-X)*V + lambda*(U-V), 0) - U;
%     E_V = max(V - (U*V'-X)'*U + lambda*(V-U), 0) - V;
%     if norm([E_U;E_V],'fro')< 1e-8
%         disp('get optimality');
%         break;
%     end
end




