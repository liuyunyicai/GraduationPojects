%% ========== 建筑物三维建模相关模拟数据信息 ============== %% 
clear; % 清空数据
% 常量
run('ConstantValues');

info_length = 10;

%% ================ 设置数据 ============== %%
% 用于第三种优化方案测试
% TempTest = [
%     0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0;
%     0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0; 
%     0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0; 
%     0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0; 
%     ];

% TempTest = [
%     0, 1, 1, 1, 1, 1 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     ];

TempTest = [
1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1;   
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1;  
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1;   
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1;
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1; 
1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1; 
1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1; 
1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1; 
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;  
1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1;   
1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1;   
1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1; 
1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;    
];


% TempTest = [
%     0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0;
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1;  
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1;  
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0;
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0; 
%     0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0; 
%     1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0; 
%     1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0; 
%     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0; 
%     0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0; 
%     ];
TempTest1  = TempTest;
% TempTest1 = [TempTest TempTest];
% TempTest1 = [TempTest1 TempTest1];
% Test = [TempTest1; TempTest1];
Test = TempTest1;

x_grid = size(Test, 1);
y_grid = size(Test, 2);
z_grid = 16;
% z_grid = 4;

GridInfo = zeros(x_grid, y_grid, z_grid, info_length);
x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

%% ================ 设置入口出口点 =====================%%
EntranceGrid = [2, 2, z_max - 1];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
% ExitGrids = [2, 19, 1;
%              10, 8, 1];
ExitGrids = [
    round(x_max / 2), y_max, 1;
%                         x_max, y_max, 1;
                        ];
%                         1, 70, 1];
n = size(ExitGrids, 1);
for k = 1 : n
    GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
end

%%================== 设置楼梯出口 ==================== %%
%楼层底层，用以区分楼梯出口
Floor = ones(x_max, y_max);
FloorIndex1 = [
%     15, 1;
%     16, 1;
    
%     19, 1;
%     20,  1;
    
%     3, y_max; 
%     4,y_max; 
    
%     10, y_max; 
%     11,y_max;
        1, round(y_max / 2);
         x_max, round(y_max / 2);
    ];
for i = 1 : size(FloorIndex1, 1)
    Floor(FloorIndex1(i, 1), FloorIndex1(i, 2)) = 0;
end

