%%% ================= ����FDS���������� ========== %% 
run('ConstantValues');

% % ȡ���λ��
% x_index = 13;
% y_index = 23;
% z_index = 1;

%% �����¶�����
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
% %% �����¶�����
% figure;
% plot(Theory_Temperature, 'r');
% title('�¶�');
% ylabel('�¶�/��');
% xlabel('ʱ��/s');
% 
% % %% ��������Ũ������
% figure;
% plot(Theory_Smoke, 'r');
% title('����Ũ��');
% ylabel('����Ũ��/');
% xlabel('ʱ��/s');
% 
% %% �����¶�����
% figure;
% plot(Theory_QCO2, 'r');
% title('CO2Ũ��');
% ylabel('CO2Ũ��');
% xlabel('ʱ��/s');
% 
% %% �����¶�����
% figure;
% plot(Theory_QCO, 'r');
% title('COŨ��');
% ylabel('COŨ��');
% xlabel('ʱ��/s');
% 
% %% �����¶�����
% figure;
% plot(Theory_QO2, 'r');
% title('O2Ũ��');
% ylabel('O2Ũ��');
% xlabel('ʱ��/s');
save('Theory2.mat', 'Theory_Temperature');
