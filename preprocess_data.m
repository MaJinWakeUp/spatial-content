% preprocess data
clear;
close all;
dataset='coco2017';
addpath('../yael/matlab')

load(strcat('./data/list_',dataset));

if strcmp(dataset,'vg')
    dir_box = strcat('./data/yolo_boxes/vg_box/');
    dir_feature = strcat('./data/googlenet_vg/');
    dir_output = strcat('./data/processed/vg/');
else   
    dir_box = strcat('./data/yolo_boxes/coco2017_box/');
    dir_feature = strcat('./data/googlenet_coco2017/');
    dir_output = strcat('./data/processed/coco2017/');
end

% % pca part1
% switch dataset
%     case {'val2017','coco2017'}
%         load('coco_PCA.mat')
%     case 'vg'
%         load('vg_PCA.mat')
% end
% dim=1024;

num_im = numel(list);
tic
for i=1:num_im
    if mod(i,3000)==0 
        fprintf('processing %i-th images...\n',i);
        toc
    end
    load(strcat(dir_box,list{i},'.mat'));
    load(strcat(dir_feature,list{i},'.mat'));

    data=reshape(data,1024,[]);
    
    num_boxes = numel(labels);
    if num_boxes>0
        for j=1:num_boxes
            data_(j).box = bboxes(j,:);
            data_(j).label = labels(j);
        
            cur_index = trans_ind(bboxes(j,:));
%             cur_feature = data(:,cur_index);
            cur_feature = yael_vecs_normalize(data(:,cur_index),2,0);
            cur_feature = sum(cur_feature,2);
            cur_feature = postprocess(cur_feature);
%             % pca part2
%             cur_feature = apply_whiten (cur_feature, pca_data.Xm, pca_data.eigvec, pca_data.eigval, dim);
%             cur_feature = yael_vecs_normalize(cur_feature,2,0);
            data_(j).feature = cur_feature;
            
        end
    else
        data_(1).box=[];
        data_(1).label=0;
%         cur_feature = data;
        cur_feature = yael_vecs_normalize(data,2,0);
        cur_feature= sum(cur_feature,2);
        data_(1).feature= postprocess(cur_feature);
    end        

    save(strcat(dir_output,list{i}),'data_');
    clear data_;
end

if strcmp(dataset,'vg')
    dir_everyone = strcat('./data/processed/vg/');
else   
    dir_everyone = strcat('./data/processed/coco2017/');
end

num_im = numel(list);

all_data = cell(num_im,1);
for j=1:num_im
    load(strcat(dir_everyone,list{j},'.mat'));
    all_data{j}=data_;
    clear data_;
end

save(strcat('./data/processed/',dataset),'all_data','-v7.3');