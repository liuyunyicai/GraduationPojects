%% ====================== ��mat�ļ��е������ݵ�GridInfo�����У�������¥��ͨ���������ͨ��λ�� =====================%%
% ����
run('ConstantValues');
run('NanyiConstant');

% ��ȡ����
load('GridInfo.mat');

x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

%% ============== ����¥��ͨ�� =====================%
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
         
         % ����¥��ͨ��PreferGrids����ȫ������
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
 
%% ============== ���û��ֲ��� ===================== %
FireGrids = [8, 4, 9;
                         12, 26, 15]; % �Ż��λ��

%% ========= =====���ó��ڵ�,������ڵ� ================%
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