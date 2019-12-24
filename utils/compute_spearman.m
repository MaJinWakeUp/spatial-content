% compute Spearman correlation
function spearman = compute_spearman(rank,simscore)
[R,num] = size(rank);
spearman = zeros(1,num);
ranks_index1 = 1:R;

for i = 1:num
    imgs = rank(:,i);
    cur_score = simscore(i,:)';
    [~,ind] = sort(cur_score(imgs),'descend');
    [~,ranks_index2] = sort(ind,'ascend');
%     for j = 1: R
%         ranks_index2(j) = find(ind==imgs(j));
%     end
    
    dR = ranks_index2 - ranks_index1';
    
    spearman(i) = 1 - (6*sum(dR.*dR))/(R*(R^2-1));
end

end