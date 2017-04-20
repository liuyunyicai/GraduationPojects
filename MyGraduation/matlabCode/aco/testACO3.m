 run('BuildingData');
%% =============== 设置蚁群算法相关系数 ================== %%
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

GridParameters = [1 1 1]; % 栅格法建模相关参数
%% ====================== 设置优化策略 ============== %% 
OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
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

%======================== 进行测试 =======================%
% 需要记录的数据有
% 10次的运行时间T(10)，计算平均运算时间t
% 10次的最短路径长度Length（10），计算最短长度与平均长度
% 收敛速度
Nmax = 4; % 指测试的次数
Time = zeros(Nmax);  % 算法运行时间
Length = zeros(Nmax); % 最短路径

grid_size = x_max *  y_max * z_max;
max_step = round(grid_size ^ 0.62);
BestRoutes = zeros(Nmax, 1, max_step + 1, 3);




