clear
close all
clc

%%
restoredefaultpath
addpath 'model' %'documentation'

prefix = '';
suffix = '';
result_path = '../result';

dt = 0.1; % differential model 로 바꿔서 사실상 필요 없음
t_init = datetime(2022, 4, 27);
t_termi = datetime(2022, 7, 25);
b_a = 'july';
t_span = t_init:dt:t_termi;% t_span(end) = [];

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
    'prop_past_vacc', [0.25, 0.25, 0.25, 0.25], false, 'Proportion of vaccinated in the past for activity group'};

parameter = params2parameter(params);


%%
% Equilibrium filename
filename = sprintf('%s/initial_states%s.mat', result_path, suffix);

% Load or find equilibrium
if isfile(filename)
    load(filename, 'y0')
else
    y0 = find_initial(parameter);
    save(filename, 'y0')
end

% Append
parameter.y0 = y0;

%% Run MPOX Model

[state, time] = run_mpox_model(parameter);

%% Calculate Incidence
clf; close all

[I_case, I_incidence, Y_case, Y_incidence, H_case, H_incidence ] = calculate_incidence(state, parameter);
plot_data = I_incidence;

figure(2)
hold on
plot(t_span, plot_data(:,5), 'linewidth', 2)
plot(t_span, plot_data(:,1), '-.', 'linewidth', 2)
plot(t_span, plot_data(:,2), '-.', 'linewidth', 2)
plot(t_span, plot_data(:,3), '-.', 'linewidth', 2)
plot(t_span, plot_data(:,4), '-.', 'linewidth', 2)
legend('Total', 'very low', 'fairly low', 'fairly high', 'very high','Location', 'northwest')
xlim([t_init, t_termi])
title(sprintf('With behavioral adaptations in %s 2022', b_a))
xlabel('Date of symptom onset')
ylabel('Daily number of mpox cases')
hold off
