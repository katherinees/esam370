function output = int_fire(tau1)

tstep = 0.0005;
tmax = 100;
time = 0:tstep:tmax;
tlength = length(time);
Ie = 320;
vthresh = 30;
G = 5;
Esyn = 50;
dPs = 0.1;
vreset = -55;
% tau1 = 0.2;
tau2 = tau1/2;
N = 1/((tau2/tau1)^(tau2/(tau1-tau2))-(tau2/tau1)^(tau1/(tau1-tau2)));

vp1 = zeros(tlength, 1);
vp2 = zeros(tlength, 1);
vp = [vp1, vp2];

v1 = zeros(tlength, 1);
v1(1) = -10;
v2 = zeros(tlength, 1);
v2(1) = -50;
v = [v1, v2];

A1 = zeros(tlength, 1);
A1p = zeros(tlength, 1);
B1 = zeros(tlength, 1);
B1p = zeros(tlength, 1);
A2 = zeros(tlength, 1);
A2p = zeros(tlength, 1);
B2 = zeros(tlength, 1);
B2p = zeros(tlength, 1);
Ps1 = zeros(tlength, 1);
Ps2 = zeros(tlength, 1);
tspike1 = [];
tspike2 = [];

for i = 1:tlength-1
    vp(i, 1) = -10*v(i, 1) + Ie - G*Ps2(i)*(v(i,1)-Esyn);
    v(i+1, 1) = v(i, 1) + tstep*vp(i,1);
    A1p(i) = -1*A1(i)/tau1;
    A1(i+1) = A1(i) + tstep*A1p(i);
    B1p(i) = -1*B1(i)/tau2;
    B1(i+1) = B1(i) + tstep*B1p(i);
    Ps1(i+1) = N*(A1(i+1) - B1(i+1));
    if (v(i, 1) < vthresh && v(i+1, 1) > vthresh)
        v(i+1, 1) = vreset;
        % fprintf('V1 spike at %d\n', time(i))
        tspike1 = [tspike1; time(i)];
        % if spike, synaptic variables get updated
        A1(i+1) = A1(i)+dPs*(1-Ps1(i));
        B1(i+1) = B1(i)+dPs*(1-Ps1(i));
    end
    vp(i, 2) = -10*v(i, 2) + Ie - G*Ps1(i)*(v(i,2)-Esyn);
    v(i+1, 2) = v(i, 2) + tstep*vp(i,2);
    if (v(i, 2) < vthresh && v(i+1, 2) > vthresh)
        v(i+1, 2) = vreset;
        % fprintf('V2 spike at %d\n', time(i))
        tspike2 = [tspike2; time(i)];
        A2(i+1) = A2(i)+dPs*(1-Ps2(i));
        B2(i+1) = B2(i)+dPs*(1-Ps2(i));
    end
    
end

minlength = min(length(tspike1), length(tspike2));
dPhi = zeros(minlength, 1);
diff = zeros(minlength, 1);
for i = 1:length(dPhi)-1
    dPhi(i) = (tspike1(i+1) - tspike2(i+1))/(tspike1(i+1)-tspike2(i));
    diff(i) = tspike1(i+1)-tspike2(i+1);
end
%plot(time, v(:,1))

output = [tspike1(1:minlength-1,:) dPhi(1:end-1,:) diff(1:end-1,:)];
end
% plot(tspike1, dPhi)