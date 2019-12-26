% test our spatial-content image search algorithm
clear;
close all;
addpath('./utils')
% addpath('../yael/matlab')

dataset='val2017';

if strcmp(dataset,'vg')
    load(strcat('./data/gnd_',dataset,'_nojunk'));
else 
    load(strcat('./data/gnd_',dataset));
end

load(strcat('./data/processed/',dataset));

%% spatial content similarity
num_im = numel(list);
num_q = numel(qidx);
sim=zeros(num_im,num_q);

tic
penal = 1;
alpha = 0.2;
for iq = 1:num_q
    if mod(iq,20)==0
        fprintf('processing %i-th query...\n',iq);
        toc
    end

    q_data=all_data{qidx(iq)};
    
    parfor im = 1:num_im
        im_data=all_data{im};
        sim(im,iq) = spaconsim(q_data,im_data,alpha,penal);
    end

end
[sim,ranks]=sort(sim,1,'descend');

%% compute metrics for different values of R
RA = [5,10,20,40,60,80,100,120,140,160,180,200];
NDCG_=zeros(1,length(RA));
spearman_=zeros(1,length(RA));
pearson_=zeros(1,length(RA));
map_=zeros(1,length(RA));
for i = 1:length(RA)
    R = RA(i);   
    ranks_ = ranks(2:R+1,:);
    sim_=sim(2:R+1,:);
    NDCG = compute_NDCG(ranks_,simscore);
    Spearman = compute_spearman(ranks,simscore);
    [map,aps] = compute_map (ranks_, gnd);
    
    NDCG_(i)=mean(NDCG);
    spearman_(i)=mean(Spearman);
    map_(i)=map;
    fprintf('R=%i, mean NDCG=%.4f, Spearman=%.4f, map=%.4f\n',R,mean(NDCG),mean(Spearman),map);
end
save(strcat(dataset,'_',num2str(alpha),'.mat'),'NDCG_','spearman_','map_')

%% result present
% impath = ['./images/',dataset,'/'];
% ind_q =15;
% num_qq=5;
% num_ranks = 11;
% ha = tight_subplot(num_qq,num_ranks,[.01 .01],[.01 .01],[.01 .01]);
% line_w = 2.5;
% for j = 1:num_qq
%     im_name = strcat(impath,list(qidx(ind_q)),'.jpg');
%     im = imread(im_name{1});
%     axes(ha((j-1)*num_ranks+1));
%     image(im)
%     rectangle('Position',[line_w,line_w,size(im,2)-line_w,size(im,1)-line_w],'LineWidth',line_w,'EdgeColor','b');
%     axis off
% 
%     for i=1:num_ranks-1
%         im_name = strcat(impath,list(ranks(150+i+(j-1)*(num_ranks-1),ind_q)),'.jpg');
%         im_ = imread(im_name{1});
%         axes(ha((j-1)*num_ranks+1+i));
%         image(im_)
% %         if ~ismember(ranks(i+1,ind_q(j)),gnd(ind_q(j)).ok)
% %             rectangle('Position',[line_w,line_w,size(im_,2)-line_w,size(im_,1)-line_w],'LineWidth',line_w,'EdgeColor','g');
% %         end
%         axis off
%     end
% end