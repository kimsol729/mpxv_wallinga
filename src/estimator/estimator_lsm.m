function [theta, cost_val, cal_time] = estimator_lsm(data, cost_lsm, params, beta0, lb, ub, A, b)

if nargin < 5
    
    lb = [];
    ub = [];
    A = [];
    b = [];
    
elseif nargin < 7
    
    A = [];
    b = [];
    
end

[theta, cost_val, cal_time] = minimizer(data, cost_lsm, params, beta0, lb, ub, A, b);

end