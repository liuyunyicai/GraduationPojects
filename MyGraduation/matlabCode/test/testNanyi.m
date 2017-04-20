run('ReadNanyiData');

%% =============== 设置蚁群算法相关系数 ================== %%
cycle_max = 20;
ant_num = 30;

% cycle_max = 1;
% ant_num = 1;

Alpha = 1.0;
Beta = 1.0;
Rho = 0.5;
Q = 10;
AcoParameters = [Alpha, Beta, Rho, Q];

GridParameters = [1 1 1]; % 栅格法建模相关参数
%% ====================== 设置优化策略 ============== %% 
OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
OptimizeTypes(OPTIMIZE_7) = 1;
OptimizeTypes(OPTIMIZE_1) = 1;
OptimizeTypes(OPTIMIZE_3) = 1;
OptimizeTypes(OPTIMIZE_4) = 1;
% OptimizeTypes(OPTIMIZE_2) = 1;
OptimizeTypes(OPTIMIZE_8) = 1;
% OptimizeTypes(OPTIMIZE_FIRE) = 1;
% OptimizeTypes(OPTIMIZE_FIRE1) = 1;
% OptimizeTypes(OPTIMIZE_FIRE2) = 1;
% OptimizeTypes(OPTIMIZE_FIRE3) = 1;

FireParameters = [5 0];

%======================== 进行测试 =======================%
% 需要记录的数据有
% 10次的运行时间T(10)，计算平均运算时间t
% 10次的最短路径长度Length（10），计算最短长度与平均长度
% 收敛速度
Nmax = 5; % 指测试的次数
Time = zeros(Nmax);  % 算法运行时间
Length = zeros(Nmax); % 最短路径

grid_size = x_max *  y_max * z_max;
max_step = 1000;
BestRoutes = zeros(Nmax, 1, max_step + 1, 3);

for N = 1 : Nmax
    t1 = clock;
    [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length] = ACO5(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters, max_step, PreferedGrids);
    t2 = clock;
    Time(N) = etime(t2,t1);
    Length(N) = best_length;
    BestRoutes(N, :) = BestRoute(:);
end

%% ============== 第六步：输出计算得出的结果 ================= %%
minLength = min(Length);
minIndex = find(Length == minLength(1));
% 绘制路径曲线
subplot(2, 2, 1);    
a = zeros(x_max, y_max, z_max);
for z = 1 : z_max
    for x = 1 : x_max
        for y = 1 : y_max
            a(x, y, z) = GridInfo(x, y, z, 2);
        end
    end
    if mod(z, 2) ~= 0
        figure;
        % 绘制三维网格
        title(['Floor' num2str((z + 1) / 2)]); 
        b = a(:, :, z);
        b(end + 1, end + 1) = 0;
        colormap([239/255,65/255,53/255; 1 1 1; 0 0 1; ]) , pcolor(b);
        axis image ij off
        disp(b);

        % 绘制疏散路径
        hold on;
        n = size(BestRoute, 2);
        for i = 1 : (n - 1)
            temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
            if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z)
                plot([BestRoutes(minIndex, 1, i, 2) + 0.5 , BestRoutes(minIndex, 1, i + 1, 2) + 0.5] , [BestRoutes(minIndex, 1, i, 1) + 0.5, BestRoutes(minIndex, 1, i + 1, 1) + 0.5 ], 'r' );
            end
        end
        
        % 绘制火灾区域
        hold on;
        fill([0 1 1 0],[0 0 1 1],'r');
    end
end


figure;
% 绘制蚁群算法相关性能曲线
subplot(2, 2, 2);                                % 绘制第二个子图形
plot(CycleLength);
hold on;                                         % 保持图形
plot(CycleMean, 'r');
title('平均距离和最短距离');                       % 标题

% 绘制时间曲线
hold on;
subplot(2, 2, 3); 
plot(Time);
title('计算时间');
ylabel('计算时间/s');
xlabel('计算次数/次');
meanTime = mean(Time)

% 绘制最短路径曲线
hold on;
subplot(2, 2, 4);  
plot(Length);
title('最短路径长度');
ylabel('最短路径长度/m');
xlabel('计算次数/次');
meanLength = mean(Length)

% GreedySearch(GridInfo, EntranceGrid, ExitGrids);