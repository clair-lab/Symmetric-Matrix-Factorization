function [H,losses] = matrixFac_pos_norm(X, itr, H)
    losses=zeros(itr,1);
    for t=1:itr
        losses(t)=norm(X-H*H','fro')^2;
        step=1/(norm(X-H*H')+2*norm(H'*H));
        H=max(H-step*(H*H'*H-X*H),0);
        H(isnan(H))=0;
        T = normalize_norm(H);
        T(isnan(T))=0;
        H = T;
    end