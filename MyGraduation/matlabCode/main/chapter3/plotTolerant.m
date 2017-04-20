% %% 科尼拉公式 %%%
% size = 0;
% for T = 0 : 400
%     size = size + 1;
%     t(size) = (3.28 * (10 ^ 8)) / (T ^ 3.61);
% end
% 
% plot(t, 'k');
% xlim([50  400]);
% ylim([0  100]);
% ylabel('忍受时间/min');
% xlabel('环境温度/\circC');

%%% 国际标准升温曲线 %%%% 

size = 0;
for time = 1 : 50
    size = size + 1;
    Tz(size) =  345 * log10(8 * time + 1) + 20; 
end
plot(Tz, 'k');
ylim([300  1000]);
xlim([0 50]);
xlabel('火灾发生时间/min');
ylabel('环境温度/\circC');
