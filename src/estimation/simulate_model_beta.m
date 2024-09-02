function [parameter, I_incidence_day, time] = simulate_model_beta(params)
%% Generate parameter

parameter = params2parameter(params);

%% Find initial
y0 = find_initial(parameter);

% Append initial
parameter.y0 = y0;

%% Run the Model

[state, time2] = run_mpox_model(parameter);

%% Calculate Incidence
[~, I_incidence, ~, ~, ~, ~] = calculate_incidence(state, parameter);

% 891x5 --> 90x1
day = 1:10:891;
I_incidence_day = I_incidence(day,5);

time = time2;
end