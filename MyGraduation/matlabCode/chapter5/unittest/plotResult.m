%%% ============ ���ƽ���������� ================= %%
Exper = load('Exper1.mat');
Tt = Exper.Tt;
Theory = load('Theory1.mat');
Temperature = Theory.Temperature;

figure;
plot(Tt, 'b');
hold on;
plot(Temperature, 'r');
title('�¶�');
ylabel('�¶�/��');
xlabel('ʱ��/s');