% Tg = 20;                       % 环境温度
% Tz = 280;
% beta = 0.004;
% yibuq = 0.75;
% miu = 4;
% x = 1 : 10;
% t = 1 : 1000;
% b = 1.0;
% T1 = 1 - 0.8 * exp(-beta * t) - 0.2 * exp(-0.1 * beta * t);
% % disp(T1);
% T2 = yibuq + (1 - yibuq) * exp(-(x - b)/miu);
% % disp(T2);
% T = Tg + Tz * T1'  * T2;
% % disp(T);
% plot(t, T(:, 1));
% % plot(x, T(2000, :));

% %% ====== 火灾升温曲线 ===== %% 
% % T = T0 + 345lg(8 * t  + 1)
% T0 = 20;
% t = 1 : 0.5 : 50;
% T = T0 + 345 * log10(8 * t  + 1);
% plot(t, T);
% xlabel('时间/min');
% ylabel('温度/℃');


T=1:0.1:400;
n = size(T, 2)
t = zeros(n, 1);
p = 3.28 * (10 ^ 8);
for i = 1 : n
    t(i) = p / (T(i) ^ 3.61);
end

plot(T, t);
ylim([0 100]);
ylabel('忍受时间/min');
xlabel('环境温度/℃');
