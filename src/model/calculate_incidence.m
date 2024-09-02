function [I_case, I_incidence, Y_case, Y_incidence, H_case, H_incidence ] = calculate_incidence(state, parameter)
%% Assign parameter
sigma1_ = parameter.sigma1;
sigma2_ = parameter.sigma2;
theta_ = parameter.theta;
delta1_ = parameter.delta1;
delta2_ = parameter.delta2;
zeta_ = parameter.zeta;
% 
% T2_date_ = parameter.T2_date;
% t_init_ = parameter.t_init;
% t_termi_ = parameter.t_termi;
% dt_ = parameter.dt;
% T2_time = (days(T2_date_-t_init_) + 1);
% t_span = t_init_:dt_:t_termi_;

delta = [delta1_ .* ones(1,708), delta2_ .* ones(1, 891-708)];

%%
g1 = squeeze(state(1, 3, :) + state(1, 7, :) + state(1, 11, :));
g2 = squeeze(state(2, 3, :) + state(2, 7, :) + state(2, 11, :));
g3 = squeeze(state(3, 3, :) + state(3, 7, :) + state(3, 11, :));
g4 = squeeze(state(4, 3, :) + state(4, 7, :) + state(4, 11, :));
I_case = [g1, g2, g3, g4, g1 + g2 + g3 + g4];
%%
g1 = squeeze(state(1, 4, :) + state(1, 8, :) + state(1, 12, :));
g2 = squeeze(state(2, 4, :) + state(2, 8, :) + state(2, 12, :));
g3 = squeeze(state(3, 4, :) + state(3, 8, :) + state(3, 12, :));
g4 = squeeze(state(4, 4, :) + state(4, 8, :) + state(4, 12, :));
Y_case = [g1, g2, g3, g4, g1 + g2 + g3 + g4];

%%
g1 = squeeze(state(1, 14, :));
g2 = squeeze(state(2, 14, :));
g3 = squeeze(state(3, 14, :));
g4 = squeeze(state(4, 14, :));
H_case = [g1, g2, g3, g4, g1 + g2 + g3 + g4];
 

%%
g1 = squeeze(theta_ .* state(1, 2, :) + sigma1_ .* theta_ .* state(1, 6, :) + sigma2_ .* theta_ .* state(1, 10, :));
g2 = squeeze(theta_ .* state(2, 2, :) + sigma1_ .* theta_ .* state(2, 6, :) + sigma2_ .* theta_ .* state(2, 10, :));
g3 = squeeze(theta_ .* state(3, 2, :) + sigma1_ .* theta_ .* state(3, 6, :) + sigma2_ .* theta_ .* state(3, 10, :));
g4 = squeeze(theta_ .* state(4, 2, :) + sigma1_ .* theta_ .* state(4, 6, :) + sigma2_ .* theta_ .* state(4, 10, :));


I_incidence = [g1, g2, g3, g4, g1 + g2 + g3 + g4];



%%
g1 = delta'.* squeeze(state(1, 3, :) + state(1, 7, :) + state(1, 11, :));
g2 = delta'.* squeeze(state(2, 3, :) + state(2, 7, :) + state(2, 11, :));
g3 = delta'.* squeeze(state(3, 3, :) + state(3, 7, :) + state(3, 11, :));
g4 = delta'.* squeeze(state(4, 3, :) + state(4, 7, :) + state(4, 11, :));

Y_incidence = [g1, g2, g3, g4, g1 + g2 + g3 + g4];


%%
g1 = zeta_ .* squeeze(state(1, 3, :) + state(1, 4, :) + state(1, 7, :) + state(1, 8, :));
g2 = zeta_ .* squeeze(state(2, 3, :) + state(2, 4, :) + state(2, 7, :) + state(2, 8, :));
g3 = zeta_ .* squeeze(state(3, 3, :) + state(3, 4, :) + state(3, 7, :) + state(3, 8, :));
g4 = zeta_ .* squeeze(state(4, 3, :) + state(4, 4, :) + state(4, 7, :) + state(4, 8, :));

H_incidence = [g1, g2, g3, g4, g1 + g2 + g3 + g4];

end