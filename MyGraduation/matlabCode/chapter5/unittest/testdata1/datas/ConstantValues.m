% 优化策略类型
OPTIMIZE_FIRE = 11; % 将火场参数信息引入进来
OPTIMIZE_FIRE1 = 12; % 将火场参数信息引入进来
OPTIMIZE_FIRE2 = 13; % 将火场参数信息引入进来
OPTIMIZE_FIRE3 = 14; % 将火场参数信息引入进来
OPTIMIZE_ALL = 15;  % 选用所有优化策略
OPTIMIZE_10 = 10; % 采用原始的蚁群算法
OPTIMIZE_1 = 1;     % 采用单项的优化策略
OPTIMIZE_2 = 2;
OPTIMIZE_3 = 3;
OPTIMIZE_4 = 4;
OPTIMIZE_5 = 5;
OPTIMIZE_6 = 6;
OPTIMIZE_7 = 7;
OPTIMIZE_8 = 8;
OPTIMIZE_9 = 9;
% GridInfo中相关参数的位置
GRID_INDEX_TYPE        = 1;
GRID_INDEX_ISFREE      = 2;
GRID_INDEX_TEMPERATURE = 3;
GRID_INDEX_SMOKE       = 4;
GRID_INDEX_O2          = 5;
GRID_INDEX_CO          = 6;
GRID_INDEX_CO2         = 7;
GRID_INDEX_PEOPLENUM   = 8;

% 出口类型
EXIT_POINT      = 2 ^ 0;   %(出口)
COMMON_POINT    = 2 ^ 1;   %(普通通道)
DOOR_POINT      = 2 ^ 2;   %(通道口)
ELEVATOR_POINT  = 2 ^ 3;   %(电梯口)
STAIRCASE_POINT = 2 ^ 4;   %(楼梯口)
FIREHYDRANT_POINT = 2 ^ 5; %(消防栓) 

% 表征楼梯能够前进的方向
STAIR_UP = 1;  % 可上行
STAIR_DOWN = 2; % 可下行
STAIR_IP_DOWN = 0; % 可上下通行

% 表征障碍物性质
ISACCESSED_ZONE = 1; % 可通行
BLOCKED_ZONE = 2;      % 有障碍物阻挡
FIRED_ZONE = 0;%火灾死亡区域

% 火场各因素的最大值大小
DEATH_TEMPERATURE = 120; % 死亡温度120度
DEATH_O2 = 10;
DEATH_CO = 100;
DEATH_CO2 = 10;
DEATH_PEOPLE_NUM = 1.5;

%DATA数据中每项数据对应的位置
DATA_ROW_X = 1;
DATA_ROW_Y = 2;
DATA_ROW_Z = 3;
DATA_ROW_TEMPER =4;
DATA_ROW_SMOKE = 5;
DATA_ROW_CO2 = 6;
DATA_ROW_CO = 7;
DATA_ROW_O2= 8;