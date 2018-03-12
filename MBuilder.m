function M = MBuilder(k_matrix)

n = size(k_matrix,1);

% M = zeros(n);
% 
% for ii = 1:size(k_matrix,2)
%     M = M + k_matrix(:,ii)*k_matrix(:,ii)';
% end
% 
% M = 1/n*M;

M = (k_matrix*k_matrix')/n;
end