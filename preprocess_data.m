% generate image representation 
clear;
close all;
dataset='coco2017'; % three datasets: 'val2017', 'coco2017' and 'vg'
addpath('../yael/matlab')

load(strcat('./data/list_',dataset));

%% calculate and save every image's representation 
if strcmp(dataset,'vg')
    dir_box = strcat('./data/yolo_boxes/vg_box/'); % path/to/
    dir_feature = strcat('./data/googlenet_vg/');
    dir_output = strcat('./data/processed/vg/');
else   
    dir_box = strcat('./data/yolo_boxes/coco2017_box/');
    dir_feature = strcat('./data/googlenet_coco2017/');
    dir_output = strcat('./data/processed/coco2017/');
end

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
            % each object's bounding box
            data_(j).box = bboxes(j,:);
            % each object's label
            data_(j).label = labels(j);
        
            % each object's feature = 
            %        sum pooling of all features contained in bounding box
            cur_index = trans_ind(bboxes(j,:));
            cur_feature = yael_vecs_normalize(data(:,cur_index),2,0);
            cur_feature = sum(cur_feature,2);
            cur_feature = postprocess(cur_feature);
            data_(j).feature = cur_feature;
            
        end
    else
        data_(1).box=[];
        data_(1).label=0;
        cur_feature = yael_vecs_normalize(data,2,0);
        cur_feature= sum(cur_feature,2);
        data_(1).feature= postprocess(cur_feature);
    end   
    
    % save image representation of every image
    save(strcat(dir_output,list{i}),'data_');
    clear data_;
end

%% here we combine all images' representation into one file, make it easier for reading data 
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