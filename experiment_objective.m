close all;clear all;
randn('seed',201);rand('seed',201)
load('cifar.mat');
gnd = labels;
data = im2double(data(1501:3000,:));
gnd = im2double(labels(1501:3000,:));
nClass = length(unique(gnd));
data = normalize_mean_norm(data);
%%
% k = 10;
% [subset, subset_gnd] = random_subset(data, gnd, k);
% fea = subset;
% gnd = subset_gnd;
% data = normalize_mean_norm(subset);
%%
%initilize the matrix H
itr=20;
k = nClass;
data_size=size(data,1);
H_n = randn(data_size,k);
H_p = max(H_n,0);
H_s=sparsity(H_n);
H=H_n;

%calculate the symmetric similarity matrix X and X_reg with regularization
lambda = 0.5;
X=similarity_matrix_dot(data);
D = diag(sum(X));
L=diag(sum(X))-X;
X_reg=X-lambda*L;

[H_neg,losses_neg] = matrixFac(X_reg, itr, H_n);
our_neg = litekmeans(H_neg,k,'Replicates',20);
figure
plot(losses_neg,'k','LineWidth',2.5,'MarkerSize',20);
grid on;
hold on;
set(gca,'FontSize',20)
xlabel('#iterations', 'fontsize',20) 
ylabel('Objective function value', 'fontsize',20) 


[H_pos,losses_pos] = matrixFac_pos(X_reg, itr, H_p);
our_pos = litekmeans(H_pos,k,'Replicates',20);
figure
plot(losses_pos,'k','LineWidth',2.5,'MarkerSize',20);
hold on;
grid on;
set(gca,'FontSize',20)
xlabel('#iterations', 'fontsize',20) 
ylabel('Objective function value', 'fontsize',20) 