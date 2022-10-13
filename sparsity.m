function T = sparsity(H)       
        T = zeros(size(H));
        for idx = 1:size(H,1)
%             [maxVal, maxIdx] = max(abs(H(idx,:)));
%             if H(idx, maxIdx) < 0 
%                 T(idx, maxIdx) = -maxVal;
%             else 
%                 T(idx, maxIdx) = maxVal;
%             end
            [maxVal, maxIdx] = max(H(idx,:));
            T(idx, maxIdx) = maxVal;
        end
      