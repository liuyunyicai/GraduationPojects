% 优化策略类型
OPTIMIZE_FIRE = 11; % 将火场参数信息引入进来
OPTIMIZE_ALL = 12;  % 选用所有优化策略
OPTIMIZE_NONE = 10; % 采用原始的蚁群算法
OPTIMIZE_1 = 1;     % 采用单项的优化策略
OPTIMIZE_2 = 2;
OPTIMIZE_3 = 3;
OPTIMIZE_4 = 4;
OPTIMIZE_5 = 5;
OPTIMIZE_6 = 6;
OPTIMIZE_7 = 7;

x_grid = 20;
y_grid = 20;
z_grid = 6;

GridInfo = rand(x_grid, y_grid, z_grid, 10);
x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

TempTest = [
    0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0; 
    ];
% TempTest1 = [TempTest TempTest];
% Test = [TempTest1; TempTest1];
Test = TempTest;
%楼层底层，用以区分楼梯出口
Floor = ones(x_max, y_max);
Floor(7,8) = 0;
% Floor(15,16) = 0;

Data = zeros(x_max, y_max, z_max);
for i = 1 : z_max
    if mod(i, 2) == 0 % 如果为偶数，则表示为中间层
        Data(:, :, i) = Floor(:, :);
    else
        Data(:, :, i) = Test(:, :);
    end
end

 for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            if Data(x,y,z) == 1
                GridInfo(x, y, z, 2) = 0;
            else 
                GridInfo(x, y, z, 2) = 1;
            end
        end        
    end
end




EntranceGrid = [1, 1, z_max - 1];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), 2) = 1;
% ExitGrids = [2, 19, 1;
%              10, 8, 1];
ExitGrids = [x_max, y_max, 1];
n = size(ExitGrids, 1);
for k = 1 : n
    GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), 2) = 1;
end
                    
cycle_max = 10;
ant_num = 20;

% cycle_max = 1;
% ant_num = 1;

Alpha = 1.0;
Beta = 1.0;
Rho = 0.5;
Q = 50;
AcoParameters = [Alpha, Beta, Rho, Q];

FireGrids = []; % 着火点位置
GridParameters = [1 1 1]; % 栅格法建模相关参数
OptimizeTypes = zeros(1, OPTIMIZE_ALL);
% OptimizeTypes(OPTIMIZE_1) = 1;

FireParameters = [5 0];

%======================== 进行测试 =======================%
% 需要记录的数据有
% 10次的运行时间T(10)，计算平均运算时间t
% 10次的最短路径长度Length（10），计算最短长度与平均长度
% 收敛速度
Nmax = 1; % 指测试的次数
Time = zeros(Nmax);  % 算法运行时间
Length = zeros(Nmax); % 最短路径

grid_size = x_max *  y_max * z_max;
max_step = 500;
BestRoutes = zeros(Nmax, 1, grid_size, 3);

for N = 1 : Nmax
    t1 = clock;
    [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length] = ACO(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters);
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
        b = a(:, :, z);
        b(end + 1, end + 1) = 0;
        colormap([0 0 1; 1 1 1]) , pcolor(b);
        axis image ij off
        disp(b);

        hold on;
        n = size(BestRoute, 2);
        for i = 1 : (n - 1)
            temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
            if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z)
                plot([BestRoutes(minIndex, 1, i, 2) + 0.5 , BestRoutes(minIndex, 1, i + 1, 2) + 0.5] , [BestRoutes(minIndex, 1, i, 1) + 0.5, BestRoutes(minIndex, 1, i + 1, 1) + 0.5 ], 'r' );
            end
        end
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


