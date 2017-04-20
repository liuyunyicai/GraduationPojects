run('BuildingInitiation');
%% =============== ������Ⱥ�㷨���ϵ�� ================== %%
cycle_max =20;
ant_num = 30;
% cycle_max = 15;
% ant_num = 20;

Alpha = 1.0;
Beta = 1.0;
Rho = 0.5;
Q = 10;
AcoParameters = [Alpha, Beta, Rho, Q];

GridParameters = [1 1 1]; % դ�񷨽�ģ��ز���
%% ====================== �����Ż����� ============== %% 
OptimizeTypes = zeros(1, OPTIMIZE_ALL); % �Ż�����
OptimizeTypes(OPTIMIZE_7) = 1;
OptimizeTypes(OPTIMIZE_1) = 1;
OptimizeTypes(OPTIMIZE_3) = 1;
OptimizeTypes(OPTIMIZE_4) = 1;
OptimizeTypes(OPTIMIZE_2) = 1;
OptimizeTypes(OPTIMIZE_8) = 1;
OptimizeTypes(OPTIMIZE_9) = 1;
OptimizeTypes(OPTIMIZE_10) = 1;
OptimizeTypes(OPTIMIZE_FIRE) = 1;
OptimizeTypes(OPTIMIZE_FIRE1) = 1;
OptimizeTypes(OPTIMIZE_FIRE2) = 1;
OptimizeTypes(OPTIMIZE_FIRE3) = 1;

FireParameters = [5 0];

%======================== ���в��� =======================%
% ��Ҫ��¼��������
% 10�ε�����ʱ��T(10)������ƽ������ʱ��t
% 10�ε����·������Length��10����������̳�����ƽ������
% �����ٶ�
Nmax = 1; % ָ���ԵĴ���
Time = zeros(Nmax);  % �㷨����ʱ��
Length = zeros(Nmax); % ���·��

grid_size = x_max *  y_max * z_max;
max_step = round(grid_size ^ 0.62);
BestRoutes = zeros(Nmax, 1, max_step + 1, 3);

for N = 1 : Nmax
    fprintf('\n%d Test Start\n', N);
    t1 = clock;
    [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length, AntArriveTimes] = ACO5(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, ...
        AcoParameters, GridParameters, OptimizeTypes, FireParameters, max_step, PreferedGrids, SpecialNodes);
    t2 = clock;
    Time(N) = etime(t2,t1);
    Length(N) = best_length;
    BestRoutes(N, :) = BestRoute(:);
%     AllAntArriveTimes(N, :) = AntArriveTimes(:);
end

%% ============== ���������������ó��Ľ�� ================= %%
minLength = min(Length);
minIndex = find(Length == minLength(1));

fire_zone_num = 0;
danger_zone_num = 0;
crowed_zone_num = 0;

for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            T = GridInfo(x, y, z, GRID_INDEX_TEMPERATURE) ;
            C_O2 = GridInfo(x, y, z, GRID_INDEX_O2) * 100;   % ����Ũ��
            C_CO = GridInfo(x, y, z, GRID_INDEX_CO) * 100 * 1000;   % һ����̼Ũ��(ppm)
            C_CO2 = GridInfo(x, y, z, GRID_INDEX_CO2) * 100; % ������̼Ũ��
            
            if (GridInfo(x, y, z, GRID_INDEX_ISFREE) == ISACCESSED_ZONE) &&((T >= DEATH_TEMPERATURE * WARNING_DEATH_PARAM) ...
                    || ((C_O2 > 0) &&(C_O2 <= DEATH_O2/ WARNING_DEATH_PARAM)) || (C_CO >= DEATH_CO* WARNING_DEATH_PARAM) || (C_CO2 >= DEATH_CO2* WARNING_DEATH_PARAM)) 
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = DANGER_ZONE;
                
                danger_zone_num = danger_zone_num + 1;
                DangerZone(danger_zone_num, :) = [x, y, z]; 
            end
            
            if (GridInfo(x, y, z, GRID_INDEX_ISFREE) == FIRED_ZONE)
                
                fire_zone_num = fire_zone_num + 1;
                FiredZone(fire_zone_num, :) = [x, y, z]; 
            end
            
            % ӵ������
            if (GridInfo(x, y, z, GRID_INDEX_ISFREE) ==CROWED_ZONE)                 
                crowed_zone_num = crowed_zone_num + 1;
                CrowedZone(crowed_zone_num, :) = [x, y, z]; 
            end
            
        end
    end
end


% ����·������
a = zeros(x_max, y_max, z_max);
for z = 1 : z_max
    for x = 1 : x_max
        for y = 1 : y_max
            a(x, y, z) = GridInfo(x, y, z, 2);
        end
    end
end

Label = 'P4_1';
filename = sprintf('ResultData_%s.mat', Label);
save(filename, 'a', 'GridInfo', 'BestRoutes','CycleLength', 'CycleMean', 'Time', 'Length', 'PreferedGrids', 'AntArriveTimes');

% �����ݲ��뵽���ݿ�
if fire_zone_num > 0
    InitDataIntoDb(FiredZone, TABLE_FIRE_INFO);
end

if danger_zone_num > 0
    InitDataIntoDb(DangerZone, TABLE_DANGER_INFO);
end

if crowed_zone_num > 0
    InitDataIntoDb(CrowedZone, TABLE_CROWED_INFO);
end

%% ======= �������Ϣ��������ݿ��й���������ȡ�����͸��ͻ��� ============= %%
run('OutputRouteIntoDb');


