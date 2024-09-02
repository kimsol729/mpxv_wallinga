function [] = compare_dataNestimate_rho(data, params, beta0, beta)
%% Assign Initial Parameters

isEstimated = cell2mat(params(:, 3));
params(isEstimated, 2) = num2cell(beta0);

%% Run the Model
[~, I_incidence0, ~] = simulate_model_beta(params);
% [parameter0, incidence_z0, ~] = simulate_model_beta(params);

%% Assign Estimated Parameters

params(isEstimated, 2) = num2cell(beta);

%% Run the Model
[parameter, I_incidence, ~] = simulate_model_beta(params);
% [parameter, incidence_z, ~] = simulate_model_rho(params);

%% Assign Parameters
behavioral_adaptation_ = parameter.behavioral_adaptation;
t_init_ = parameter.t_init;
t_termi_ = parameter.t_termi;
result_path_ = parameter.result_path;
prefix_ = parameter.prefix;
suffix_ = parameter.suffix;

%% Plot rho

% age_span = age_init_:age_termi_;
% age_index = age_span + 1;
% year_span = t_est_init_:t_est_termi_;
% year_index = year_span - t_init_ + 1;
% year_index4data = year_span - 2002 + 1;
% 
% % rho values
% beta0 = parameter0.beta_s;
% beta = parameter.beta_s;
% 
% color = get(gcf ,'defaultAxesColorOrder');
% 
% figure(1)
% hold on
% plot(day_span, beta0(1:length(age_span4rho_)), 'Color', color(2, :))
% plot(day_span, beta(1:length(age_span4rho_)), 'Color', color(3, :))
% hold off
% legend('Initial guess', 'Estimate', 'Location', 'northwest')
% xlim([age_span(1), age_span(end)])
% xlabel('Age')
% ylabel('\rho')
% title('Reactivation Rate')
% saveas(gcf, sprintf('%s/%s_rho%s', result_path_, prefix_, suffix_), 'epsc')

%% Plot Incidence

day_span = t_init_:1:t_termi_;

figure(1)
hold on
plot(day_span, data, '.k', 'MarkerSize', 5)
plot(day_span, I_incidence0, 'o-', 'MarkerSize', 5)
plot(day_span, I_incidence, 'o-', 'MarkerSize', 5)
hold off
legend('Data', 'Initial guess', 'Estimate', 'Location', 'northwest')
xlim([t_init_, t_termi_])
title(sprintf('With behavioral adaptations in %s 2022', behavioral_adaptation_))
xlabel('Date of symptom onset')
ylabel('Daily number of mpox cases')
saveas(gcf, sprintf('%s/%s_incidence_mpox_beta_est%s', result_path_, prefix_, suffix_), 'epsc')


end