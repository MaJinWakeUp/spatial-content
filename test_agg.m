% test_agg_yolo
clear;
close all;
% load 'coco_names.mat';
addpath('./utils')
addpath('../yael/matlab')

dataset='val2017';

load(strcat('./data/gnd_',dataset,'.mat'));
% load(strcat('./data/qidx_',dataset,'.mat'));
% load('./data/gnd_handcraft_85.mat')
% load(strcat('./data/list_',dataset));
model = 'resnet';  % vgg,resnet,googlenet

% if strcmp(dataset,'vg')
%     dir_feature = strcat('./data/',model,'_vg/');
% else
%     dir_feature = strcat('./data/',model,'_coco2017/');
% end
% 
% num_im = numel(list);
% switch model
%     case 'resnet'
%         K = 2048;
%     case 'vgg'
%         K = 512;
%     case 'googlenet'
%         K = 1024;
%     case 'googlenet_4e'
%         K = 832;
% end
% 
% vecs = zeros(K,num_im);
% tic
% for id = 1:num_im
%     if mod(id,1000)==0
%         fprintf('%i images in %.4f seconds\n',id,toc);
%     end
%     load(strcat(dir_feature,list{id},'.mat'));
%     
%     data_ = permute(data,[2,3,1]);
%     data_ = max(data_,0);
%     vecs(:,id) = sum(sum(data_));
% %     vecs(:,id) = data;
% 
%     clear data;
%     clear data_;
% end
% vecs = yael_vecs_normalize(vecs,2,0);
% save(strcat('./data/agged/',model,'_',dataset),'vecs','-v7.3');

% % pca
% load('./data/agged/googlenet_vg.mat');
% vecs_train = postprocess(vecs);
% [~, eigvec, eigval, Xm] = yael_pca (vecs_train);
% clear vecs

load(strcat('./data/agged/',model,'_',dataset));
vecs = postprocess(vecs);

% % apply pca
% dim=1024;
% vecs = apply_whiten (vecs, Xm, eigvec, eigval, dim);
% vecs = yael_vecs_normalize(vecs,2,0);

qvecs = vecs(:,qidx);

vecs = single(vecs);
qvecs = single(qvecs);
[ranks,sim] = yael_nn(vecs, -qvecs, 250, 16);
% [ranks,sim] = my_nn(vecs, qvecs, numel(list), 1);
clear vecs;
clear qvecs;

%%
RA = [5,10,20,40,60,80,100,120,140,160,180,200];
NDCG_=zeros(1,length(RA));
spearman_=zeros(1,length(RA));
pearson_=zeros(1,length(RA));
map_=zeros(1,length(RA));
for i = 1:length(RA)
    R = RA(i);   
    ranks_ = ranks(2:R+1,:);
    sim_=-sim(2:R+1,:);
%     sim_ = sim(2:R+1,:);
    NDCG = compute_NDCG(ranks_,simscore);
    Spearman = compute_spearman(ranks,simscore);
%     Pearson = compute_pearson(ranks_,sim_,simscore);
    [map,aps] = compute_map (ranks_, gnd);
    
    NDCG_(i)=mean(NDCG);
    spearman_(i)=mean(Spearman);
%     pearson_(i)=mean(Pearson);
    map_(i)=map;
    fprintf('R=%i, mean NDCG=%.4f, Spearman=%.4f, map=%.4f\n',R,mean(NDCG),mean(Spearman),map);
end
save(strcat(dataset,'_agged_',model),'NDCG_','spearman_','map_')
%% result present
impath = ['./images/',dataset,'/'];
% ind_q = randi(75,[5,1]);
ind_q = [21,57];
num_qq=length(ind_q);
num_ranks = 11;
ha = tight_subplot(num_qq,num_ranks,[.01 .01],[.01 .01],[.01 .01]);
line_w = 2.5;
for j = 1:num_qq
    im_name = strcat(impath,list(qidx(ind_q(j))),'.jpg');
    im = imread(im_name{1});
    axes(ha((j-1)*num_ranks+1));
    image(im)
    rectangle('Position',[line_w,line_w,size(im,2)-line_w,size(im,1)-line_w],'LineWidth',line_w,'EdgeColor','b');
    axis off

%     axes(ha((j*2-1)*11+1));
%     image(im)
%     rectangle('Position',tran_axis(gnd(query_number(j)).bbx),'LineWidth',1,'EdgeColor','b');
%     axis off


    for i=1:num_ranks-1
        im_name = strcat(impath,list(ranks(i+1,ind_q(j))),'.jpg');
        im_ = imread(im_name{1});
        axes(ha((j-1)*num_ranks+1+i));
        image(im_)
        if ismember(ranks(i+1,ind_q(j)),gnd(ind_q(j)).ok)
            rectangle('Position',[line_w,line_w,size(im_,2)-line_w,size(im_,1)-line_w],'LineWidth',line_w,'EdgeColor','g');
        end
        axis off
    end
end