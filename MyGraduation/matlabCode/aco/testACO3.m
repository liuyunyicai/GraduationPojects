 run('BuildingData');
%% =============== ������Ⱥ�㷨���ϵ�� ================== %%
% cycle_max = 1;
% ant_num = 50;
cycle_max = 15;
ant_num = 20;

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
% OptimizeTypes(OPTIMIZE_7) = 1;
% OptimizeTypes(OPTIMIZE_1) = 1;
% OptimizeTypes(OPTIMIZE_3) = 1;
% OptimizeTypes(OPTIMIZE_4) = 1;
% OptimizeTypes(OPTIMIZE_2) = 1;
% OptimizeTypes(OPTIMIZE_8) = 1;
% OptimizeTypes(OPTIMIZE_FIRE) = 1;
% OptimizeTypes(OPTIMIZE_FIRE1) = 1;
% OptimizeTypes(OPTIMIZE_FIRE2) = 1;
% OptimizeTypes(OPTIMIZE_FIRE3) = 1;

FireParameters = [5 0];

%======================== ���в��� =======================%
% ��Ҫ��¼��������
% 10�ε�����ʱ��T(10)������ƽ������ʱ��t
% 10�ε����·������Length��10����������̳�����ƽ������
% �����ٶ�
Nmax = 4; % ָ���ԵĴ���
Time = zeros(Nmax);  % �㷨����ʱ��
Length = zeros(Nmax); % ���·��

grid_size = x_max *  y_max * z_max;
max_step = round(grid_size ^ 0.62);
BestRoutes = zeros(Nmax, 1, max_step + 1, 3);




