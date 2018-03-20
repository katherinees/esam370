% This script runs code for HW5 Problem 2(b). Type the "esam370_hw5p2b" 
% into the command window or another script to run to run.

% These variables you can delete from the script, because they probably
% should have been defined in 2(a).
clear
clc
tmax = 2000;
nspikestot = 500;
dt = 0.01;
time = 0:0.01:tmax;
G_exe = 20;
G_inh = 9.1;

% Input variables:
spike_train = sort(tmax*rand(nspikestot,1)); % define the spike train to be a vector 
% of all simulated neuron spike times. This is dumy data.
delta_t = spike_train(2:end) - spike_train(1:end-1);% inter-spike intervals. general formulation

m_exe = sin(1/100*time); % m_exe as a function of time. dummy data
m_inh = sin(1/100*time+2); % m_inh as a function of time. also dummy data

T = 20; % time interval for binning spikes

% % % 
% % % %n_binnedspikes = NaN(ceil(tmax/T),1); % tally spikes in partitioned time intervals of 20ms
% % % % t_bins = 0:T:tmax-T;


 n_binnedspikes = NaN(numel(time)-T/dt,1); % alternatively, to increase sample
% size, you can tally in overlapping bins.
t_bins = 0:dt:tmax-T;

for ii = 1:numel(n_binnedspikes)
    % tally spikes in bins
% % %     %n_binnedspikes(ii) = sum(spike_train >= (ii-1)*T & spike_train < ii*T);
     n_binnedspikes(ii) = sum(spike_train >= (ii-1)*dt & spike_train < ii*dt+T);
    % this is for the alternative I talked about.
end

% Plot firing rate vs inputs
figure()
subplot(3,1,1)
plot(t_bins,n_binnedspikes,'-o')
ylabel('Neuron Spikes in Interval')
xlabel('Time (ms)')
title(['G_{exe} = ',num2str(G_exe),'; G_{inh} = ',num2str(G_inh)])
legend(['Number of Spikes in a ',num2str(T),'ms Interval'],'Location','Northeast')

subplot(3,1,2)
plot(time,m_exe,time,m_inh)
ylabel('m_{exe},m_{inh}')
xlabel('Time (ms)')
legend('Excitory Input Rate','Inhibitory Input Rate','Location','Northeast')

subplot(3,1,3)
%   UNCOMMENT TO PLOT VOLATGE TRACES
% plot(time,V)
% ylabel('Potential (mV)')
% xlabel('Time (ms)')

% Plot histogram of n_binnedspikes and fitted Poisson curve
maxx = ceil(1.2*max(n_binnedspikes));
x = 0:maxx;
figure()
hbins=max(n_binnedspikes);
[n,bin]=hist(n_binnedspikes,hbins);
m=n/trapz(bin,n);
bar(bin,m/(hbins/numel(x)),'w');
hold on
pd=fitdist(n_binnedspikes,'poisson');
y=pdf(pd,x);
plot(x,y,'ro-');
hold off;
xlabel(['Number of Spikes in a ',num2str(T),'ms Interval'])
ylabel('Frequency')
title(['G_{exe} = ',num2str(G_exe),'; G_{inh} = ',num2str(G_inh)])
legend('Sample','Fitted','Location','Northeast')

% Compare Poisson parameters
fprintf('######################################################\n')
disp(pd)
mu = mean(n_binnedspikes);
sigma2 = var(n_binnedspikes);
fano = mu/sigma2;
fprintf('Mean of Binned N          %.2f\n',mu)
fprintf('Variance of Binned N:     %.2f\n',sigma2)
fprintf('Fano Factor:              %.2f\n\n',fano)

% plot histogram of inter-spike intervals and fitted exponential curve
figure()
hbins = 20;
[n,bin]=hist(delta_t,hbins);
m=n/trapz(bin,n);
bar(bin,m,'w');
hold on
pd=fitdist(delta_t,'exp');
y=pdf(pd,bin);
plot(bin,y,'r');
hold off;
xlabel('Inter-Spike Interval')
ylabel('Frequency')
title(['G_{exe} = ',num2str(G_exe),'; G_{inh} = ',num2str(G_inh)])
legend('Sample','Fitted','Location','Northeast')

fprintf('######################################################\n')
disp(pd)

% compare exponential and Poisson fit
lambda_exp = 1/pd.mu;
fprintf('Rate Estimate from Poisson Fit:         %.6f\n',mu/T)
fprintf('Rate Estimate from Exponential Fit:     %.6f\n',lambda_exp)
fprintf('Difference:                             %.6f\n\n',abs(lambda_exp-mu/T))


