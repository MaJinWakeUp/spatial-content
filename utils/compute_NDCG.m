% compute NDCG
% rank:         computed ranks (R*length(qidx))
% tfidf_score:  tfidf score, as standard score
% qidx:         index of query
function NDCG = compute_NDCG(rank,simscore)
[R,num] = size(rank);
NDCG = zeros(1,num);
aux = log2(1+(1:R))';

for i = 1:num
    cur_score = simscore(i,:)';
    CG = cur_score(rank(:,i));
    DCG = sum(CG./aux);

    sorted = sort(cur_score,'descend');
    ideal = sorted(2:R+1);
    iDCG = sum(ideal./aux);

    NDCG(i) = DCG/iDCG;
end
end