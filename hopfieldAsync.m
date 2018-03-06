function v_i = hopfieldAsync(v, M)
n = ceil(numel(v)*rand);
v_i_n = M(n,:) * v;
v_i = v;
v_i(n) = sign(v_i_n + (10^-10)*(2*rand-1));

end