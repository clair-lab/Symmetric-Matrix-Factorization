function [subset, subset_gnd] = random_subset(data, gnd, k)
    data_size = length(gnd);
    col = size(data,2);
    uG = unique(gnd);
    nclass = length(uG);
    startIdx = zeros(nclass,1);
    endIdx = zeros(nclass,1);
    tmp = 1;
    startIdx(1,1) = 1;
    for i = 1:data_size
        if gnd(i,1) ~= tmp
            endIdx(tmp,1) = i-1;
            tmp = tmp + 1;
            startIdx(tmp,1) = i;
        end
    end
    endIdx(tmp,1) = i;

    randIdx = randperm(nclass, k);

    subset_size = 0;
    for i = 1:k
        tmp = endIdx(randIdx(1,i),1) - startIdx(randIdx(1,i),1) + 1;
        subset_size = subset_size+tmp;
    end

    subset = zeros(subset_size, col); 
    subset_gnd = zeros(subset_size, 1); 
    s = 1;
    for i = 1:k
        k = endIdx(randIdx(1,i),1) - startIdx(randIdx(1,i),1);
        subset(s:s+k, :) = data(startIdx(randIdx(1,i),1):endIdx(randIdx(1,i),1), :);
        subset_gnd(s:s+k, :) = gnd(startIdx(randIdx(1,i),1):endIdx(randIdx(1,i),1), :);
        s = s+k+1;
    end
        
    