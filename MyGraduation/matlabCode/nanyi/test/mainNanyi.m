%%============================ ������һ¥��ɢ����ϵͳ�����main�ļ� =====================%%

run('ReadNanyiData');

%% =============== ������Ⱥ�㷨���ϵ�� ================== %%
% cycle_max = 1;
% ant_num = 50;
cycle_max = 20;
ant_num = 50;

% cycle_max = 1;
% ant_num = 1;

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
max_step = round(grid_size ^ 0.6);
BestRoutes = zeros(Nmax, 1, max_step + 1, 3);

for N = 1 : Nmax
    fprintf('\n%d Test Start\n', N);
    t1 = clock;
    [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length, AntArriveTimes] = ACO5(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters, max_step, PreferedGrids);
    t2 = clock;
    Time(N) = etime(t2,t1);
    Length(N) = best_length;
    BestRoutes(N, :) = BestRoute(:);
    AllAntArriveTimes(N, :) = AntArriveTimes(:);
end

%% ============== ���������������ó��Ľ�� ================= %%
minLength = min(Length);
minIndex = find(Length == minLength(1));
% ����·������
a = zeros(x_max, y_max, z_max);
for z = 1 : z_max
    for x = 1 : x_max
        for y = 1 : y_max
            a(x, y, z) = GridInfo(x, y, z, 2);
        end
    end
end

% GreedySearch(GridInfo, EntranceGrid, ExitGrids);

%% ======= �������Ϣ��������ݿ��й���������ȡ�����͸��ͻ��� ============= %%
run('OutputRouteIntoDb');
