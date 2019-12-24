% tf-idf score calculation
clear;
addpath('/home/mj/dataset/coco/cocoapi/MatlabAPI');
%% initialize COCO api (please specify dataType/annType below)
annType = 'captions';
dataType='val2017';  % specify dataType/annType
annFile=sprintf('/home/mj/dataset/coco/annotations/%s_%s.json',annType,dataType);
coco=CocoApi(annFile);

fid = fopen('./baseline/captions_coco2017.txt','wt');
load('./data/list_val2017.mat')
list_val=list;
clear list;
for id = 1:numel(list_val)
    imgId = str2double(list_val{id});
    annIds = coco.getAnnIds('imgIds',imgId,'iscrowd',[]);
    anns = coco.loadAnns(annIds); 
    
    curstr = [];
    ann_num = numel(anns);
    for ida = 1:ann_num
        annstr = strtrim(anns(ida).caption);
        annstr = lower(annstr);
        curstr = strcat(curstr,32,annstr);
    end
    index = strfind(curstr,char(10));
    if ~isempty(index)
        curstr(index) = ' ';
    end
    fprintf(fid,'%s\n',strtrim(curstr));
end

clear coco
dataType='train2017';  % specify dataType/annType
annFile=sprintf('/home/mj/dataset/coco/annotations/%s_%s.json',annType,dataType);
coco=CocoApi(annFile);


load('./data/list_train2017.mat');
imnum = numel(list);
tic
for id = 1:imnum
    if mod(id,5000)==0
        fprintf('%i images in %.4f seconds\n',id,toc);
    end
    imgId = str2double(list{id});
    annIds = coco.getAnnIds('imgIds',imgId,'iscrowd',[]);
    anns = coco.loadAnns(annIds); 
    
    curstr = [];
    ann_num = numel(anns);
    for ida = 1:ann_num
        annstr = strtrim(anns(ida).caption);
        annstr = lower(annstr);
        curstr = strcat(curstr,32,annstr);
    end
    index = strfind(curstr,char(10));
    if ~isempty(index)
        curstr(index) = ' ';
    end
    fprintf(fid,'%s\n',strtrim(curstr));
end
fclose(fid);

list=[list_val;list];
save('./data/list_coco2017.mat','list')