function parameter = params2parameter(params)
%% Assign Option Parameter

names = params(:, 1);
for k = 1:size(params, 1)
    cmd_string = sprintf('%s_ = params{%d, 2};', names{k}, k);
    eval(cmd_string)
end

%% Set Primary Parameter

% Age structure
switch behavioral_adaptation_

    case 'july'
        params_flow = {
            'med_lat', 5.67, false, 'Median duration of latent period (day)'
            'med_inf', 16.75, false, 'Median duration of infectious period (day)'
            'beta_s', 0.48, false, 'Transmission probability per sex act'
            'a_c_4', 0.89, false, 'Number of casual partners per day, very high activity group'
            'w', 0.19, false, 'Factor reducing transmission when in abstinence (w)'
            'epsilon_m', 0.72, false, 'Assortativeness mixing with main partners'
            'epsilon_c', 0.87, false, 'Assortativeness mixing with casual partners'
            'vacc_p', 0.0004, false, 'Vaccination rate before 25 July 2022'
            'sigma1', 0.56, false, 'Efficacy old vaccine'
            'sigma2', 0.85, false, 'Efficacy new vaccine'
            'zeta', 0.01, false, 'Hospitalization rate'
            };

        params_ba = {'med_inf_1', 6.05, false, 'Days infectious not refraining from sex, before T2'
            'med_inf_2', 2.55, false, 'Days infectious not refraining from sex, after T2'
            'T2_date', datetime(2022, 7, 7), false, 'Date of adaptations in July, T2'
            'D_22', 0.13, false, 'Percentage reduction in casual partners, (very-fairly)low activity groups, after T2'
            'D_32', 0.15, false, 'Percentage reduction in casual partners, fairly high activity group, after T2'
            'D_42', 0.24, false, 'Percentage reduction in casual partners, very high activity group, after T2'};

    case 'june-july'

    case 'without'

                params_flow = {
            'med_lat', 5.67, false, 'Median duration of latent period (day)'
            'med_inf', 16.75, false, 'Median duration of infectious period (day)'
            'beta_s', 0.48, false, 'Transmission probability per sex act'
            'a_c_4', 0.89, false, 'Number of casual partners per day, very high activity group'
            'w', 0.19, false, 'Factor reducing transmission when in abstinence (w)'
            'epsilon_m', 0.72, false, 'Assortativeness mixing with main partners'
            'epsilon_c', 0.87, false, 'Assortativeness mixing with casual partners'
            'vacc_p', 0.0004, false, 'Vaccination rate before 25 July 2022'
            'sigma1', 0.56, false, 'Efficacy old vaccine'
            'sigma2', 0.85, false, 'Efficacy new vaccine'
            'zeta', 0.01, false, 'Hospitalization rate'
            };

        params_ba = {'med_inf_1', 6.05, false, 'Days infectious not refraining from sex, before T2'
            'med_inf_2', 2.55, false, 'Days infectious not refraining from sex, after T2'
            'T2_date', datetime(2022, 7, 7), false, 'Date of adaptations in July, T2'
            'D_22', 0.13, false, 'Percentage reduction in casual partners, (very-fairly)low activity groups, after T2'
            'D_32', 0.15, false, 'Percentage reduction in casual partners, fairly high activity group, after T2'
            'D_42', 0.24, false, 'Percentage reduction in casual partners, very high activity group, after T2'};


end


% Concat params
params_primary = [params_flow; params_ba];

%% Assign Primary Parameter

names = params_primary(:, 1);
for k = 1:size(params_primary, 1)
    cmd_string = sprintf('%s_ = params_primary{%d, 2};', names{k}, k);
    eval(cmd_string)
end

%% Set Sencondary Parameter

% The other progression parameters
params_progression = {'mu', 1 / 50 / 365 , false, '$\mu$'
    'mu_d', 0.0004, false, '$\mu_d$'
    'theta', 1 / med_lat_, false, '$\theta$'
    'delta1',  1 / med_inf_1_, false, '$\delta_1$'
    'delta2',  1 / med_inf_2_, false, '$\delta_2$'
    'gamma1', 1 / (med_inf_ - med_inf_1_), false, '$\gamma_1$'
    'gamma2', 1 / (med_inf_ - med_inf_2_), false, '$\gamma_2$'
    'sigma1', sigma1_, false, '$\sigma_1$'
    'sigma2', sigma2_, false, '$\sigma_2$'
    'zeta', zeta_, false, '$\zeta'
    'phi1', [0 0 0 0], false, '2022 vaccine rate for S'
    'phi2', [0 0 0 0], false, '2022 vaccine rate for E'};


%% Set parmeter the depend on the Sexual Activity Group

parmas_msm = {'N_rate', [0.451, 0.364, 0.177, 0.007], false, 'Rate in specific activity group'
    'alpha_m', [0.1, 0.2, 0.7, 0.7], false, 'Rate of forming main partnership per year'
    'u', [0.03, 0.06, 0.14, 0.14], false, 'Number of sex contacts per main partner per day'
    'q', [0.60, 0.51, 0.54, 0.42], false, 'Rate with main regular partner'
    'alpha_c', [0.006, 0.055, 0.139, a_c_4_], false, 'Number of casual partners per day'};

%% params to parameter

% Concat all params
params = [params; params_primary; params_progression; parmas_msm];

% Assign parameter
names = params(:, 1);
for k = 1:size(params, 1)
    cmd_string = sprintf('parameter.%s = params{%d, 2};', names{k}, k);
    eval(cmd_string)
end

end