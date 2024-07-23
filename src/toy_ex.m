clc; clear; clf;
% 초기 조건 및 파라미터 설정
N = 1000;          % 총 인구
beta_a = 0.4;      % 무증상 감염자의 전염율
beta_s = 0.4;      % 증상 감염자의 전염율
sigma = 1/5.2;     % 노출에서 감염으로 진행되는 비율
gamma_a = 1/10;    % 무증상 감염자의 회복율
gamma_s = 1/7;     % 증상 감염자의 회복율
alpha = 0.4;       % 무증상 감염자의 비율

S0 = 999;
E0 = 1;
Ia0 = 0;
Is0 = 0;
R0 = 0;

y0 = [S0, E0, Ia0, Is0, R0];
tspan = [0 30*24];  % 시간을 시간 단위로 설정

%% ODE 솔버 호출
[t, y] = ode45(@(t, y) SEIR_model(t, y, N, beta_a, beta_s, sigma, gamma_a, gamma_s, alpha), tspan, y0);

% 시작 날짜 설정
start_date = datetime(2023, 4, 3);

% 시간 벡터를 날짜 벡터로 변환
dates = start_date + hours(t);

% daily new infectious calculation
E = y(:,2);
new_infectious = sigma*(1-alpha)*(E(1:end-1)+E(2:end))/2;

% 결과 그래프 그리기
figure('Position', [100, 100, 1200, 600])
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
xlim([start_date, start_date + caldays(30)]); % x축을 30일로 제한
subplot(122)
hold on 
plot(dates(1:end-1), new_infectious,'DisplayName', 'new_infectious', 'LineWidth', 2);

grid on;
xlim([start_date, start_date + caldays(30)]); % x축을 30일로 제한
hold off

%%
% 주간 확진자 데이터
cases = [1; 7; 15; 17; 15; 15; 6; 11; 10; 4; 5; 5; 1; 2; 6; 1; 3; 4; 2; 1; 2; 3; 3; 1; 3; 1; 3; 0; 1; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0];

% 시작 날짜 설정
start_date = datetime(2022, 4, 3);
end_date = start_date + calweeks(length(cases) - 1);

% 주간 날짜 생성
dates = start_date:calweeks(1):end_date;

% 데이터 점으로 시각화
figure;
plot(dates, cases, 'o', 'LineWidth', 2);
xlabel('날짜');
ylabel('주간 확진자 수');
title('주간 확진자 수 시각화');
grid on;


%%

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
