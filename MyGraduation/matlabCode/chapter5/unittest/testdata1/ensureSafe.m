%% ===================== 测试最终的路径是否安全 ============== %%
clear;
run('ConstantValues');

AllData = load('AllFdsInfo.mat'); % 读取FDS仿真数据文件

GridInfos = AllData.GridInfos;

Data =  load('ResultData_P5_1.mat');
grid = Data.a;
x_max = size(grid, 1);
y_max = size(grid, 2);
z_max = size(grid, 3);

BestRoutes = Data.BestRoutes;

Length = Data.Length;
minLength = min(Length);
minIndexs = find(Length == minLength(1));
minIndex = minIndexs(1);

n = size(BestRoutes, 3);
warning_time = 1;
Time = warning_time;
v0 = 1.33;

num = size(GridInfos, 1);
num1 = size(GridInfos, 2);
num2 = size(GridInfos, 3);
num3 = size(GridInfos, 4);
num4 = size(GridInfos, 5);

data_length = 9;
data_size = 0;
% EnsureDatas = zeros(n - 1, data_length);

for i = 1 : (n - 1)
    % 读取每一步的位置
    RouteStep(1, :) = BestRoutes(minIndex, 1, i + 1, :);
    PreStep(1, :) = BestRoutes(minIndex, 1, i, :);
    
    x = RouteStep(1);
    y = RouteStep(2);
    z = RouteStep(3);
    
    pre_x = PreStep(1);
    pre_y = PreStep(2);
    pre_z = PreStep(3) ;
    
    dis = (x - pre_x) ^ 2 + (y - pre_y) ^ 2 + ((z - pre_z) * 2) ^ 2 ;
    dis = dis ^ 0.5;
    
    if (RouteStep(1, :) ~= [0, 0, 0]) 
%             fprintf('(%d, %d, %d)\n', RouteStep(1), RouteStep(2), RouteStep(3));
            
            Easy = 1;
             % 读取相关火场参数
             cur_time = round(Time);
%              pre_z = round((pre_z + 1) / 2);
            T              = GridInfos(cur_time, pre_x, pre_y, pre_z, GRID_INDEX_TEMPERATURE);
            Smoke  = 1 -  GridInfos(cur_time, pre_x, pre_y, pre_z, GRID_INDEX_SMOKE);
            Q_CO2 = GridInfos(cur_time, pre_x, pre_y, pre_z,GRID_INDEX_O2);
            Q_CO    = GridInfos(cur_time, pre_x, pre_y, pre_z, GRID_INDEX_CO);
            Q_O2    = GridInfos(cur_time, pre_x, pre_y, pre_z, GRID_INDEX_CO2);
            
            % 人流密度的影响
            p = 0;
            a =rand;
            if (a >= 0.75)
                p = 0.2;
            elseif (a >= 0.5)
                p = 0.1;
            end
             v3 = (112 * (p ^ 4) - 380 * (p ^ 3) + 434 * (p ^ 2) - 217 * p + 57) / 60;
             v3 = (1.49 - 0.36 * p) * v3 * v0;
             v_base = v3;

             Tc1 = 30;
             Tc2 = 60; % 对人体产生危害温度
             Td = DEATH_TEMPERATURE * SEARCH_DEATH_PARAM; % 致人死亡温度
             vmax = 3.0; % 正常情况下的最大疏散速度
             Easy1 = 1;% 该温度下的通行难易系数															 
             easy_gama1 = 1; % 温度通行难易系数影响因子
             if (T >= Tc1) && (T < Tc2)
                Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / ((Tc2 - Tc1) ^ 2)) + v0);
             elseif (T >= Tc2) && (T < Td)
                Easy1 = (1.2 / vmax) * (1 - ((T - Tc2) / (Td - Tc2)) ^ 2);
             elseif T >= Td  
                Easy1 = 0;
             end
             
             vk = 0.706 + (-0.057) * 0.248 * (Smoke  ^ 1); % 消光系数与逃生速度公式(C为百分比)
             Easy2 = vk / v0;  % 烟气浓度影响下的通行难易系数
             
             easy_value = max(Easy1, Easy2);
             v = v_base * easy_value;
             
             Time = Time + dis / v;
             
            cur_time = round(Time);
%             z = round((z + 1) / 2);
            T              = GridInfos(cur_time, x, y, z, GRID_INDEX_TEMPERATURE);
            Smoke  = 1 - GridInfos(cur_time, x, y, z, GRID_INDEX_SMOKE);
            Q_CO2 = GridInfos(cur_time, x, y, z,GRID_INDEX_CO2);
            Q_CO    = GridInfos(cur_time, x, y, z, GRID_INDEX_CO);
            Q_O2    = GridInfos(cur_time, x, y, z, GRID_INDEX_O2);
             
             fprintf('(%d, %d, %d), Time = %d, T=%d, Smoke = %d, CO2 = %d, CO = %d, O2 = %d, people = %d\n', RouteStep(1), RouteStep(2), RouteStep(3) ...
                          , Time, T, Smoke, Q_CO2, Q_CO, Q_O2, p * 10);
             data_size = data_size + 1;
            EnsureDatas(data_size, :) = [RouteStep(1), RouteStep(2), RouteStep(3),  Time, T, Smoke, Q_CO2, Q_CO, Q_O2, p * 10];
    end
end

save('EnsureDatas.mat', 'EnsureDatas');
xlswrite('EnsureDatas.xlsx', EnsureDatas);