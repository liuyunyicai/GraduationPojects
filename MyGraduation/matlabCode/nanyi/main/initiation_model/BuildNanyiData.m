%% =================== 初始化南一楼的相关信息 ============== %%

% 常量
run('ConstantValues');
run('NanyiConstant');

x_max = (x_miles_max - x_miles_min) / x_step ;
y_max = (y_miles_max - y_miles_min) / y_step;
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
Corridors = [0, -2, 33, 2;     % 八层中间区域
                        33, -2, 51, 2;    % 六层区域
                        51, -2, 69, 2;    % 四层区域
                 69, -24, 73, 30;      
                 69, 30, 123, 34;
                 69, -28, 123, -24]; % 一个矩形通道只需要记录其起始斜角对应的坐标位置即可，即一组数据的值记录的为[x1, y1, x4, y4]；


 for i = 1 : size(Corridors, 1)
     for j = 1 : ALL_FLOOR_LEFT       
         if j == ALL_FLOOR_RIGHT
            x1 = Corridors(i, 1);
            x4 = Corridors(i, 3);  
         else
            x4 = -Corridors(i, 1);
            x1 = -Corridors(i, 3);  
         end             
          y1 = Corridors(i, 2);
         y4 = Corridors(i, 4);  
         
         % 对可通行通道直接赋值即可 
         GridScale = getGridScale(x1, x4, y1, y4);
         
         for x = GridScale(1)  :  GridScale(2)
             for y = GridScale(3)  : GridScale(4)
                 for z = 1 : z_max / 2
                     if (i == 1) || ((i == 2) &&(z <= 6) || ((i == 3) && (z <=4)) || ((i == 4) && (z <= 4 )) || (((i == 5) || (i == 6)) && (z <= 5)) )
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
GridScale = getGridScale(x1, x4, y1, y4);

for x = GridScale(1)  :  GridScale(2)
 for y = GridScale(3)  : GridScale(4)
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
          if j == ALL_FLOOR_RIGHT
            x1 = Specials(i, 1);
            x4 = Specials(i, 3);  
         else
            x4 = -Specials(i, 1);
            x1 = -Specials(i, 3);  
         end             
          y1 = Specials(i, 2);
          y4 = Specials(i, 4);  
         
         GridScale = getGridScale(x1, x4, y1, y4);
          % 对可通行通道直接赋值即可 
         for x = GridScale(1)  :  GridScale(2)
             for y = GridScale(3)  : GridScale(4)
                  GridInfo(x, y, 3, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
                  GridInfo(x, y, 3, GRID_INDEX_TYPE) = COMMON_POINT;
             end
         end
     end
 end



%% ============== 设置楼梯通道 =====================%
Stairs = [27.25, -11.75, 33.75, -2;         % 中一楼道（八层）
                  73.25, 0, 80.75, 5.75;               % 右中楼道（四层）
                  105.25, 22.25, 110.75, 30;    % 右右楼道（四层）
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
         % 对可通行通道直接赋值即可 
         GridScale = getGridScale(x1, x4, y1, y4);

         for x = GridScale(1)  :  GridScale(2)
             for y = GridScale(3)  : GridScale(4)
                  for z = 1 : z_max -1
                      if (i == 1) || ((i == 2) && (z <= 4 * 2 - 1)) || (((i == 3) || (i == 4)) && (z <= 5 * 2 - 1))
                         GridInfo(x, y, z, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
                         GridInfo(x, y, z, GRID_INDEX_TYPE) = STAIRCASE_POINT;
                      end
                 end
             end
         end
         
%          % 设置楼梯通道PreferGrids用以全局引导
%          stair_x = changeToGrid((x1 + x4) / 2, TYPE_X);
%          stair_y = changeToGrid((y1 + y4) / 2, TYPE_Y);
%          for z = 1 : z_max - 1
%              prefered_size = prefered_size + 1;
%              PreferedGrids(prefered_size, 1) =  stair_x;
%              PreferedGrids(prefered_size, 2) =  stair_y;
%              PreferedGrids(prefered_size, 3) =  z;
%          end
     end
     
 end 
 
%% ============== 设置火灾参数 ===================== %
% FireGrids = [8, 4, 9;
%                          12, 26, 15]; % 着火点位置

%% ========= =====设置出口点,设置入口点 ================%
% entranceIndex = [0, 0, z_max - 1];
% entranceIndex = [80, 34, z_max - 1];
% EntranceGrid = [changeToGrid(entranceIndex(1) , TYPE_X), changeToGrid(entranceIndex(2) , TYPE_Y), entranceIndex(3)];
% GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;


% exitIndex = [0, -12, 1;
%                          81, 3, 1;
%                         -81, 3, 1];
% ExitGrids = zeros(size(exitIndex, 1), 3);
% 
% n = size(ExitGrids, 1);
% for k = 1 : n
%     ExitGrids(k, 1) = changeToGrid(exitIndex(k, 1) , TYPE_X);
%     ExitGrids(k, 2) = changeToGrid(exitIndex(k, 2) , TYPE_Y);
%     ExitGrids(k, 3) = 1;
%     
%     GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
% end

fprintf('Data Builded');



