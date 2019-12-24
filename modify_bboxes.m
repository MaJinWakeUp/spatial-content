% fid = fopen('./data/myexper/coco.names','r');
% i=1;
% while feof(fid)==0
%     coco_names{i,1}=fgetl(fid);
%     i=i+1;
% end
% fclose(fid);
% save('coco_names.mat','coco_names')

clear;
load './data/list_vg.mat';
load './data/coco_names.mat';
dir_box = './data/yolo_boxes/vg_box_ori/';
out_box = './data/yolo_boxes/vg_box/';
num_im=numel(list);
tic
for id = 1:num_im
    if mod(id,5000)==0 
        fprintf('processing %i-th images...\n',id);
        toc
    end
    load(strcat(dir_box,list{id},'.mat'));
    bboxes = boxes;
    bboxes(bboxes<0)=0;
    bboxes(bboxes>1)=1;
    clear boxes;
    
    num_boxes = size(bboxes,1);
    if num_boxes == 0
        labels = [];
    else
        labels = zeros(num_boxes,1);
    
        fid = fopen(strcat(dir_box,list{id},'.txt'),'r');
        i=1;
        while feof(fid)==0
            label_name = fgetl(fid);
            labels(i,1)=find(strcmp(label_name,coco_names)==1);
            i=i+1;    
        end
        fclose(fid);
    end
   
    save(strcat(out_box,list{id},'.mat'),'bboxes','labels')
    clear bboxes;
    clear labels;
end