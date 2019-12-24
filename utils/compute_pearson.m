% compute pearson
function pearson = compute_pearson(rank,sim,simscore)
[R,num] = size(rank);
pearson = zeros(1,num);

for i = 1:num
    X = sim(:,i);
    
    imgs = rank(:,i);
    cur_score = simscore(i,:)';
    Y = cur_score(imgs);

    pearson(i) = (X'*Y*R - sum(X)*sum(Y)) / (sqrt(R*sum(X.^2)-sum(X)^2) * sqrt(R*(sum(Y.^2))-sum(Y)^2));
end
pearson=abs(pearson);
end