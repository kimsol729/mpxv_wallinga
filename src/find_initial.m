function y0 = find_initial(parameter)

%% Assign Option Parameter
N_ = parameter.N;
n_group_ = parameter.n_group;
n_comp_ = parameter.n_comp;
N_rate_ = parameter.N_rate;
prop_past_vacc_ = parameter.prop_past_vacc;


%%
y0 = zeros(n_group_, n_comp_);
y0(4, 3) = 3; % assumption
y0(:, 1) = N_ * N_rate_' .* (1-prop_past_vacc_)' - y0(:, 3);
y0(:, 5) = N_ * N_rate_' .* prop_past_vacc_';

end