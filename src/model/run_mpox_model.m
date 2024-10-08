function [state, run_time] = run_mpox_model(parameter)
%% Assign Parameter
tStart = tic;
n_group_ = parameter.n_group;
n_comp_ = parameter.n_comp;
dt_ = parameter.dt;
t_init_ = parameter.t_init;
t_termi_ = parameter.t_termi;
y0_ = parameter.y0;

%% Run MPXV Model
tspan = 1: dt_ : days(t_termi_ - t_init_ + 1);
[~, y] = ode45(@(t, y) mpox_model1(t, y, parameter), tspan, y0_);
state = reshape(y', n_group_, n_comp_, []);

% y0 = y0_;
% n_t_day = (days(t_termi_ - t_init_) + 1) / dt_;
% state = zeros(n_group_, n_comp_, n_t_day);
% state(:, :, 1) = y0;
% for j = 1:n_t_day - 1
%     sol = mpox_model1(j, y0, parameter);
%     sol = reshape(sol, n_group_, n_comp_);
%     y0 = y0 + sol .* dt_;
%     state(:, :,j+1) = y0;
% end

run_time = toc(tStart);
end