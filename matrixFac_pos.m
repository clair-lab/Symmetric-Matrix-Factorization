function [H,losses, time] = matrixFac_pos(X, itr, H)
    losses=[];
    time = [];
    etime = tic; 
    losses = [losses 0.5*norm(X-H*H','fro')^2/norm(X,'fro')^2];
    time = [time 0];
    for t=1:itr
        losses(t)=0.5*norm(X-H*H','fro')^2/norm(X,'fro')^2;
        step=1/(norm(X-H*H')+2*norm(H'*H));
        H=max(H-step*(H*H'*H-X*H),0);
        
        losses = [losses 0.5*norm(X-H*H','fro')^2/norm(X,'fro')^2];
        time = [time toc(etime)];
    end
    
    