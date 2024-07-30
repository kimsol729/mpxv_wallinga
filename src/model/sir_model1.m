%% Difference
% 초기 설정
N = 1000;    % 총 인구수
I0 = 1;      % 초기 감염자 수
S0 = N - I0; % 초기 감수성 인구
R0 = 0;      % 초기 회복자 수
V0 = 10;      % 초기 백신 접종자 수
beta = 0.0003;  % 감염률
gamma = 0.1; % 회복률
delta = 0.5;% 백신 효과
dt = 0.01;    % 시간 간격
T = 100;     % 총 시뮬레이션 시간

% 초기값 할당
S = S0;
I = I0;
R = R0;
V = V0;

% 결과 저장을 위한 배열
S_vals = zeros(1, T/dt);
I_vals = zeros(1, T/dt);
R_vals = zeros(1, T/dt);
V_vals = zeros(1, T/dt);

% 시뮬레이션
for t = 1:T/dt
    S_new = S - beta * S * I * dt + gamma * V * dt;
    I_new = I + beta * S * I * dt - gamma * I * dt;
    R_new = R + gamma * I * dt + delta * V * dt;
    V_new = V - gamma * V * dt - delta * V * dt;

    S = S_new;
    I = I_new;
    R = R_new;
    V = V_new;
    
    S_vals(t) = S;
    I_vals(t) = I;
    R_vals(t) = R;
    V_vals(t) = V;
end

% 그래프 그리기
plot(0:dt:T-dt, S_vals, 'b', 0:dt:T-dt, I_vals, 'r', 0:dt:T-dt, R_vals, 'g', 0:dt:T-dt, V_vals, 'c')
legend('Susceptible', 'Infected', 'Recovered', 'Vaccinated')
xlabel('Time')
ylabel('Population')
title('SIR Model with Vaccination (Difference Method)')


%% Differential
% 초기 조건 및 파라미터
S0 = N - I0;
I0 = 1;
R0 = 0;
V0 = 0;
beta = 0.0003;
gamma = 0.1;
delta = 0.05;
T = 100; % 시뮬레이션 시간

% ODE 정의
function dYdt = sir_ode(t, Y, beta, gamma, delta)
    S = Y(1);
    I = Y(2);
    R = Y(3);
    V = Y(4);
    dSdt = -beta * S * I + gamma * V;
    dIdt = beta * S * I - gamma * I;
    dRdt = gamma * I + delta * V;
    dVdt = -gamma * V - delta * V;
    dYdt = [dSdt; dIdt; dRdt; dVdt];
end

% 초기값
Y0 = [S0; I0; R0; V0];

% ODE 풀기
[t, Y] = ode45(@(t, Y) sir_ode(t, Y, beta, gamma, delta), [0 T], Y0);

% 결과 그래프
plot(t, Y(:,1), 'b', t, Y(:,2), 'r', t, Y(:,3), 'g', t, Y(:,4), 'c')
legend('Susceptible', 'Infected', 'Recovered', 'Vaccinated')
xlabel('Time')
ylabel('Population')
title('SIR Model with Vaccination (Differential Method)')
