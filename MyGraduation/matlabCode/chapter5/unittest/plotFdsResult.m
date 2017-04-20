%%% ================= 绘制FDS仿真结果曲线 ========== %% 
run('ConstantValues');

% % 取点的位置
% x_index = 13;
% y_index = 23;
% z_index = 1;

%% 绘制温度曲线
% Data = load('TestFDSInfo.mat');
Data = load('AllFdsInfo.mat');
GridInfos = Data.GridInfos;

time_max = size(GridInfos, 1);
x_max = size(GridInfos, 2);
y_max = size(GridInfos, 3);
z_max = size(GridInfos, 4);


Theory_Temperature = zeros(time_max);
Theory_Smoke = zeros(time_max); 
Theory_QCO2= zeros(time_max);
Theory_QCO= zeros(time_max);
Theory_QO2 = zeros(time_max);

for i = 1 : time_max 
    Theory_Temperature(i) = GridInfos(i, x_index, y_index, z_index, GRID_INDEX_TEMPERATURE);
    Theory_Smoke(i) = 1-  GridInfos(i, x_index, y_index, z_index, GRID_INDEX_SMOKE);
    Theory_QCO2(i) = GridInfos(i, x_index, y_index, z_index, GRID_INDEX_CO2);
    Theory_QCO(i) = GridInfos(i, x_index, y_index, z_index, GRID_INDEX_CO);
    Theory_QO2(i) = GridInfos(i, x_index, y_index, z_index, GRID_INDEX_O2);
end

warning_time = 10; 
firenum = size(FireGrids, 1);
fire_x = FireGrids(firenum, 1);
fire_y = FireGrids(firenum, 2);
fire_z = FireGrids(firenum, 3);
Q = 1-  GridInfos(warning_time, fire_x, fire_y, fire_z, GRID_INDEX_SMOKE);
Q_CO2 = GridInfos(warning_time, fire_x, fire_y, fire_z, GRID_INDEX_CO2);
Q_CO = GridInfos(warning_time, fire_x, fire_y, fire_z, GRID_INDEX_CO);
Q_O2 = GridInfos(warning_time, fire_x, fire_y, fire_z, GRID_INDEX_O2);
% %% 绘制温度曲线
% figure;
% plot(Theory_Temperature, 'r');
% title('温度');
% ylabel('温度/度');
% xlabel('时间/s');
% 
% % %% 绘制烟气浓度曲线
% figure;
% plot(Theory_Smoke, 'r');
% title('烟气浓度');
% ylabel('烟气浓度/');
% xlabel('时间/s');
% 
% %% 绘制温度曲线
% figure;
% plot(Theory_QCO2, 'r');
% title('CO2浓度');
% ylabel('CO2浓度');
% xlabel('时间/s');
% 
% %% 绘制温度曲线
% figure;
% plot(Theory_QCO, 'r');
% title('CO浓度');
% ylabel('CO浓度');
% xlabel('时间/s');
% 
% %% 绘制温度曲线
% figure;
% plot(Theory_QO2, 'r');
% title('O2浓度');
% ylabel('O2浓度');
% xlabel('时间/s');
save('Theory2.mat', 'Theory_Temperature');
