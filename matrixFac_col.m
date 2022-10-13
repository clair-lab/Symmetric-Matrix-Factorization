function [H,P,losses, losses_pure, time, H_list] = matrixFac_col(X, itr, H, lambda, tol)
    losses=zeros(itr,1);
    losses_pure = zeros(itr,1);
    H_list = cell(itr, 1);
    etime = tic; 
    time = zeros(itr,1);
    M = X;
    P = H;
    [~,k] = size(H);
    func_def = @(a,b) a*b';
    time(1) = 0;
    losses(1) = 0.5*(norm(X-H*P','fro')^2 + lambda*norm(H-P, 'fro')^2)/norm(X,'fro')^2;
    losses_pure(1) = 0.5*(norm(X-H*P','fro')^2)/norm(X,'fro')^2;
    for t=1:itr 
        for i = 1:k
            C = bsxfun(func_def, H, P);
            M_bar = M - (C - H(:,i)*P(:,i)');
            H(:,i) = ((M_bar + lambda*eye(size(M_bar)))*P(:,i))/(norm(P(:,i))^2+lambda);
            P(:,i) = ((M_bar + lambda*eye(size(M_bar)))*H(:,i))/(norm(H(:,i))^2+lambda);
        end
        losses(t+1) = 0.5*(norm(X-H*P','fro')^2 + lambda*norm(H-P, 'fro')^2)/norm(X,'fro')^2;
        losses_pure(t+1) = 0.5*(norm(X-H*P','fro')^2)/norm(X,'fro')^2;
        time(t+1) = toc(etime);
        H_list{t} = H;
        if t > 1
            if losses_pure(t-1) - losses_pure(t) < tol
                break
            end
        end
    end
    
 
   