tstep = 0.01;
tmax = 200;
time = 0:tstep:tmax;
tlength = length(time);
% Ie = 320;
vthresh = 30;
G_exc = 20;
G_inh = 9.1;
Esyn_exc = 50;
Esyn_inh = -100;
dPs_exc = 0.1;
dPs_inh = 0.1;
vreset = -55;
tau1_exc = 0.5;
tau2_exc = 0.25;
tau1_inh = 1;
tau2_inh = 0.5;
Ntau_exc = 1/((tau2_exc/tau1_exc)^(tau2_exc/(tau1_exc-tau2_exc))-(tau2_exc/tau1_exc)^(tau1_exc/(tau1_exc-tau2_exc)));
Ntau_inh = 1/((tau2_inh/tau1_inh)^(tau2_inh/(tau1_inh-tau2_inh))-(tau2_inh/tau1_inh)^(tau1_inh/(tau1_inh-tau2_inh)));

a = 10;
c = -82.7;
Nexc = 2;
Ninh = 2;
rexc = 0.1;
rinh = 0.1;
d = 0;
b = 0;

v = zeros(tlength, 1);
v(1) = -0;
vp = zeros(tlength, 1);

% vp1 = zeros(tlength, 1);
% vp2 = zeros(tlength, 1);
% vp = [vp1, vp2];
% 
% v1 = zeros(tlength, 1);
% v1(1) = -10;
% v2 = zeros(tlength, 1);
% v2(1) = -50;
% v = [v1, v2];
m_exc = zeros(tlength, 1);
m_inh = zeros(tlength, 1);
Aexc = zeros(tlength, 1);
Aexc_p = zeros(tlength, 1);
Bexc = zeros(tlength, 1);
Bexc_p = zeros(tlength, 1);
Ainh = zeros(tlength, 1);
Ainh_p = zeros(tlength, 1);
Binh = zeros(tlength, 1);
Binh_p = zeros(tlength, 1);
Ps_exc = zeros(tlength, 1);
Ps_exc(1) = 0;
Ps_inh = zeros(tlength, 1);
Ps_inh(1) = 0;
tspike1 = [];
tspike2 = [];

Aexc(1) = 2;
Bexc(1) = 1.5;
Ainh(1) = 1;
Binh(1) = 0.5;


for i = 1:tlength-1
    m_exc(i) = binornd(Nexc, rexc*tstep);
    m_inh(i) = binornd(Ninh, rinh*tstep);
    %vp(i) = -10*v(i) + Ie - G*Ps_inh(i)*(v(i)-Esyn);
    vp(i) = -10*v(i) - G_exc*Ps_exc(i)*(v(i)-Esyn_exc) - G_inh*Ps_inh(i)*(v(i)-Esyn_inh);
    v(i+1) = v(i) + tstep*vp(i);
     Aexc_p(i) = -1*Aexc(i)/tau1_exc;
%     Aexc(i+1) = Aexc(i) + tstep*Aexc_p(i);
     Bexc_p(i) = -1*Bexc(i)/tau2_exc;
%     Bexc(i+1) = Bexc(i) + tstep*Bexc_p(i);
     Ainh_p(i) = -1*Ainh(i)/tau1_inh;
%     Ainh(i+1) = Ainh(i) + tstep*Ainh_p(i);
     Binh_p(i) = -1*Binh(i)/tau2_inh;
%     Binh(i+1) = Binh(i) + tstep*Binh_p(i);
    Aexc(i+1) = Aexc(i) + tstep*Aexc_p(i) + m_exc(i)*dPs_exc*(1-Ps_exc(i));
    Bexc(i+1) = Bexc(i) + tstep*Bexc_p(i) + m_exc(i)*dPs_exc*(1-Ps_exc(i));
    Ainh(i+1) = Ainh(i) + tstep*Ainh_p(i) + m_inh(i)*dPs_inh*(1-Ps_inh(i));
    Binh(i+1) = Binh(i) + tstep*Binh_p(i) + m_inh(i)*dPs_inh*(1-Ps_inh(i));
    Ps_exc(i+1) = Ntau_exc*(Aexc(i+1) - Bexc(i+1));
    Ps_inh(i+1) = Ntau_inh*(Ainh(i+1) - Binh(i+1));
    if (v(i) < vthresh && v(i+1) > vthresh)
        v(i+1) = c;
        % fprintf('V1 spike at %d\n', time(i))
        tspike1 = [tspike1; time(i)];
        % if spike, synaptic variables get updated?????????????
        Aexc(i+1) = Aexc(i) + m_exc(i)*dPs_exc*(1-Ps_exc(i));
        Bexc(i+1) = Bexc(i) + m_exc(i)*dPs_exc*(1-Ps_exc(i));
        Ainh(i+1) = Ainh(i) + m_inh(i)*dPs_inh*(1-Ps_inh(i));
        Binh(i+1) = Binh(i) + m_inh(i)*dPs_inh*(1-Ps_inh(i));
    end
%     vp(i, 2) = -10*v(i, 2) + Ie - G*Ps_exc(i)*(v(i,2)-Esyn);
%     v(i+1, 2) = v(i, 2) + tstep*vp(i,2);
%     Ainh_p(i) = -1*Ainh(i)/tau1;
%     Ainh(i+1) = Ainh(i) + tstep*Ainh_p(i);
%     Binh_p(i) = -1*Binh(i)/tau2;
%     Binh(i+1) = Binh(i) + tstep*Binh_p(i);
%     Ps_inh(i+1) = N*(Ainh(i+1) - Binh(i+1));
%     if (v(i, 2) < vthresh && v(i+1, 2) > vthresh)
%         v(i+1, 2) = vreset;
%         % fprintf('V2 spike at %d\n', time(i))
%         tspike2 = [tspike2; time(i)];
%         Ainh(i+1) = Ainh(i)+dPs*(1-Ps_inh(i));
%         Binh(i+1) = Binh(i)+dPs*(1-Ps_inh(i));
%     end
    
end
close all;
plot(time, v)

% minlength = min(length(tspike1), length(tspike2));
% dPhi = zeros(minlength, 1);
% diff = zeros(minlength, 1);
% for i = 1:length(dPhi)-1
%     dPhi(i) = (tspike1(i+1) - tspike2(i+1))/(tspike1(i+1)-tspike1(i));
%     diff(i) = tspike1(i+1)-tspike2(i+1);
% end
% 
% 
% plot(time, v(:,2), 'b', time, v(:,1),'r')
% 
% output = [tspike1(1:minlength-1,:) dPhi(1:end-1,:) diff(1:end-1,:)];
% plot(tspike1, dPhi)