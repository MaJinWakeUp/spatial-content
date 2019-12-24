% create PCA matrix
clear;
close all;

dataset_train = 'coco';
dataset_test = 'vg';

addpath('./utils')
addpath('../yael/matlab')
switch dataset_test
    case 'coco'
        load('./data/processed/vg.mat')
    case 'vg'
        load('./data/processed/coco2017.mat')
end

num_im=numel(all_data);
index = randi(num_im,[2000,1]);

vecs_train = [];
for i=1:2000
    cur_data = all_data{index(i)};
    cur_vecs = zeros(1024,numel(cur_data));
    for j=1:numel(cur_data)
        cur_vecs(:,j) = cur_data(j).feature;
    end
    vecs_train=[vecs_train,cur_vecs];
    clear cur_data
end
clear all_data;
fprintf('Learning PCA...\n')
vecs_train = postprocess(vecs_train);
[~, eigvec, eigval, Xm] = yael_pca (vecs_train);
pca_data.eigvec=eigvec;
pca_data.eigval=eigval;
pca_data.Xm=Xm;
fprintf('end...\n')
save(strcat(dataset_test,'_PCA.mat'),'pca_data')