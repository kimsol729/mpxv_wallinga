function m_Mij, m_Cij = compute_matrices(parameter);
%% Assign parameter

n_group_ = parameter.n_group;
N_ = parameter.N;
epsilon_M_ = parameter.epsilon_M;
epsilon_C_ = parameter.epsilon_C;
alpha_M_ = parameter.alpha_M;
alpha_C_ = parameter.alpha_c;
rate_N_ = paramter.rate_N;


%%
Nj = rate_N_ .* N_;

% Initialize matrices
m_Mij = zeros(n_group_);
m_Cij = zeros(n_group_);
delta_ij = eye(n_group_);

sum_alpha_MN = sum(alpha_M_ .* Nj);
sum_alpha_CN = sum(alpha_C_ .* Nj);

% Compute matrices
for i = 1:n_group_
    for j = 1:n_group_
        m_Mij(i, j) = epsilon_M_ * delta_ij(i, j) + (1 - epsilon_M_) * (alpha_M_(j) * Nj(j) / sum_alpha_MN);
        m_Cij(i, j) = epsilon_C_ * delta_ij(i, j) + (1 - epsilon_C_) * (alpha_C_(j) * Nj(j) / sum_alpha_CN);
    end
end


end