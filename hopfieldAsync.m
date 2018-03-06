function v_i = hopfieldAsync(v, M, n)

v_i_n = M(n,:) * v;

v_i = v;
v_i(n) = v_i_n;

end