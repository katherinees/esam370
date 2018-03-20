function dist =  hw43c(N, k, p, pattern)

% make k patterns and associated M matrix
M = MBuilder(pattern);

distances = zeros(200,k);
for aa = 1:200
    for ii = 1:k
        
        tempPattern = pattern(:,ii);
        if p ~= 0 
            for jj = 1:N
                if rand < p
                    tempPattern(jj) = -1*tempPattern(jj);
                end
            end
        end
        
        
        for kk = 1:10*N
            tempPattern  = hopfieldAsync(tempPattern,M);
        end
        
        distances(aa,ii) = sum(tempPattern ~= pattern(:,ii));
        
    end
end

dist = mean(mean(distances));



end