Data = zeros(x_max, y_max, z_max);
prefered_size = 0;
for i = 1 : z_max
    if mod(i, 2) == 0 % 如果为偶数，则表示为中间层
        % 设定数据
        Data(:, :, i) = Floor(:, :);
        for j= 1 : size(FloorIndex1, 1)
            prefered_size = prefered_size + 1;
            PreferedGrids(prefered_size,1) = FloorIndex1(j, 1);
            PreferedGrids(prefered_size,2) = FloorIndex1(j, 2);
            PreferedGrids(prefered_size,3) = i - 1;
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
                    GridInfo(PreferedGrids(i, 1),PreferedGrids(i, 2),PreferedGrids(i, 3) + 1, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
                end
                
                GridInfo(PreferedGrids(i, 1),PreferedGrids(i, 2),PreferedGrids(i, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
                
			end			
			GridInfo(x, y, z, GRID_INDEX_TEMPERATURE) = Tc;
            GridInfo(x, y, z, GRID_INDEX_O2) = 0.21;
        end        
    end
 end
 



%% ================ 设置火灾危险区域 ===================%%
% FireGrids = [8, 4, 9;
%                          12, 26, 15]; % 着火点位置

% FireGrids = []; % 着火点位置
temp_size = 0;
% 设置火灾区域
FireIndexs=[
%                         8, 9, 2, 4, 1, 16;                % 火灾区域，格式为[x1,x2,y1,y2,z1,z2]为一个立方体 
%                         11,13, 25, 27, 11,16; 
%                        16, 20, 27, 31, 10, 16;
%                         9, 13, 12, 13, 1, 16;
%                         1, 3, 15, 24, 10, 16;
%                         x_max - 2, x_max, 15, 24, 3, 6;
%                         5, 7, 15, 24, 1, 16;
%                         2,3, 29, 32, 1, 16
                        ];
for i = 1 : size(FireIndexs, 1)
    for x = FireIndexs(i, 1) : FireIndexs(i, 2)
        for y = FireIndexs(i, 3) : FireIndexs(i, 4)
            for z = FireIndexs(i, 5) : FireIndexs(i, 6)
                 temp_size = temp_size + 1;
                 FireZones(temp_size,:) = [x, y, z]; 
            end
        end
    end
end

% 在GridInfo中设置火灾区域
% for i = 1 : size(FireZones, 1)
%     if GridInfo(FireZones(i, 1), FireZones(i, 2), FireZones(i, 3), GRID_INDEX_ISFREE)  == ISACCESSED_ZONE
%         GridInfo(FireZones(i, 1), FireZones(i, 2), FireZones(i, 3), GRID_INDEX_ISFREE) = FIRED_ZONE;
%     end
% end

% ================ 设置火场其他危险参数信息 ================ %% 
% 设置火灾区域
T0 = 500;
FireGrids = [   x_max - 8, 11, 15;
                            x_max - 5, 30, 15;
                            x_max - 9, 26, 1;
                            1, round(y_max / 2), 15;
                            x_max, round(y_max/2), 5;
                            ]; % 着火点位置
Tzs = [350; 350; 350; ];
temp_size = 0;

t_beta = 0.04;  % 升温系数
t_eta = 0.6;   % 温度随距离的衰减系数
t_miu = 0.5;
T_deta = 0;
% Tz = 350;
cur_time = 13;
deta_size = 4; %限制火灾区域
for i = 1 : size(FireGrids, 1) 
    fire_x = FireGrids(i, 1);
    fire_y = FireGrids(i, 2);
    fire_z = FireGrids(i, 3);
    Tz = 350;
    for x = max(1, fire_x - deta_size) : min(x_max, fire_x + deta_size)
        for y = max(1, fire_y - deta_size) : min(y_max, fire_y + deta_size)
            for z = fire_z : fire_z
                    temp_size = temp_size + 1;
                    
                    t_s = (((x - fire_x) * 1) ^ 2 + ((y - fire_y) * 1) ^ 2) ^ 0.5;
                    temp_tdeta = Tz * (1 - 0.8 * exp(-t_beta * cur_time) - 0.2 * exp(-0.1 * t_beta * cur_time)) * (t_eta + (1 - t_eta) * exp((0.5 - t_s) / t_miu));
                    
                    T = GridInfo(x, y, z, GRID_INDEX_TEMPERATURE);
                    GridInfo(x, y, z, GRID_INDEX_TEMPERATURE) = max(temp_tdeta, T) ;
%                     DangerZones(temp_size,:) = [x, y, z, max(temp_tdeta, T)]; 
            end
        end
    end
end



for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            T = GridInfo(x, y, z, GRID_INDEX_TEMPERATURE) ;
            C_O2 = GridInfo(x, y, z, GRID_INDEX_O2) * 100;   % 氧气浓度
            C_CO = GridInfo(x, y, z, GRID_INDEX_CO) * 100 * 1000;   % 一氧化碳浓度(ppm)
            C_CO2 = GridInfo(x, y, z, GRID_INDEX_CO2) * 100; % 二氧化碳浓度
            
            
            if (GridInfo(x, y, z, GRID_INDEX_ISFREE) == ISACCESSED_ZONE) &&((T >= DEATH_TEMPERATURE)|| ((C_O2 > 0) &&(C_O2 <= DEATH_O2)) || (C_CO >= DEATH_CO) || (C_CO2 >= DEATH_CO2)) 
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = FIRED_ZONE;
            end
        end
    end
end

for k = 1 : n
    GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
end

%% ============== 设置通道人流密度 ============ %%
Crows = [x_max - 1,  1 , 2, 10, z_max - 1, 10;
                   1, 1, 22, 10, 1, 10;];   % 格式:x1,x_width,y1,y_width,z, num
crow_num = size(Crows, 1);

for i = 1 : crow_num
    for x = Crows(i, 1) : Crows(i, 1) + Crows(i, 2)
        for y = Crows(i, 3) : Crows(i, 3) + Crows(i, 4)
            peoplenum = Crows(i, 6);
            if GridInfo(x, y, Crows(i, 5), GRID_INDEX_ISFREE) == ISACCESSED_ZONE
                 GridInfo(x, y, Crows(i, 5), GRID_INDEX_PEOPLENUM) = peoplenum;
                p = peoplenum * 0.12 / (1 * 1);

                if p >= DEATH_PEOPLE_NUM
                    GridInfo(x, y, Crows(i, 5), GRID_INDEX_ISFREE) = CROWED_ZONE;
                end
            end
           
        end
    end
end
 
for firenum = 1 : size(FireGrids, 1)
         % 获取火源位置
        fire_x = FireGrids(firenum, 1);
        fire_y = FireGrids(firenum, 2);
        fire_z = FireGrids(firenum, 3);
        if (find(ismember(PreferedGrids,FireGrids(firenum, :),'rows')) > 0)
            GridInfo(fire_x, fire_y, max(1, fire_z - 2), GRID_INDEX_ISFREE) = DANGER_ZONE;
            GridInfo(fire_x, fire_y, min(z_max, fire_z + 2), GRID_INDEX_ISFREE) = DANGER_ZONE;
        end
end
    


save('data.mat', 'GridInfo', 'EntranceGrid', 'ExitGrids');
