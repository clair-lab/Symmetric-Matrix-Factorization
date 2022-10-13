%subtract mean in each dimension, normalize the dataset to unit norm

function b = normalize_mean_norm(data)
    [n dim]=size(data);
    data_mean = data-mean(data);
    for i=1:n
        data_mean(i,:)=data_mean(i,:)/norm(data_mean(i,:));
    end
    b = data_mean;