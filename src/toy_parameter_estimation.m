clc; clear; clf; close all

% 초기 조건 및 파라미터 설정
N = 50000000*0.03; % 총 인구 3%
sigma = 1/6.5;     % 노출에서 감염으로 진행되는 비율
gamma_a = 1/14;    % 무증상 감염자의 회복율
gamma_s = 1/14;     % 증상 감염자의 회복율
alpha = 0.7;       % 무증상 감염자의 비율 (가정)
% beta = 0.5; % trasmission per sexual contact

E0 = 0;
Ia0 = 1000;
Is0 = 1;
R0 = N*2/5; % 1979년 이전 출생자.
S0 = N-E0-Ia0-Is0-R0;
y0 = [S0, E0, Ia0, Is0, R0];


cases = [1; 7; 15; 17; 15; 15; 6; 11; 10; 4; 5; 5; 1; 2; 6; 
    1; 3; 4; 2; 1; 2; 3; 3; 1; 3; 1; 3; 0; 1; 0; 0; 0; 2; 0;
    0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
    0; 0; 0; 0; 1; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0];


start_week = datetime(2023, 4, 3);
end_week = start_week + calweeks(length(cases) - 1);
weeks = start_week:calweeks(1):end_week; %68w

% Define start and end dates
start_date = weeks(1); % Replace with your start date
end_date = start_week + calweeks(length(cases) - 1) + 6; % Replace with your end date

% Generate date vector in days
dates = start_date:days(1):end_date;


days = 1:476;


%% Temporary
beta_temp = 0.03;
beta_a = beta_temp;
beta_s = beta_temp;
[t, y] = ode45(@(t, y) SEIR_model(t, y, N, beta_a, beta_s, sigma, gamma_a, gamma_s, alpha), days, y0);
E = y(:,2);
new_infectious = sigma*(1-alpha)*(E(1:end-1)+E(2:end))/2;

% 결과 그래프 그리기
figure('Position', [100, 100, 1200, 400])
subplot(121)
hold on
plot(dates, y(:,1), 'DisplayName', 'S', 'LineWidth', 2);
plot(dates, y(:,2),'DisplayName', 'E', 'LineWidth', 2);
plot(dates, y(:,3),'DisplayName', 'A', 'LineWidth', 2);
plot(dates, y(:,4),'DisplayName', 'I', 'LineWidth', 2);
plot(dates, y(:,5),'DisplayName', 'R', 'LineWidth', 2);
xlabel('날짜');
ylabel('인구 수');
legend;
title('SEIAR Toy Example');
grid on;
hold off;
xlim([start_week, end_week]);

subplot(122)
predicted_cases = weekly_cases(y, t, length(cases), sigma, alpha);
plot(weeks, cases, 'o', 'LineWidth', 2);
hold on;
plot(weeks, predicted_cases, '-', 'LineWidth', 2);
xlabel('날짜');
ylabel('주간 확진자 수');
legend('실제 확진자 수', '예측된 확진자 수');
title('주간 확진자 수 시각화');
grid on;


%% beta estimation

% 최적화 함수 호출
initial_beta = 0.1; % 초기 추정 값
options = optimset('fminsearch');
beta_estimate = fminsearch(@(beta) objective(beta, N, sigma, gamma_a, gamma_s, alpha, y0, days, cases), initial_beta, options);

% 추정된 파라미터로 SEIR 모델 실행
beta_a = beta_estimate;
beta_s = beta_estimate;result
src
reproducr_paper.m
[t, y] = ode45(@(t, y) SEIR_model(t, y, N, beta_a, beta_s, sigma, gamma_a, gamma_s, alpha), days, y0);

% 예측된 주간 확진자 수
predicted_cases = weekly_cases(y, t, length(cases), sigma, alpha);

% 결과 그래프 그리기
figure;
plot(weeks, cases, 'o', 'LineWidth', 2);
hold on;
plot(weeks, predicted_cases, '-', 'LineWidth', 2);
xlabel('날짜');
ylabel('주간 확진자 수');
legend('실제 확진자 수', '예측된 확진자 수');
title(['주간 확진자 수 시각화 (추정된 \beta = ', num2str(beta_estimate), ')']);
grid on;




%%
% SEIR 모델 함수
function dydt = SEIR_model(t, y, N, beta_a, beta_s, sigma, gamma_a, gamma_s, alpha)
    S = y(1);
    E = y(2);
    Ia = y(3);
    Is = y(4);
    R = y(5);
    
    dSdt = -beta_a * S * Ia / N - beta_s * S * Is / N;
    dEdt = beta_a * S * Ia / N + beta_s * S * Is / N - sigma * E;
    dIadt = alpha * sigma * E - gamma_a * Ia;
    dIsdt = (1 - alpha) * sigma * E - gamma_s * Is;
    dRdt = gamma_a * Ia + gamma_s * Is;
    
    dydt = [dSdt; dEdt; dIadt; dIsdt; dRdt];
end

% 주간 확진자 수 집계 함수 수정
function weekly_cases = weekly_cases(y, t,num_weeks,sigma, alpha)
    days = t; % 시간 단위를 일 단위로 변환
    E = y(:,2);
    new_infectious = sigma*(1-alpha)*(E(1:end-1)+E(2:end))/2;
    weekly_cases = zeros(num_weeks, 1);
    for i = 1:num_weeks
        week_start = (i-1) * 7;
        week_end = i * 7;
        weekly_cases(i) = sum(new_infectious(days >= week_start & days < week_end));
    end
end

% 최소 제곱법을 위한 함수 정의
function error = objective(beta, N, sigma, gamma_a, gamma_s, alpha, y0, tspan, cases)
    beta_a = beta; % beta_a = beta_s = beta
    beta_s = beta;
    
    [t, y] = ode45(@(t, y) SEIR_model(t, y, N, beta_a, beta_s, sigma, gamma_a, gamma_s, alpha), tspan, y0);
    predicted_cases = weekly_cases(y, t, length(cases), sigma, alpha);
    error = sum((cases - predicted_cases).^2);
end