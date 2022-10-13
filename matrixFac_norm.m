function [H,losses] = matrixFac_norm(X, itr, H)
    losses=zeros(itr,1);
    for t=1:itr
        losses(t)=norm(X-H*H','fro')^2;
        step=1/(norm(X-H*H')+2*norm(H'*H));
        H=H-step*(H*H'*H-X*H);
        T = normalize_norm(H);
        H = T;
    end