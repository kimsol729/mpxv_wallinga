function [state, num_vvac2, num_vvac2_age_yr, num_zvac1, num_zvac1_age_yr, ...
    num_zvac2, num_zvac2_age_yr, num_unzvac_age_yr, run_time] = run_mpox_model(parameter)

tStart = tic;
%% Assign Parameter

behavioral_adaptation_ = parameter.behavioral_adaptation;
n_group_ = parameter.n_group;
n_comp_ = parameter.n_comp;
dt_ = parameter.dt;
t_init_ = parameter.t_init;
t_termi_ = parameter.t_termi;
T2_date_ = parameter.T2_date;
y0_ = parameter.y0;

groupspan = 

%% Run MPXV Model

y = y0_;
n_t_day = days(t_termi_ - t_init_);

state = zeros(n_group_, n_comp_, n_t_day + 1);
state(:, :, 1) = y;


switch behavioral_adaptation_
    case 'july'

        for j = 1:n_t_day
                sol = mpox_model1(j, y0, parameter);
                y0 = y0 + sol;
                state(:, :,j+1) = y0;
        end

    case 'june-july'

    case 'without'

end



run_time = toc(tStart);
end