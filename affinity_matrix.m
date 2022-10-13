function A = affinity_matrix(data, sigma) 
    data_size=size(data,1);
    data = data';
    A=zeros(data_size,data_size);
    for i=1:data_size
        for j=1:data_size
            if i==j
                A(i,j) = 0;
            else
                n = norm(data(:,i) - data(:,j))^2;
                p = -n/(2*sigma*sigma);
                A(i,j)=exp(p);
            end
        end
    end