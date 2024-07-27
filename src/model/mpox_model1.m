function dydt = mpox_model1(t, y, parameter)
%% Assign parameter

% phi1_ = parameter.phi1;
% phi2_ = parameter.phi2;


theta_ = parameter.theta;
delta_ = parameter.delta;
gamma_ = parameter.gamma;
zeta_ = parameter.zeta;
mu_ = parameter.mu;
mua_ = parameter.mua;

y0_ = parameter.y0;

behavioral_adaptation_ = parameter.behavioral_adaptation;
n_group_ = parameter.n_group;
n_comp_ = parameter.n_comp;
dt_ = parameter.dt;
n_t_day_ = parameter.n_t_day;


% FOI parameter
q_ = parameter.q;
a_c_ = parameter.a_c;
w_ = parameter.w;
sigma1_ = parameter.sigma1;
sigma2_ = parameter.sigma2;
beta_ = parameter.beta;
u_ = parameter.u;
N_ = parameter.N;
%% Group-Specific FOI

[m_Mij, m_Cij] = compute_matrices(parameter);
% 
% 
% q = [0.60 0.51 0.54 0.42];
% a_c = [0.006, 0.044, 0.139, 0.89];
% w = 0.19;
% sigma1 = 0.56;
% sigma2 = 0.85;

v1 = sigma1_;
v2 = sigma2_;
beta_s = [beta_, v1*beta_, v2*beta_];
uij = (meshgrid(u_)+meshgrid(u_)')./2;

% I = rand(3, 4);
% Y = rand(3, 4); in the y
% Nj = rate_N;

% Initialize lambda values
lambda_m = zeros(1,n_group_);
lambda_c = zeros(1,n_group_);

for i = 1:4

    for k = 1:3 % u, v, p
        for j = 1:4
            lambda_m(i) = lambda_m(i) + m_Mij(i, j) * (1 - (1 - beta_s(k))^uij(i, j)) * (y(j, 4 * k - 1) + w * y(j, 4 * k)) / Nj(j);
            lambda_c(i) = lambda_c(i) + beta_s(k) * m_Cij(i, j) * (y(j, 4 * k - 1) + w * y(j, 4 * k)) / Nj(j);
        end
    end
    lambda_m(i) = q(i) * lambda_m(i);
    lambda_c(i) = a_c(i) * lambda_c(i);
    
end

% y = reshape(y, n_group_, n_comp_);
lambda = lambda_c + lambda_m;


%% ODE

dydt = zeros(n_group_, n_comp_);

% Varicella SEIR natural
dydt(:, 1) = -lambda .* y(:, 1);
dydt(:, 2) = lambda .* y(:, 1) - sigma_ .* y(:, 2);
dydt(:, 3) = sigma_ .* y(:, 2) - alpha_ .* y (:, 3);
dydt(:, 4) = alpha_ .* y(:, 3) + z_ .* lambda .* y(:, 5) - delta_ .* y(:, 4);

% Zoster SIR natural
dydt(:, 5) = delta_ .* y(:, 4) - rho_ .* y(:, 5) - z_ .* lambda .* y(:, 5) + gamma_ .* y(:, 7);
dydt(:, 6) = rho_ .* y(:, 5) - alpha_z_ .* y(:, 6);
dydt(:, 7) = alpha_z_ .* y(:, 6) - gamma_ .* y(:, 7);

% Varicella vaccination
dydt(:, 8) = -w1_ .* y(:, 8) - k1_ .* lambda .* y(:, 8);
dydt(:, 9) = -w2_ .* y(:, 9) - k2_ .* lambda .* y(:, 9);
dydt(:, 10) = k1_ .* lambda .* y(:, 8) + k2_ .* lambda .* y(:, 9) + z_ .* lambda .* y(:, 11) - delta_ .* y(:, 10);

% Zoster SIR after varicella vaccination
dydt(:, 11) = delta_ .* y(:, 10) - z_ .* lambda .* y(:, 11) - rho_v_ .* y(:, 11) + gamma_ .* y(:, 13);
dydt(:, 12) = rho_v_ .* y(:, 11) - alpha_z_ .* y(:, 12);
dydt(:, 13) = alpha_z_ .* y(:, 12) - gamma_ .* y(:, 13);

% Varicella SEIR breakthrough
dydt(:, 14) = w1_ .* y(:, 8) - r1_ .* lambda .* y(:, 14);
dydt(:, 15) = w2_ .* y(:, 9) - r2_ .* lambda .* y(:, 15);
dydt(:, 16) = r1_ .* lambda .* y(:, 14) + r2_ .* lambda .* y(:, 15) - sigma_ .* y(:, 16);
dydt(:, 17) = sigma_ .* y(:, 16) - alpha_b_ .* y(:, 17);
dydt(:, 18) = alpha_b_ .* y(:, 17) + z_ .* lambda .* y(:, 19) - delta_ .* y(:, 18);

% Zoste SIR breakthrough
dydt(:, 19) = delta_ .* y(:, 18) - rho_ .* y(:, 19) - z_ .* lambda .* y(:, 19) + gamma_ .* y(:, 21);
dydt(:, 20) = rho_ .* y(:, 19) - alpha_z_ .* y(:, 20);
dydt(:, 21) = alpha_z_ .* y(:, 20) - gamma_ .* y(:, 21);

end