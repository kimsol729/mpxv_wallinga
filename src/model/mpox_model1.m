function dydt = mpox_model1(t, y, parameter)
%% Assign parameter

phi1_ = parameter.phi1;
phi2_ = parameter.phi2;
theta_ = parameter.theta;
zeta_ = parameter.zeta;
mu_ = parameter.mu;
mu_d_ = parameter.mu_d;

T2_date_ = parameter.T2_date;
t_init_ = parameter.t_init;
dt_ = parameter.dt;
T2_time = (days(T2_date_-t_init_) + 1)./ dt_;

behavioral_adaptation_ = parameter.behavioral_adaptation;

% FOI parameter
q_ = parameter.q;
alpha_c_ = parameter.alpha_c;
w_ = parameter.w;
sigma1_ = parameter.sigma1;
sigma2_ = parameter.sigma2;
beta_s_ = parameter.beta_s;
u_ = parameter.u;
N_ = parameter.N;
N_rate_ = parameter.N_rate;


switch behavioral_adaptation_
    case 'july'
        delta1_ = parameter.delta1;
        delta2_ = parameter.delta2;
        gamma1_ = parameter.gamma1;
        gamma2_ = parameter.gamma2;
        D_22_ = parameter.D_22;
        D_32_ = parameter.D_32;
        D_42_ = parameter.D_42;
        D = [D_22_, D_22_, D_32_, D_42_];

        if t < T2_time
            delta = delta1_;
            gamma = gamma1_;
            [m_Mij, m_Cij] = contact_matrices(parameter, alpha_c_);

        else
            delta = delta2_;
            gamma = gamma2_;
            alpha_c_ = alpha_c_ .* (1 - D);
            [m_Mij, m_Cij] = contact_matrices(parameter, alpha_c_);
        end

    case 'june-july'

    case 'without'
        delta1_ = parameter.delta1;
        gamma1_ = parameter.gamma1;

        delta = delta1_;
        gamma = gamma1_;
        [m_Mij, m_Cij] = contact_matrices(parameter, alpha_c_);
end

n_group_ = parameter.n_group;
n_comp_ = parameter.n_comp;
dt_ = parameter.dt;
y = reshape(y, n_group_, n_comp_);

%% Group-Specific FOI
v1 = sigma1_;
v2 = sigma2_;
beta_s = [beta_s_, v1*beta_s_, v2*beta_s_];
uij = (meshgrid(u_)+meshgrid(u_)')./2;
Nj = N_ * N_rate_;

% Initialize lambda values
lambda_m = zeros(1,n_group_);
lambda_c = zeros(1,n_group_);

for i = 1:4

    for k = 1:3 % u, v, p
        for j = 1:4
            lambda_m(i) = lambda_m(i) + m_Mij(i, j) * (1 - (1 - beta_s(k))^uij(i, j)) * (y(j, 4 * k - 1) + w_ * y(j, 4 * k)) / Nj(j);
            lambda_c(i) = lambda_c(i) + beta_s(k) * m_Cij(i, j) * (y(j, 4 * k - 1) + w_ * y(j, 4 * k)) / Nj(j);
        end
    end
    lambda_m(i) = q_(i) * lambda_m(i);
    lambda_c(i) = alpha_c_(i) * lambda_c(i);

end

lambda = (lambda_c + lambda_m) .* dt_;

%% ODE

S_ui = y(:, 1);
E_ui = y(:, 2);
I_ui = y(:, 3);
Y_ui = y(:, 4);
S_vi = y(:, 5);
E_vi = y(:, 6);
I_vi = y(:, 7);
Y_vi = y(:, 8);
S_pi = y(:, 9);
E_pi = y(:, 10);
I_pi = y(:, 11);
Y_pi = y(:, 12);
R_i = y(:, 13);
H_i = y(:, 14);

% Define the differential equations
dS_ui_dt = -lambda' .* S_ui;
dE_ui_dt = lambda' .* S_ui - (phi2_' + theta_ + mu_) .* E_ui;
dI_ui_dt = theta_ .* E_ui - (delta + zeta_ + mu_ + mu_d_) .* I_ui;
dY_ui_dt = delta .* I_ui - (gamma + zeta_ + mu_ + mu_d_) .* Y_ui;

dS_vi_dt = -(sigma1_ .* lambda' + phi1_' + mu_) .* S_vi;
dE_vi_dt = sigma1_ .* lambda' .* S_vi - (theta_ + phi2_' + mu_) .* E_vi;
dI_vi_dt = sigma1_ .* theta_ .* E_vi - (delta + zeta_ + mu_ + mu_d_) .* I_vi;
dY_vi_dt = delta .* I_vi - (gamma + zeta_ + mu_ + mu_d_) .* Y_vi;

dS_pi_dt = phi1_' .* (S_ui + S_vi) - (sigma2_ .* lambda' + mu_) .* S_pi;
dE_pi_dt = sigma2_ .* lambda' .* S_pi + phi2_' .* (E_ui + E_vi) - (theta_ + mu_) .* E_pi;
dI_pi_dt = sigma2_ .* theta_ .* E_pi - (delta + mu_) .* I_pi;
dY_pi_dt = delta .* I_pi - (gamma + mu_) .* Y_pi;

dR_i_dt = gamma .* (Y_ui + Y_vi + Y_pi + H_i) + (1 - sigma1_) .* theta_ .* E_vi + (1 - sigma2_) .* theta_ .* E_pi - mu_ .* R_i;
dH_i_dt = zeta_ .* (I_ui + I_vi + Y_ui + Y_vi) - (gamma + mu_ + mu_d_) .* H_i;

% Pack the derivatives into a column vector
dydt = [dS_ui_dt; dE_ui_dt; dI_ui_dt; dY_ui_dt;...
    dS_vi_dt; dE_vi_dt; dI_vi_dt; dY_vi_dt; ...
    dS_pi_dt; dE_pi_dt; dI_pi_dt; dY_pi_dt; ...
    dR_i_dt; dH_i_dt];

end