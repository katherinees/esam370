function hodgkin_huxley

% solves the Hodgkin-Huxley equations using forward Euler

global Ena Ek El Gna Gk Gl
global Iinj

set(0,'defaultaxesfontsize',16,'defaultaxeslinewidth',1.5,...
'defaultlinelinewidth',2.,'defaultpatchlinewidth',1.5)

dt=.01;
tmax=100;
% need integer ratio tmax/dt
nsteps=tmax/dt;
if (floor(nsteps)~=nsteps)
  fprintf(' not an integer number of steps nsteps = %g \n',nsteps)
end

% injected current from t=0 to t=time1 
Iinj0=0.0;

% generate brief pulse of injected current
time1=50;
duration1=5;
Iinj1=0.03; % in mA/mm^2

% generate second brief pulse of injected current
time2=Inf;
duration2=5;
Iinj2=0.03;

Iinj=Iinj0;

% pre-allocate memory for speed
 maxnumsteps=ceil(tmax/dt);
 t=NaN(1,maxnumsteps);
 Y=NaN(maxnumsteps,4); 

% approximate rest state
 V(1)=-65;
 n(1)=.32;
 m(1)=0.053;
 h(1)=.60;
 
 Y(1,:)=[V(1),n(1),m(1),h(1)];
 
 k=1;
 t(1)=0;
 
 while t(k) < tmax
  
  if t(k) >= time1
    Iinj=Iinj1;
  end 
  if t(k) >= time1+duration1
    Iinj=Iinj0;
  end 
  if t(k) >= time2
    Iinj=Iinj2;
  end 
  if t(k) >= time2+duration2
    Iinj=Iinj0;
  end

  % at this point only forward Euler implemented. 
  % matlab's ode15s would be better 
  [Y(k+1,:)]=FE(t(k),Y(k,:),dt);
  t(k+1)=t(k)+dt;
  k=k+1;

  if mod(k,1000) == 0
    fprintf('%g steps t = %g dt =%g \n',k,t(k),dt);
  end
  
 end   
 
numsteps=k-1;

% determine periods
V=Y(1:numsteps,1);
Vsignchange=V(1:end-1).*V(2:end);
indsignchange=find(Vsignchange<0);
periods=indsignchange(3:end)-indsignchange(1:end-2);
periods=dt*periods

% plotting

  figure(1);
  subplot(2,1,1)
  plot(t(1:numsteps),Y(1:numsteps,1),'-');
  axis([0 tmax -80 50]);
  legend(' voltage');
  subplot(2,1,2)
  plot(t(1:numsteps),Y(1:numsteps,2),'r',t(1:numsteps),Y(1:numsteps,3),'b',...
       t(1:numsteps),Y(1:numsteps,4),'m');
  legend('n','m','h');
  axis([0 tmax 0 1]);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Yp=F(time,Y)

  Yp=F_hh(time,Y);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Yp = F_hh(time,Y) 
 
global Ena Ek El Gna Gk Gl
global Iinj

V=Y(1);
n=Y(2);
m=Y(3);
h=Y(4);

Gna=1.20; % in mS/mm^2
%Gna=0;
Ena=50;

Gk=0.36;
%Gk=0;
Ek=-77;

Cm=0.01; % micro Farad/mm^2; time therefore measured in ms
Gl=0.003;
El=-54.387;

Vthresh=-40;
alpham=0.1*(V-Vthresh)/(1-exp(-0.1*(V-Vthresh)));
betam=4*exp(-0.0556*(V+65));
mp=alpham*(1-m)-betam*m;
 
alphah=0.07*exp(-0.05*(V+65));
betah=1/(1+exp(-0.1*(V+35)));
hp=alphah*(1-h)-betah*h;

Vthresh=-55;
alphan=0.01*(V-Vthresh)/(1-exp(-0.1*(V-Vthresh)));
betan=0.125*exp(-0.0125*(V+65));
ninfinity=alphan/(alphan+betan);
taun=1/(alphan+betan);
np=(ninfinity-n)/taun;

Vp=1/Cm*(Gna*m^3*h*(Ena-V)+Gk*n^4*(Ek-V)+Gl*(El-V)+Iinj);

Yp(1)=Vp;
Yp(2)=np;
Yp(3)=mp;
Yp(4)=hp;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Y]=FE(time,Y,dt)

Y=Y+dt*F(time,Y);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 