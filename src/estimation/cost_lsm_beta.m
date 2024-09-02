function J = cost_lsm_beta(data, params, beta)
%% Simulate the Model

isEstimated = cell2mat(params(:, 3));
params(isEstimated, 2) = num2cell(beta);

[~, I_incidence, ~] = simulate_model_beta(params);

%% Assign Parameters
% 
% t_init_ = parameter.t_init;
% age_est_init_ = parameter.age_est_init;
% age_est_termi_ = parameter.age_est_termi;
% t_est_init_ = parameter.t_est_init;
% t_est_termi_ = parameter.t_est_termi;

%% Compute Cost

% age_span = age_est_init_:age_est_termi_;
% age_index = age_span + 1;
% year_span = t_est_init_:t_est_termi_;
% year_index = year_span - t_init_ + 1;
% year_index4data = year_span - 2002 + 1;

observation = data;

measurement = I_incidence;

J = sum(sum((observation - measurement) .^ 2));

end