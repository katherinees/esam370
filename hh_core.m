function period = hodgkin_huxley(injection)

% solves the Hodgkin-Huxley equations using forward Euler

global Ena Ek El Gna Gk Gl Ea Ga
global Iinj Iinj0 time1 duration1 Iinj1 time2 duration2 Iinj2

set(0,'defaultaxesfontsize',16,'defaultaxeslinewidth',1.5,...
'defaultlinelinewidth',2.,'defaultpatchlinewidth',1.5)

dt=.01;
tmax=2000;
% need integer ratio tmax/dt
nsteps=tmax/dt;
if (floor(nsteps)~=nsteps)
  fprintf(' not an integer number of steps nsteps = %g \n',nsteps)
end

% injected current from t=0 to t=time1 
Iinj0=0.0;

% generate brief pulse of injected current
time1=50;
duration1=Inf;
Iinj1=injection; % in mA/mm^2

% generate second brief pulse of injected current
time2=Inf;
duration2=5;
Iinj2=0.03;

Iinj=Iinj0;

% pre-allocate memory for speed
 maxnumsteps=ceil(tmax/dt);
 t=NaN(1,maxnumsteps);
 %Y=NaN(maxnumsteps,6);
 Y = zeros(1,6);

% approximate rest state
 V(1)=-65;
 n(1)=.32;
 m(1)=0.053;
 h(1)=.60;
 % add a, b variables to Y
 a(1)=((0.0761*exp(0.0314*(V(1)+94.22)))/(1+exp(0.0346*(V(1)+1.17))))^(1/3);
 b(1)=(1/(1+exp(0.0688*(V(1)+53.3))))^4;
 
 Y(1,:)=[V(1),n(1),m(1),h(1),a(1),b(1)];
 
 k=1;
 t(1)=0;
 
%  while t(k) < tmax
%   
%   if t(k) >= time1
%     Iinj=Iinj1;
%   end 
%   if t(k) >= time1+duration1
%     Iinj=Iinj0;
%   end 
%   if t(k) >= time2
%     Iinj=Iinj2;
%   end 
%   if t(k) >= time2+duration2
%     Iinj=Iinj0;
%   end
% 
%   % at this point only forward Euler implemented. 
%   % matlab's ode15s would be better 
%   [Y(k+1,:)]=FE(t(k),Y(k,:),dt);
%   t(k+1)=t(k)+dt;
%   k=k+1;
% 
%   if mod(k,1000) == 0
%     fprintf('%g steps t = %g dt =%g \n',k,t(k),dt);
%   end
%   
%  end   

[t, Y] = ode15s(@F, [0, tmax], Y);


numsteps=size(Y,1);

% determine periods
V=Y(1:numsteps,1);
Vsignchange=V(1:end-1).*V(2:end);
indsignchange=find(Vsignchange<0);
periods=indsignchange(3:end)-indsignchange(1:end-2);
periods=dt*periods;

if numel(periods) > 0 
    period = periods(end);
else
    period = 0;
end

% plotting

  figure(1);
  subplot(2,1,1)
  plot(t(1:numsteps),Y(1:numsteps,1),'-');
  axis([0 tmax -80 50]);
  legend(' voltage');
  subplot(2,1,2)
  plot(t(1:numsteps),Y(1:numsteps,2),'r',t(1:numsteps),Y(1:numsteps,3),'b',...
       t(1:numsteps),Y(1:numsteps,4),'m',t(1:numsteps),Y(1:numsteps,5),'g',...
       t(1:numsteps),Y(1:numsteps,6),'y');
  legend('n','m','h','a','b');
  axis([0 tmax 0 1]);
  
  figure(2)
  subplot(1,2,1)
  plot(Y(200:numsteps,1), Y(200:numsteps,2));
  title('Voltage vs. n');
  xlabel('Voltage');
  ylabel('n');
  
  subplot(1,2,2)
  plot(Y(200:numsteps,1), Y(200:numsteps,4));
  title('Voltage vs. h');
  xlabel('Voltage');
  ylabel('h');
  
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Yp=F(time,Y)
  global Iinj0 Iinj time1 duration1 Iinj1 time2 duration2 Iinj2
  if time >= time1
    Iinj=Iinj1;
  end 
  if time >= time1+duration1
    Iinj=Iinj0;
  end 
  if time >= time2
    Iinj=Iinj2;
  end 
  if time >= time2+duration2
    Iinj=Iinj0;
  end


  Yp=F_hh(time,Y)';
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Yp = F_hh(time,Y) 
 
global Ena Ek El Gna Gk Gl Ea Ga
global Iinj

V=Y(1);
n=Y(2);
m=Y(3);
h=Y(4);
a=Y(5);
b=Y(6);

Gna=1.20; % in mS/mm^2
%Gna=0;
Ena=55;
Gk=0.2;
%Gk=0;
Ek=-72.1;

Cm=0.01; % micro Farad/mm^2; time therefore measured in ms
Gl=0.003;
El=-17;

% Homework 2 Part A
Ea = -75;
Ga = 0.47;

Vthresh=-40;

% alpham=0.1*(V-Vthresh)/(1-exp(-0.1*(V-Vthresh)));
% betam=4*exp(-0.0556*(V+65));
% Replace for Homework 2
alpham=0.38*(V+29.7)/(1-exp(-0.1*(V+29.7)));
betam=15.2*exp(-0.0556*(V+54.7));
mp=alpham*(1-m)-betam*m;
 

% alphah=0.07*exp(-0.05*(V+65));
% betah=1/(1+exp(-0.1*(V+35)));
% Replace for Homework 2
alphah = 0.266*exp(-0.05*(V+48));
betah = 3.8/(1+exp(-0.1*(V+18)));
hp=alphah*(1-h)-betah*h;

Vthresh=-55;
%alphan=0.01*(V-Vthresh)/(1-exp(-0.1*(V-Vthresh)));
%betan=0.125*exp(-0.0125*(V+65));
alphan = 0.02*(V+45.7)/(1-exp(-0.1*(V+45.7)));
betan = 0.25*exp(-0.0125*(V+55.7));
ninfinity=alphan/(alphan+betan);
taun=1/(alphan+betan);
np=(ninfinity-n)/taun;

% define a, b for HW2
ainfinity = ((0.0761*exp(0.0314*(V+94.22)))/(1+exp(0.0346*(V+1.17))))^(1/3);
taua = 0.3632+1.158/(1+exp(0.497*(V+55.96)));
ap = (ainfinity-a)/taua;
binfinity = (1/(1+exp(0.0688*(V+53.3))))^4;
taub = 1.24+2.678/(1+exp(0.0624*(V+50)));
bp = (binfinity-b)/taub;

Vp=1/Cm*(Gna*m^3*h*(Ena-V)+Gk*n^4*(Ek-V)+Gl*(El-V)+Ga*a^3*b*(Ea-V)+Iinj);

Yp(1)=Vp;
Yp(2)=np;
Yp(3)=mp;
Yp(4)=hp;
Yp(5)=ap;
Yp(6)=bp;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Y]=FE(time,Y,dt)

Y=Y+dt*F(time,Y);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 