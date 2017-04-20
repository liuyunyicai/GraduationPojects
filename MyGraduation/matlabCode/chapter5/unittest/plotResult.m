%%% ============ 绘制结果仿真曲线 ================= %%
Exper = load('Exper1.mat');
Tt = Exper.Tt;
Theory = load('Theory1.mat');
Temperature = Theory.Temperature;

figure;
plot(Tt, 'b');
hold on;
plot(Temperature, 'r');
title('温度');
ylabel('温度/度');
xlabel('时间/s');