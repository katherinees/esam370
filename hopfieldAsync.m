function [v_i,d] = hopfieldAsync(v, M)
n = ceil(numel(v)*rand);
v_i = v;
v_i(n) = sign(M(n,:) * v + (10^-10)*(2*rand-1));
d = (v_i(n) ~= v(n));
end