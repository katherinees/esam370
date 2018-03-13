%Generate random
v_pattern = sign(2*rand(100,1)-1);
%Create M
M = 1/100*v_pattern*v_pattern';

d = zeros(250,1);
v = v_pattern;
for ii = 1:250
    [v,d(ii)] = hopfieldAsync(v,M);
end
fprintf("Number of differences: %d \n",sum(d));
% If the number of differences is zero, then v_pattern is indeed a fixed
% point

% Next we flip five neurons
v = v_pattern;
flips = randi(100,5,1);

while numel(unique(flips))~=5 
    flips = randi(100,5,1);
end

v(flips) = -1*v(flips);
figure
subplot(1,2,1)
imagesc(reshape(v_pattern,[10,10]));
title('Memory');
hold on
time = 700;
d = zeros(time,1);
for ii = 1:time
    [v,d(ii)] = hopfieldAsync(v,M);
    temp = reshape(v,[10,10]);
    subplot(1,2,2)
    
    imagesc(temp)
    title('Final Hopfield Result')
    pause(.001)
end
fprintf('Number of differences: %d \n',sum(d));
figure
plot(1:time,d);
title('Number of differences vs. iteration');
xlabel('Iterations');
ylabel('Number of differences');
fprintf('Number of differences from v_pattern: %d \n', sum(abs(v_pattern~=v)));


