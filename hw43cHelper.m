N = 8;
k = 3;

N = [8,15];
k = [3,6,10];

figure

for nn = 1:numel(N)
   for kk = 1:numel(k)
        pattern = sign(2*rand(N(nn),k(kk))-1);
        probs = 0:.02:1;
        dist = zeros(1,numel(probs));

        for ii = 1:numel(probs)
            dist(ii) = hw43c(N(nn), k(kk),probs(ii), pattern);
        end
        subplot(numel(N),numel(k), (nn-1)*numel(k)+kk)
        plot(probs,dist);
        title(['N = ', num2str(N(nn)),' k = ', num2str(k(kk))]);
        
       
   end
end







