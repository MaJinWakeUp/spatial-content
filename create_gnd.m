clear;
load('./data/gnd_handcraft_85.mat');
clear simscore;
clear list;
dataset='coco2017';
load(strcat('./data/list_',dataset));
num_im = numel(list);

%% create gnd according to simscore and qidx
% load(strcat('./data/simscore_',dataset));
% load(strcat('./data/qidx_',dataset));
% 
% j=1;
% for i = 1:numel(qidx)
%     cur_score = simscore(i,:);
%     [sorted,index] = sort(cur_score,'descend');
%     sorted = sorted(2:end);
%     index = index(2:end);
%     ok_range = find(sorted>0.3);
%     if length(ok_range)>10 && length(ok_range)<70
%         gnd(j).ok = index(ok_range);
%         qidx_new(j,1) = qidx(i);
%         simscore_new(j,:) = cur_score;
%         j=j+1;
%     end
% %     gnd(i).ok=index(ok_range);
%     
% end
% gnd=gnd(1:100);
% simscore=simscore_new(1:100,:);
% qidx = qidx_new(1:100);

%%
load('./data/simscore_coco2017.mat');
num_q = size(simscore,1);
del=[];

for i =1:num_q
    index = find(simscore(i,:)>0.3);
    index = index(index>5000);
    
    del=union(del,index);
end
all_index=1:numel(list);
remain=setdiff(all_index,del);

list=list(remain);
simscore = simscore(:,remain);
save(strcat('./data/gnd_',dataset),'gnd','list','simscore','qidx')