% my_nn
% calculate relevance of X and Q 
function [idx, dis] = my_nn (X, Q, k, distype)

if ~exist('k'), k = 1; end
if ~exist('distype'), distype = 1; end 
assert (size (X, 1) == size (Q, 1));

for i = 1:size(Q,2)
    sim(:,i) = sum(max(bsxfun(@minus,Q(:,i),X),0),1)';
end

if k == 1
   [dis, idx] = min (sim, [], 1);
else  
   [dis, idx] = sort (sim, 1);
   dis = dis (1:k, :);
   idx = idx (1:k, :);
end
end
