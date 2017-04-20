% 常量
run('ConstantValues');
run('NanyiConstant');

x_max = x_max_miles * 2/ x_step ;
y_max = y_max_miles  * 2 / y_step;
z_max =z_max_miles / z_step;

GridInfo = zeros(x_max, y_max, z_max, info_length);

% 全部设置为障碍物
for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            GridInfo(x, y, z, GRID_INDEX_ISFREE) = BLOCKED_ZONE;
        end
    end
end

%% ============== 设置可通行通道 ==================== %
% 因为建筑左右是对称的，所以x轴方向对称设置即可
Corridors = [0, -2, 33, 2;
                        33, -2, 51, 2;
                        51, -2, 69, 2;
                 69, -24, 73, 30;
                 69, 30, 123, 34;
                 69, -28, 123, -24]; % 一个矩形通道只需要记录其起始斜角对应的坐标位置即可，即一组数据的值记录的为[x1, y1, x4, y4]；
ALL_FLOOR_RIGHT = 1;
ALL_FLOOR_LEFT = 2;

 for i = 1 : size(Corridors, 1)
     for j = 1 : ALL_FLOOR_LEFT
         x1 = Corridors(i, 1);
         x4 = Corridors(i, 3);
         y1 = Corridors(i, 2);
         y4 = Corridors(i, 4);  
         if j == ALL_FLOOR_LEFT
            x1 = -x4;
            x4 = -x1;      
         end

         
         % 对可通行通道直接赋值即可 
         for x = max(1, changeToGrid(x1, TYPE_X))  :  changeToGrid(x4, TYPE_X) 
             for y = changeToGrid(y1, TYPE_Y)  : changeToGrid(y4, TYPE_Y)
                 for z = 1 : z_max / 2
                     if (i == 1) || ((i == 2) &&(z <= 2 * 6 - 1) || ((i == 3) && (z <= 2 * 4 -1)) || ((i == 4) && (z <= 2 * 4 -1)) || (((i == 5) || (i == 6)) && (z <= 2 * 5 -1)) )
                         GridInfo(x, y, 2 * z - 1, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
                            GridInfo(x, y, 2 * z - 1, GRID_INDEX_TYPE) = COMMON_POINT;  
                     end
             
                 end
             end
         end
     end
 end

 % 设置一楼大厅数据
 x1 = -8.75;
 y1 = -12;
 x4 = 8.75;
 y4 = 11.75;

% 对可通行通道直接赋值即可 
for x = max(1, changeToGrid(x1, TYPE_X))  :  changeToGrid(x4, TYPE_X) 
 for y = changeToGrid(y1, TYPE_Y)  : changeToGrid(y4, TYPE_Y)
         GridInfo(x, y, 1, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
         GridInfo(x, y, 1, GRID_INDEX_TYPE) = COMMON_POINT;
         GridInfo(x, y, 3, GRID_INDEX_ISFREE) = BLOCKED_ZONE;
 end
end

% 设置二楼数据
 Specials = [4.75, -7.75, 8.75, 7.75;
                       0, 7.75, 8.75, 11.75;
                       0, -11.75, 8.75, -7.75;];
 for i = 1 : size(Specials, 1)
     for j = 1 : ALL_FLOOR_LEFT
         x1 = Specials(i, 1);
         y1 = Specials(i, 2) ;
         x4 = Specials(i, 3);
         y4 = Specials(i, 4);
         if j == ALL_FLOOR_LEFT
            x1 = -x4;
            x4 = -x1;      
         end
         
          % 对可通行通道直接赋值即可 
         for x = max(1, changeToGrid(x1, TYPE_X))  :  changeToGrid(x4, TYPE_X) 
            for y = changeToGrid(y1, TYPE_Y)  : changeToGrid(y4, TYPE_Y)
                  GridInfo(x, y, 3, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
                  GridInfo(x, y, 3, GRID_INDEX_TYPE) = COMMON_POINT;
             end
         end
     end
 end

entranceIndex = [0, 0, z_max - 1];
EntranceGrid = [changeToGrid(entranceIndex(1) , TYPE_X), changeToGrid(entranceIndex(2) , TYPE_Y), entranceIndex(3)];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
% 测试


%% ============== 设置楼梯通道 =====================%
Stairs = [27.25, -11.75, 33.75, -2;
                  73.25, 0, 80.75, 5.75;
                  105.25, 22.25, 110.75, 30;
                  105, -24, 110.75, 16.25;];
              
 prefered_size = 0;
 for i = 1 : size(Stairs, 1)
     for j = 1 : ALL_FLOOR_LEFT
         x1 = Stairs(i, 1);
         y1 = Stairs(i, 2) ;
         x4 = Stairs(i, 3);
         y4 = Stairs(i, 4);
         if j == ALL_FLOOR_LEFT
            x1 = -x4;
            x4 = -x1;      
         end
         % 对可通行通道直接赋值即可 
         for x = max(1, changeToGrid(x1, TYPE_X))  :  changeToGrid(x4, TYPE_X) 
              for y = changeToGrid(y1, TYPE_Y)  : changeToGrid(y4, TYPE_Y)
                  for z = 1 : z_max -1
                     GridInfo(x, y, z, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
                     GridInfo(x, y, z, GRID_INDEX_TYPE) = STAIRCASE_POINT;
                 end
             end
         end
         
         % 设置楼梯通道PreferGrids用以全局引导
         stair_x = changeToGrid((x1 + x4) / 2, TYPE_X);
         stair_y = changeToGrid((y1 + y4) / 2, TYPE_Y);
         for z = 1 : z_max - 1
             prefered_size = prefered_size + 1;
             PreferedGrids(prefered_size, 1) =  stair_x;
             PreferedGrids(prefered_size, 2) =  stair_y;
             PreferedGrids(prefered_size, 3) =  z;
         end
     end
     
 end 
 
%% ============== 设置火灾参数 ===================== %
FireGrids = [8, 4, 9;
                         12, 26, 15]; % 着火点位置

%% ========= =====设置出口点,设置入口点 ================%
% entranceIndex = [0, 0, z_max - 1];
entranceIndex = [80, 34, z_max - 1];
EntranceGrid = [changeToGrid(entranceIndex(1) , TYPE_X), changeToGrid(entranceIndex(2) , TYPE_Y), entranceIndex(3)];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;

% % 测试
% test_interval = 4;
% fprintf('center == (%d, %d, %d) == %d  \n ', EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE));
% for x = changeToGrid(entranceIndex(1) , TYPE_X) - test_interval : changeToGrid(entranceIndex(1) , TYPE_X) + test_interval
%     for y = changeToGrid(entranceIndex(2) , TYPE_Y) - test_interval : changeToGrid(entranceIndex(2) , TYPE_Y) + test_interval
%         fprintf('(%d, %d, %d) == %d   ', x, y, EntranceGrid(3), GridInfo(x, y, EntranceGrid(3), GRID_INDEX_ISFREE));
%     end
%        fprintf('\n');
% end
% test_interval = 30;
% x1 = 123;
% y1 = 80;
% for x =x1 - test_interval : x1+ test_interval
%     for y = y1 - test_interval :y1 + test_interval
%         fprintf('(%d, %d, 1) == %d   ', x, y,  GridInfo(x, y, 1, GRID_INDEX_ISFREE));
%     end
%        fprintf('\n');
% end

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

fprintf('Data Builded');



