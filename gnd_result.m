% gnd results
clear;
close all;
% load 'coco_names.mat';
addpath('./utils')
addpath('../yael/matlab')

dataset='val2017';

% load(strcat('./data/gnd_',dataset,'_handcraft.mat'));
load(strcat('./data/qidx_',dataset,'.mat'));
% load(strcat('./data/simscore_',dataset,'.mat'));
load(strcat('./data/list_',dataset,'.mat'));

% [sim_sorted,ranks]=sort(simscore,2,'descend');
% ranks=ranks';

% chosen_qidx=[];
% for i=1:500
%     if length(find(sim_sorted(i,:)>0.3))<200
%         chosen_qidx=[chosen_qidx,i];
%     end
% end
%% result present
impath = ['./images/',dataset,'/'];
% ind_q = randi(500,[5,1]);
ind_q = 1:50;
% ind_q = chosen_qidx(ind_q);
% num_qq=length(ind_q);
num_ranks = 10;
ha = tight_subplot(length(ind_q)/10,num_ranks,[.01 .01],[.01 .01],[.01 .01]);
line_w = 2.5;
for j = 1:length(ind_q)
    im_name = strcat(impath,list(qidx(ind_q(j))),'.jpg');
    im = imread(im_name{1});
%     axes(ha((j-1)*num_ranks+1));
    axes(ha(j))
    image(im)
%     rectangle('Position',[line_w,line_w,size(im,2)-line_w,size(im,1)-line_w],'LineWidth',line_w,'EdgeColor','b');
    axis off

%     axes(ha((j*2-1)*11+1));
%     image(im)
%     rectangle('Position',tran_axis(gnd(query_number(j)).bbx),'LineWidth',1,'EdgeColor','b');
%     axis off


%     for i=1:num_ranks-1
%         xxx=gnd(ind_q(j)).ok;
%         im_name = strcat(impath,list(xxx(i)),'.jpg');
%         im_ = imread(im_name{1});
%         axes(ha((j-1)*num_ranks+1+i));
%         image(im_)
% %         if ~ismember(ranks(i+1,ind_q(j)),gnd(ind_q(j)).ok)
% %             rectangle('Position',[line_w,line_w,size(im_,2)-line_w,size(im_,1)-line_w],'LineWidth',line_w,'EdgeColor','g');
% %         end
%         axis off
%     end
end