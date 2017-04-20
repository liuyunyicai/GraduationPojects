%% ===================== 画出最后的算法优化结果 ============== %%
clear;
run('ConstantValues');

% Data =  load('ResultData_OP2_TEST_Final_4.mat');
% Data2 =  load('ResultData_OP2_TEST_Final_4.mat');
% Data3 =  load('ResultData_OP2_TEST_Final_4.mat');
Data =  load('r2_1.mat');
Data2 = load('r2_2.mat');
Data3 =  load('r2_3.mat');

grid = Data.a;
x_max = size(grid, 1);
y_max = size(grid, 2);
z_max = size(grid, 3);

Length = Data.Length;
minLength = min(Length);
minIndexs = find(Length == minLength(1));
minIndex = minIndexs(1);

PreferedGrids = Data.PreferedGrids;
BestRoutes = Data.BestRoutes;

for z = 1 :  z_max / 2
    z_index = 2 * z - 1;
    data = grid(:, :, z_index);
    data1 = grid(:, :, z_index);
    data2 = grid(:, :, z_index);
    for i = 1 : x_max
        for j = 1 : y_max
            if data(i, j) == ISACCESSED_ZONE
                data(i, j) = 0;
                data1(i, j) = 0;
                data2(i, j) = 0;
            elseif data(i, j) == BLOCKED_ZONE
                data(i, j) = 1;
                data1(i, j) = 1;
                data2(i, j) = 0;
            elseif data(i, j) == FIRED_ZONE
                data(i, j) = 0.001;
                data1(i, j) = 0;
                data2(i, j) = 0;
            end
        end
    end
    
    for i = 1 : size(PreferedGrids, 1) 
        if PreferedGrids(i, 3) == z_index
            data2(PreferedGrids(i, 1), PreferedGrids(i, 2)) = 0.001;
        end
    end

%     scale = 1;
%     figure;
%     bar3(data2, scale, 'b');
%     hold on;
%     bar3(data, scale, 'red');
%     title(['Floor' num2str(z)]); 
%     axis image ij off
%     hold on;
%     bar3(data1, scale, 'white');
%     
%      % 绘制疏散路径
%     hold on;
%     n = size(BestRoutes, 3);
%     for i = 1 : (n - 1)
%         temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
%         if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z_index)
%             plot([BestRoutes(minIndex, 1, i, 2)  , BestRoutes(minIndex, 1, i + 1, 2) ] , [BestRoutes(minIndex, 1, i, 1), BestRoutes(minIndex, 1, i + 1, 1)  ], 'g' , 'LineWidth',4);
%         end
%     end
    
end

% 
% figure;
% hold on;
% plot(Data.CycleMean, ':g');
% hold on;
% plot(Data2.CycleMean, '--y');
% hold on;
% plot(Data3.CycleMean, 'm');
% title('算法迭代过程中平均疏散时间统计');                       % 标题
% ylabel('平均疏散时间/s');
% xlabel('迭代次数/次');
% xlim([1 10]);


% 绘制时间曲线
figure;
plot(Data.Time, 'g', 'LineWidth', 1);
hold on;
plot(Data2.Time, '--y');
hold on;
plot(Data3.Time,  ':m');
title('算法运算时间统计');
ylabel('算法运算时间/s');
xlabel('实验次数/次');
% meanTime = mean(Data.Time)

% 绘制最短路径曲线


% figure;
% plot(Data.Length, ':g');
% hold on;
% % plot(Data2.Length, '--y');
% hold on;
% plot(Data3.Length, 'm');
% title('最短疏散路径长度统计');
% ylabel('最短疏散路径长度/m');
% xlabel('实验次数/次');
% ylim([20 100]);
% meanLength = mean(Data.Length);

% % 绘制命中次数
% figure;
% size = size(Data.AllAntArriveTimes, 1);
% for i = 1 : 1
%     hold on;
%     plot(Data.AllAntArriveTimes(i, :) / 40,':g');
%     hold on;
% %     plot(Data2.AllAntArriveTimes(i, :) / 30, '--y');
%     hold on;
%     plot(Data3.AllAntArriveTimes(i, :) / 40, 'm');
% end
% ylim([0 1.1]);
% title('到达终点蚂蚁比例统计');
% ylabel('达到终点蚂蚁占总蚂蚁的比例');
% xlabel('迭代次数/次');

% legend('人工势场优化', '自适应优化','搜索策略优化');


