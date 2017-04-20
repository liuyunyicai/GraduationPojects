% 常量
run('ConstantValues');

info_length = 10;

x_grid = 20;
y_grid = 80;
z_grid = 16;

GridInfo = zeros(x_grid, y_grid, z_grid, info_length);
x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

%% ================ 设置数据 ============== %%
TempTest = [
    0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0; 
    ];
TempTest1 = [TempTest TempTest];
TempTest1 = [TempTest1 TempTest1];
% Test = [TempTest1; TempTest1];
Test = TempTest1;
%楼层底层，用以区分楼梯出口
Floor = ones(x_max, y_max);
FloorIndex1 = [8,1;9,1;3,1; 2,1];
for i = 1 : size(FloorIndex1, 1)
    Floor(FloorIndex1(i, 1), FloorIndex1(i, 2)) = 0;
end

Floor2 = ones(x_max, y_max);
FloorIndex2 = [12, y_max;12,y_max - 1;11,y_max;11, y_max - 1];
for i = 1 : size(FloorIndex2, 1)
    Floor2(FloorIndex2(i, 1), FloorIndex2(i, 2)) = 0;
end
% Test
for i = 1 : size(FloorIndex2, 1)
    Floor(FloorIndex2(i, 1), FloorIndex2(i, 2)) = 0;
end

Data = zeros(x_max, y_max, z_max);
prefered_size = 0;
for i = 1 : z_max
    if mod(i, 2) == 0 % 如果为偶数，则表示为中间层
        if i > 0 * 2 
            % 设定数据
            Data(:, :, i) = Floor(:, :);
            for j= 1 : size(FloorIndex1, 1)
                prefered_size = prefered_size + 1;
                PreferedGrids(prefered_size,1) = FloorIndex1(j, 1);
                PreferedGrids(prefered_size,2) = FloorIndex1(j, 2);
                PreferedGrids(prefered_size,3) = i - 1;
            end
            for j = 1 : size(FloorIndex2, 1)
                prefered_size = prefered_size + 1;
                PreferedGrids(prefered_size,1) = FloorIndex2(j, 1);
                PreferedGrids(prefered_size,2) = FloorIndex2(j, 2);
                PreferedGrids(prefered_size,3) = i - 1;
            end
        else
            Data(:, :, i) = Floor2(:, :);
            for j = 1 : size(FloorIndex2, 1)
                prefered_size = prefered_size + 1;
                PreferedGrids(prefered_size,1) = FloorIndex2(j, 1);
                PreferedGrids(prefered_size,2) = FloorIndex2(j, 2);
                PreferedGrids(prefered_size,3) = i - 1;
            end
        end
        if i == 0 * 2
            for j= 1 : size(FloorIndex1, 1)
                prefered_size = prefered_size + 1;
                PreferedGrids(prefered_size,1) = FloorIndex1(j, 1);
                PreferedGrids(prefered_size,2) = FloorIndex1(j, 2);
                PreferedGrids(prefered_size,3) = i - 1;
            end
             for j = 1 : size(FloorIndex2, 1)
                prefered_size = prefered_size + 1;
                PreferedGrids(prefered_size,1) = FloorIndex2(j, 1);
                PreferedGrids(prefered_size,2) = FloorIndex2(j, 2);
                PreferedGrids(prefered_size,3) = i + 1;
            end
        end
    else
        Data(:, :, i) = Test(:, :);
    end
end

% 为GridInfos初始化赋值
Tc = 20; % 室温20度
 for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            if Data(x,y,z) == 1
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = BLOCKED_ZONE;
            else 
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
            end
			% 设置温度
			% 设置节点类型
			GridInfo(x, y, z, GRID_INDEX_TYPE) = COMMON_POINT;
			for i = 1 : size(PreferedGrids, 1)
				GridInfo(PreferedGrids(i, 1),PreferedGrids(i, 2),PreferedGrids(i, 3), GRID_INDEX_TYPE) = STAIRCASE_POINT;
				if PreferedGrids(i, 3)+ 1 <= z_max
					GridInfo(PreferedGrids(i, 1),PreferedGrids(i, 2),PreferedGrids(i, 3)+ 1, GRID_INDEX_TYPE) = STAIRCASE_POINT;
				end
			end			
			GridInfo(x, y, z, GRID_INDEX_TEMPERATURE) = Tc;
            GridInfo(x, y, z, GRID_INDEX_O2) = 0.21;
        end        
    end
 end
 



%% ================ 设置火灾危险区域 ===================%%
% FireGrids = [8, 4, 9;
%                          12, 26, 15]; % 着火点位置
FireGrids = []; % 着火点位置
% FireGrids = []; % 着火点位置
temp_size = 0;
% 设置火灾区域
for x = 8 : 9
    for y = 1 : 4
        for z = 1 : 2
            temp_size = temp_size + 1;
            FireZones(temp_size,:) = [x, y, z]; 
        end
    end
end

for x = 11 : 13
    for y = 25 : 27
        for z = 1 : 2
            temp_size = temp_size + 1;
            FireZones(temp_size,:) = [x, y, z]; 
        end
    end
end

for i = 1 : size(FireZones, 1)
    GridInfo(FireZones(i, 1), FireZones(i, 2), FireZones(i, 3), GRID_INDEX_ISFREE) = FIRED_ZONE;
end

%% ================ 设置火场其他危险参数信息 ================ %% 
% 设置火灾区域
T0 = 500;
x0 = 8;
y0 = 1;
z0 = 13;
for x = x0 : (x0 + 1)
    for y = y0 : (y0 + 3)
        for z = z0 : (z0 + 2)
            temp_size = temp_size + 1;
            DangerZones(temp_size,:) = [x, y, z, 500 * (0.8 ^ (x + y + z - x0 - y0 - z0))]; 
        end
    end
end

temp_size = 0;
x0 = 1;
y0 =15 ;
z0 = 1;
for x = x0 : (x0 + 5)
    for y = y0 : (y0 + 4)
        for z = z0 : (z0 + 3 )
            temp_size = temp_size + 1;
            DangerZones(temp_size,:) = [x, y, z, 500 * (0.8 ^ (x + y + z - x0 - y0 - z0))]; 
        end
    end
end

for i = 1 : size(DangerZones, 1)
%     GridInfo(DangerZones(i, 1), DangerZones(i, 2), DangerZones(i, 3), GRID_INDEX_ISFREE) = FIRED_ZONE + 0.5;
    GridInfo(DangerZones(i, 1), DangerZones(i, 2), DangerZones(i, 3), GRID_INDEX_TEMPERATURE) = DangerZones(i, 4);
end


 
%% ================ 设置入口出口点 =====================%%
EntranceGrid = [10, 18, z_max - 1];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
% ExitGrids = [2, 19, 1;
%              10, 8, 1];
ExitGrids = [x_max, y_max, 1;];
%                         1, 70, 1];
n = size(ExitGrids, 1);
for k = 1 : n
    GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
end

%% =============== 设置蚁群算法相关系数 ================== %%
cycle_max = 30;
ant_num = 20;

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
OptimizeTypes(OPTIMIZE_2) = 1;
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
Nmax = 1; % 指测试的次数
Time = zeros(Nmax);  % 算法运行时间
Length = zeros(Nmax); % 最短路径

grid_size = x_max *  y_max * z_max;
max_step = 600;
BestRoutes = zeros(Nmax, 1, max_step + 1, 3);

for N = 1 : Nmax
    t1 = clock;
    [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length] = ACO4(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters, max_step, PreferedGrids);
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
        hold on;
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


