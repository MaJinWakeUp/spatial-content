% function
function score = spaconsim(q_data,im_data,alpha,penal)
% 
num_qb = numel(q_data);
% num_imb = numel(im_data);

if q_data(1).label==0 || im_data(1).label==0
    vecs_q = [q_data.feature];
    vecs_im = [im_data.feature];
    if size(vecs_q,2)==1
        score=max(vecs_q'*vecs_im)/(num_qb+penal);
    else
        score=max(vecs_im'*vecs_q)/(num_qb+penal);
    end
%     score = yael_vecs_normalize(sum(vecs_q,2),2,0)'*yael_vecs_normalize(sum(vecs_im,2),2,0)/(num_qb+penal);
else
    score = 0;
    
    im_label = [im_data.label];
    for ib = 1:num_qb
        cur_ql = q_data(ib).label;
        cur_qb = q_data(ib).box;
        ind = find(im_label==cur_ql);
        
        cur_qvec = q_data(ib).feature;

        if ~isempty(ind)
            num_ind = numel(ind);
            spasim_score = zeros(num_ind,1);
            content_score = zeros(num_ind,1);
            for iind = 1:num_ind
                cur_imb = im_data(ind(iind)).box;
                cur_imvec = im_data(ind(iind)).feature;
                
%             content_score(iind) = cur_qvec'*cur_imvec;
                
                if cur_imb(1)+cur_imb(3)<cur_qb(1) || cur_imb(2)+cur_imb(4)<cur_qb(2) ...
                        || cur_imb(1)>cur_qb(1)+cur_qb(3) || cur_imb(2)>cur_qb(2)+cur_qb(4)
                    spasim_score(iind) = 0;            
                else
                    minusv = ( min(cur_imb(1)+cur_imb(3),cur_qb(1)+cur_qb(3)) - max(cur_imb(1),cur_qb(1)) ) ...
                        * ( min(cur_imb(2)+cur_imb(4),cur_qb(2)+cur_qb(4)) - max(cur_imb(2),cur_qb(2)) );
                    plusv = cur_imb(3)*cur_imb(4) + cur_qb(3)*cur_qb(4)-minusv;
                    spasim_score(iind) = minusv/plusv;
                end
                content_score(iind) = cur_qvec'*cur_imvec;
            end
            final_score = (1-alpha)*content_score + alpha*spasim_score;
            cur_score = max(final_score);
            score = score + cur_score;
        end
    end
    score = score / num_qb;

end
end

