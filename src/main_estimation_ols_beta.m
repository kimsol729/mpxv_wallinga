close all
clear

%% Set Path

restoredefaultpath
addpath contact_matrix model estimation estimator optimizer

%% Set Options

prefix = 'lsm_beta';
suffix = '';
result_path = '../result';

dt = 0.1; % differential model 로 바꿔서 사실상 필요 없음
t_init = datetime(2022, 4, 27);
t_termi = datetime(2022, 7, 25);
b_a = 'july';
t_span = t_init:dt:t_termi;% t_span(end) = [];
day_span = t_init:1:t_termi;

%% Data

% Mpox incidence data
% https://www.rivm.nl/en/mpox/current-information-about-mpox
data = readmatrix('../data/mpox_case_netherlands.csv', 'Range', 'C2:C91');
data(isnan(data)) = 0;

%% Set params

params = {'n_group', 4 , false, 'Activity group'
    'N', 250000, false, 'Number of MSM in the Netherlands'
    'result_path', result_path, false, 'Path for saving the result files'
    'prefix', prefix, false, 'Prefix'
    'suffix', suffix, false, 'Suffix'
    'n_comp', 14, false, 'The number of compartments'
    't_init', t_init, false, 'Initial date of simulation'
    't_termi', t_termi, false, 'Terminal date of simulation'
    'behavioral_adaptation', b_a, false, 'Behavioral Adaptation'
    'dt', dt, false, 'Time step per day'
    'prop_past_vacc', [0.25, 0.25, 0.25, 0.25], false, 'Proportion of vaccinated in the past for activity group'
    
    'beta_s', 0.48, true, 'Transmission probability per sex act'
    };


isEstimated = cell2mat(params(:, 3));

%% Estimate Parameters

% initial guess
beta0 = 0.5;
cost0 = cost_lsm_beta(data, params, beta0);

n_est_parameter = sum(isEstimated);
lb = zeros(n_est_parameter, 1);
ub = ones(n_est_parameter, 1);

[beta_lsm, cost_lsm, time_lsm] = estimator_lsm(data, @cost_lsm_beta, params, beta0, lb, ub);
%% Generate Table

rownames = params(isEstimated, 4);
rownames{end + 1} = 'Cost';
rownames{end + 1} = 'Time';

lsm_table = table([beta0; cost0; NaN], [beta_lsm; cost_lsm; time_lsm], ...
    'VariableNames', {'Initial', 'Estimate'}, 'RowNames', rownames)
% save_document(latex, sprintf('%s/%s_result%s.tex', result_path, prefix, suffix));

%% Plot Incidence

compare_dataNestimate_beta(data, params, beta0, beta_lsm)

%% Save Results

save(sprintf('%s/%s_result%s.mat', result_path, prefix, suffix))