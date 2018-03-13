v_patterns= sign(2*rand(100,1)-1);
M = MBuilder(v_patterns);

%Initial condition
states = sign(2*rand(100,1)-1);

d = 0;
v = states(:,1);
for ii = 1:5000
    [v, dt] = hopfieldAsync(v, M);
    d = d+dt;
    
    if d == 10
        d = 0;
        states(:,end+1) = v;
    end
end

imagesc(states);

