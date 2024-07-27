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

labels = {'Very Low', 'Fairly Low', 'Fairly High', 'Very High'};
figure('Position', [100, 100, 1000, 400])
subplot('Position', [0.05, 0.1, 0.4, 0.8])
h1 = heatmap(m_Mij);
h1.FontSize = 15;
h1.ColorLimits = [0, 1];
title('Regular main partners contact pattern');
colormap(h1, 'parula')
h1.XDisplayLabels = labels;
h1.YDisplayLabels = {'','','',''};

subplot('Position', [0.55, 0.1, 0.4, 0.8])
h2 = heatmap(m_cij);
h2.FontSize = 15;
h2.ColorLimits = [0, 1];
title('Casual partners contact pattern');
colormap(h2, 'parula')
h2.XDisplayLabels = labels;
h2.YDisplayLabels = {'','','',''};

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