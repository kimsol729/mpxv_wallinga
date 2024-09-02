function [m_Mij, m_Cij] = contact_matrices(parameter, alpha_c_)
%% Assign parameter

n_group_ = parameter.n_group;
N_ = parameter.N;
epsilon_m_ = parameter.epsilon_m;
epsilon_c_ = parameter.epsilon_c;
alpha_m_ = parameter.alpha_m;
N_rate_ = parameter.N_rate;


%%
Nj = N_rate_ .* N_;

% Initialize matrices
m_Mij = zeros(n_group_);
m_Cij = zeros(n_group_);
delta_ij = eye(n_group_);

sum_alpha_MN = sum(alpha_m_ .* Nj);
sum_alpha_CN = sum(alpha_c_ .* Nj);

% Compute matrices
for i = 1:n_group_
    for j = 1:n_group_
        m_Mij(i, j) = epsilon_m_ * delta_ij(i, j) + (1 - epsilon_m_) * (alpha_m_(j) * Nj(j) / sum_alpha_MN);
        m_Cij(i, j) = epsilon_c_ * delta_ij(i, j) + (1 - epsilon_c_) * (alpha_c_(j) * Nj(j) / sum_alpha_CN);
    end
end


end