%% =========== 进行蚁群算法开始前火灾位置，出入口位置等设置 ====================== %%
Data = load('InitiationGridData_10s.mat');
AllData = load('AllFdsInfo.mat');

run('ConstantValues');

GridInfo = Data.GridInfo;

x_max = size(GridInfo, 1) ;
y_max = size(GridInfo, 2) ;
z_max = size(GridInfo, 3) ;
info_length = size(GridInfo, 4) ;
% 设置火灾节点位置
FireGrids = [10, 20, 3];

% 设置火警时间
FireParameters = [5];

%% ================ 设置入口出口点 =====================%%
EntranceGrid = [1, 1, z_max - 1];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;

ExitGrids = [ x_max / 4, y_max, 1;];
n = size(ExitGrids, 1);
for k = 1 : n
    GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
end

%% === 设置楼梯出口 =================== %% 
FloorIndex1 = [
    x_max, y_max / 4;
    ];

prefered_size = 0;
for i = 1 : z_max / 2
        for j= 1 : size(FloorIndex1, 1)
            prefered_size = prefered_size + 1;
            PreferedGrids(prefered_size,1) = FloorIndex1(j, 1);
            PreferedGrids(prefered_size,2) = FloorIndex1(j, 2);
            PreferedGrids(prefered_size,3) = 2 * i - 1;
            
            GridInfo(FloorIndex1(j, 1), FloorIndex1(j, 2), 2 * i - 1, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
            GridInfo(FloorIndex1(j, 1), FloorIndex1(j, 2), 2 * i, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
        end
end

%% =========== 设置死亡区域 ================ %%
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

save('data.mat', 'GridInfo', 'PreferedGrids', 'EntranceGrid', 'ExitGrids');

%% ============== 设置通道人流密度 ============ %%
Crows = [x_max - 3, 2, y_max / 4 + 2, 8, 1, 10;
                   x_max/2,  2,  y_max /2, 6, 1, 10;];   % 格式:x1,x_width,y1,y_width,z, num
crow_num = size(Crows, 1);

for i = 1 : crow_num
    for x = Crows(i, 1) : Crows(i, 1) + Crows(i, 2)
        for y = Crows(i, 3) : Crows(i, 3) + Crows(i, 4)
            peoplenum = Crows(i, 6);
            GridInfo(x, y, Crows(i, 5), GRID_INDEX_PEOPLENUM) = peoplenum;
            p = peoplenum * 0.12 / (1 * 1);
            
            if p >= DEATH_PEOPLE_NUM
                GridInfo(x, y, Crows(i, 5), GRID_INDEX_ISFREE) = CROWED_ZONE;
            end
        end
    end
end



