function stiff_euler

% Parameters
lambda=-200;
amp=10000;
omega=0.1;
y0=0;
tmax=20;
dt=.0025;
%dt=0.012
method=1;

% pre-allocate memory
numsteps=ceil(tmax/dt);
time=NaN(numsteps+1,1);
y=NaN(numsteps+1,1);

% initial condition
y(1)=y0;
time(1)=0;

% integration loop
for k=1:numsteps
    
    if (method==1)
        % Forward Euler
        y(k+1)=y(k)+dt*(lambda*y(k)+amp*sin(omega*time(k)));
    else
        % Backward Euler for this linear equation to be inserted here
    end
    time(k+1)=time(k)+dt;
    
end
fprintf(' Final time reached = %g \n',time(end))

figure(1);
plot(time(1:numsteps+1),y(1:numsteps+1),'-bo');
xlabel('time')
ylabel('y')

% output to file
fid=fopen('output.dat','w');
% to print two columns corresponding to time and y make an array with two rows consisting of time and y, respectively
% time and y are defined as columns in the pre-allocation statement.
% Therefore you need to transpose them using the apostrophe '
fprintf(fid,' %g %g \n',[time';y']);
fclose(fid);

end

