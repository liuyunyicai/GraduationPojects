%% =========== 进行蚁群算法开始前火灾位置，出入口位置等设置 ====================== %%

FireGrids = [10, 20, 1];

%% ================ 设置入口出口点 =====================%%
% EntranceGrid = [1, 1, z_max - 1];
% GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
% 
% ExitGrids = [ x_max, y_max, 1;];
% n = size(ExitGrids, 1);
% for k = 1 : n
%     GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
% end