close all

taus = 0.02:0.05:0.4;

hold on
for i = 1:length(taus)
    output = int_fire(taus(i));
    tspike1 = output(:,1);
    dPhi = output(:,2);
    diff = output(:,3);
    plot(tspike1, diff); 
end
legend('0.02', '0.07', '0.12', '0.17', '0.22', '0.27', '0.32', '0.37')
xlabel('spike time of neuron 1')
ylabel('difference between time of kth spike of neuron 1 and 2')
hold off
figure
part2 = zeros(1, length(taus));
hold on
for i = 1:length(taus)
    output = int_fire(taus(i));
    tspike1 = output(:,1);
    dPhi = output(:,2);
    plot(tspike1, dPhi);
    part2(i) = dPhi(end);
end
legend('0.02', '0.07', '0.12', '0.17', '0.22', '0.27', '0.32', '0.37')
xlabel('spike time of neuron 1')
ylabel('phase')
hold off

figure
plot(taus, part2, '-o')
xlabel('tau_1')
ylabel('steady state phase')
