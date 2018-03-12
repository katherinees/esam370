function hw43c(N, k, p)

pattern = zeros(N, k);
M = zeros(N, N, k);

% make k patterns and associated M matrices
for i = 1:k
    pattern(:, i) = sign(2*rand(N,1)-1);
    M(:,:,i) = (1/N)*pattern(:,i)*pattern(:,i)';
end

for i = 1:k
    if rand > p
        pattern(:,i) = -1*pattern(:,i);
    end
end

infty = 20*N;
for j = 1:infty
    for i = 1:k
        [v_i, d] = hopfieldAsync(pattern(:,i), M(:, :, i));
        
    end
end


end