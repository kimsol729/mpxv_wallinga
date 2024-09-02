function [theta, cost_val, cal_time] = minimizer(data, cost, params, beta0, lb, ub, A, b)

options = optimset();
timerVal = tic;

if (isempty(lb) && isempty(ub)) && (isempty(A) && isempty(b))
    
    [theta, ~] = fminsearch(@(beta) cost(data, params, beta), beta0, options);
    
elseif isempty(A) && isempty(b)
    
    [theta, ~] = fminsearchbnd(@(beta) cost(data, params, beta), beta0, lb, ub, options);
    
else
    
    nonlcon = [];
    [theta, ~] = fminsearchcon(@(beta) cost(data, params, beta), beta0, lb, ub, A, b, nonlcon, options);
    
end

cost_val = cost(data, params, theta);
cal_time = toc(timerVal);

end