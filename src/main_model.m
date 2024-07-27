clear 
close all
clc

restoredefaultpath 
addpath 'model' 'documentation'

prefix = '';
suffix = '';
result_path = '../result';


params = {'n_group', 4 , false, 'Activity group'
    'N', 250000, false, 'Number of MSM in the Netherlands'
    'result_path', result_path, false, 'Path for saving the result files'
    'prefix', prefix, false, 'Prefix'
    'suffix', suffix, false, 'Suffix'
    'n_comp', 14, false, 'The number of compartments'
    't_init', datetime(2022, 4, 27), false, 'Initial date of simulation'
    't_termi', datetime(2022, 7, 25), false, 'Terminal date of simulation'
    'behavioral_adaptation', 'july', false, 'Behavioral Adaptation'
    'dt', 1, false, 'Time step per day'
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
    
%%