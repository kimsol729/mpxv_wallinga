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

    %%
    % 
    % z = squeeze(sum(state,1));
    % g1 = squeeze(state(1, 3, :));
    % g2 = squeeze(state(2, 3, :));
    % g3 = squeeze(state(3, 3, :));
    % g4 = squeeze(state(4, 3, :));
    % % figure(1)
    % % hold on
    % % plot(t_span, z(3,:))
    % % % plot(t_span, z(4,:))
    % % xlim([t_init, t_termi])
    % % hold off
    % 
    % figure(2)
    % hold on 
    % plot(t_span, z(3,:), 'linewidth', 2)
    % plot(t_span, g1, 'linewidth', 2)
    % plot(t_span, g2, 'linewidth', 2)
    % plot(t_span, g3, 'linewidth', 2)
    % plot(t_span, g4, 'linewidth', 2)
    % legend('Total', 'very low', 'fairly low', 'fairly high', 'very high')
    % xlim([t_init, t_termi])
    % hold off

    %%
        z = squeeze(sum(state,1));
    g1 = squeeze(state(1, 4, :) + state(1, 8, :) + state(1, 12, :));
    g2 = squeeze(state(2, 4, :) + state(2, 8, :) + state(2, 12, :));
    g3 = squeeze(state(3, 4, :) + state(3, 8, :) + state(3, 12, :));
    g4 = squeeze(state(4, 4, :) + state(4, 8, :) + state(4, 12, :));
    

    
    figure(2)
    hold on 
    plot(t_span, z(4,:) + z(8,:) + z(12,:), 'linewidth', 2)
    plot(t_span, g1, 'linewidth', 2)
    plot(t_span, g2, 'linewidth', 2)
    plot(t_span, g3, 'linewidth', 2)
    plot(t_span, g4, 'linewidth', 2)
    legend('Total', 'very low', 'fairly low', 'fairly high', 'very high')
    xlim([t_init, t_termi])
    hold off

    %%
    daily_cases = diff(I_vals) / dt;