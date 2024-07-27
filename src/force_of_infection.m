%% Generate contact matrix
clear; clc; clf; close all

G = 4;
N = 250000;
epsilon_M = 0.72; 
epsilon_c = 0.87;
delta_ij = eye(G); % Identity matrix for delta_ij
alpha_M = [0.1, 0.2, 0.7, 0.7]./365; % Rate of forming main regular partnerships per Y
alpha_c = [0.006, 0.044, 0.139, 0.89]; % Number of casual partnes per D
rate_N = [45.1 36.4 17.7 0.7] .* N;

[m_Mij, m_cij] = compute_matrices(epsilon_M, epsilon_c, delta_ij, alpha_M, rate_N, alpha_c);

%% Parameters
q = [0.60 0.51 0.54 0.42];
a_c = [0.006, 0.044, 0.139, 0.89];
w = 0.19;
sigma1 = 0.56;
sigma2 = 0.85;
v1 = sigma1;
v2 = sigma2;
% Define matrices and vectors
beta_s = [0.48, v1*0.48, v2*0.48];
u = [0.03, 0.06, 0.14, 0.14];
uij = (meshgrid(u)+meshgrid(u)')./2;
I = rand(3, 4);
Y = rand(3, 4);
Nj = rate_N;

% Initialize lambda values
lambda_m = [0 0 0 0];
lambda_c = [0 0 0 0];

for i = 1:4
    % Calculate lambda_mi
    for k = 1:3
        for j = 1:4
            lambda_m(i) = lambda_m(i) + m_Mij(i, j) * (1 - (1 - beta_s(k))^uij(i, j)) * (I(k, j) + w * Y(k, j)) / Nj(j);
        end
    end
    lambda_m(i) = q(i) * lambda_m(i);
    
    % Calculate lambda_ci
    for k = 1:3
        for j = 1:4
            lambda_c(i) = lambda_c(i) + beta_s(k) * m_cij(i, j) * (I(k, j) + w * Y(k, j)) / Nj(j);
        end
    end
    lambda_c(i) = a_c(i) * lambda_c(i);
end

lambda_m
lambda_c

function [m_Mij, m_cij] = compute_matrices(epsilon_M, epsilon_c, delta_ij, alpha_M, rate_N, alpha_c)
    % Number of groups
    G = length(rate_N);
    
    % Initialize matrices
    m_Mij = zeros(G, G);
    m_cij = zeros(G, G);
    
    % Compute the sum terms for the denominators
    sum_alpha_MN = sum(alpha_M .* rate_N);
    sum_alpha_cN = sum(alpha_c .* rate_N);
    
    % Compute the m_Mij matrix
    for i = 1:G
        for j = 1:G
            m_Mij(i, j) = epsilon_M * delta_ij(i, j) + (1 - epsilon_M) * (alpha_M(j) * rate_N(j) / sum_alpha_MN);
        end
    end
    
    % Compute the m_cij matrix
    for i = 1:G
        for j = 1:G
            m_cij(i, j) = epsilon_c * delta_ij(i, j) + (1 - epsilon_c) * (alpha_c(j) * rate_N(j) / sum_alpha_cN);
        end
    end
end