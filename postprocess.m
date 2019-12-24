% post process
function output = postprocess(input)
output = sign(input) .* abs(input) .^ 1.0;
output = yael_vecs_normalize(output,2,0);
end