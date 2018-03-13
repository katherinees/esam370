% Read the boys
[patterns,N,N_pattern]=read_patterns(3);

% Create the M matrix
M = MBuilder(patterns');

% Wiggle those boys

dist30 = hw43c(N, N_pattern,0, patterns')

dist31 = hw43c(N, N_pattern,.3, patterns')

% Read the boys
[patterns,N,N_pattern]=read_patterns(4);

% Create the M matrix
M = MBuilder(patterns');

% Wiggle those boys

dist40 = hw43c(N, N_pattern,0, patterns')

dist41 = hw43c(N, N_pattern,.3, patterns')