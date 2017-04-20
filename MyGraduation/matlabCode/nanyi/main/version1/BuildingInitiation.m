%% =========== 进行蚁群算法开始前火灾位置，出入口位置等设置 ====================== %%
grid_file_name = 'GridInfo.mat';

Data = load(grid_file_name);

run('ConstantValues');
run('NanyiConstant');

GridInfo = Data.GridInfo;

% 设置火警时间
FireParameters = [5];

x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);
info_length = size(GridInfo, 4) ;

%% ============== 设置楼梯通道 =====================%
Stairs = [27.25, -11.75, 33.75, -2;
                  73.25, 0, 80.75, 5.75;
                  105.25, 22.25, 110.75, 30;
                  105, -24, 110.75, -16.25;];
              
 prefered_size = 0;
 for i = 1 : size(Stairs, 1)
     for j = 1 : ALL_FLOOR_LEFT
         if j == ALL_FLOOR_RIGHT
            x1 = Stairs(i, 1);
            x4 = Stairs(i, 3);  
         else
            x4 = -Stairs(i, 1);
            x1 = -Stairs(i, 3);  
         end             
          y1 = Stairs(i, 2);
          y4 = Stairs(i, 4); 
         
         % 设置楼梯通道PreferGrids用以全局引导
         stair_x = changeToGrid((x1 + x4) / 2, TYPE_X);
         stair_y = changeToGrid((y1 + y4) / 2, TYPE_Y);
         for z = 1 : z_max - 1
              if (i == 1) || ((i == 2) && (z <= 4 * 2 - 1)) || (((i == 3) || (i == 4)) && (z <= 5 * 2 - 1))
                  prefered_size = prefered_size + 1;
                 PreferedGrids(prefered_size, 1) =  stair_x;
                 PreferedGrids(prefered_size, 2) =  stair_y;
                 PreferedGrids(prefered_size, 3) =  z;
              end

         end
     end
     
 end 
 
%% ============== 设置火灾参数 ===================== %
FireGrids = [8, 4, 9;
                         12, 26, 15]; % 着火点位置

%% ========= =====设置出口点,设置入口点 ================%
% entranceIndex = [0, 0, z_max - 1];
% entranceIndex = [80, 34, 5];
% EntranceGrid = [changeToGrid(entranceIndex(1) , TYPE_X), changeToGrid(entranceIndex(2) , TYPE_Y), entranceIndex(3)];
% GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
run('ReadEntranceFromDb');

exitIndex = [0, -12, 1;
                         81, 3, 1;
                        -81, 3, 1];
ExitGrids = zeros(size(exitIndex, 1), 3);

n = size(ExitGrids, 1);
for k = 1 : n
    ExitGrids(k, 1) = changeToGrid(exitIndex(k, 1) , TYPE_X);
    ExitGrids(k, 2) = changeToGrid(exitIndex(k, 2) , TYPE_Y);
    ExitGrids(k, 3) = 1;
    
    GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
end




%% =========== 设置死亡区域 ================ %%
fire_zone_num = 0;
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

% ============== 设置通道人流密度 ============ %%
Crows = [85.25, 30, 20, 10, 1, 10;
%                    x_max/2,  2,  y_max /2, 6, 3, 10;
                   ];   % 格式:x1,x_width,y1,y_width,z, num
crow_num = size(Crows, 1);

for i = 1 : crow_num
    x1 = changeToGrid(Crows(i, 1), TYPE_X);
    x4 = changeToGrid(Crows(i, 1) + Crows(i, 2), TYPE_X);
    
    y1 = changeToGrid(Crows(i, 3), TYPE_Y);
    y4 = changeToGrid(Crows(i, 3) + Crows(i, 4), TYPE_Y);
    
    for x = x1 : x4 
        for y = y1 :  y4 
            peoplenum = Crows(i, 6);
            if (GridInfo(x, y, Crows(i, 5), GRID_INDEX_ISFREE) == ISACCESSED_ZONE)
                GridInfo(x, y, Crows(i, 5), GRID_INDEX_PEOPLENUM) = peoplenum;
                p = peoplenum * 0.12 / (1 * 1);

                if p >= DEATH_PEOPLE_NUM
                    GridInfo(x, y, Crows(i, 5), GRID_INDEX_ISFREE) = CROWED_ZONE;
                end
            end
        end
    end
end



