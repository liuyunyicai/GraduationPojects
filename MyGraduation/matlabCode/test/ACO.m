function [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length]=ACO(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters)
%%  入参：
%      GridInfo: 栅格中每一个点的信息矩阵
%%  GridInfo的矩阵格式：x_max*y_max*z_max*10  
%        grid_type节点的类型：EXIT_POINT      = 1 << 0;  (出口)
%                      ENTRANCE_POINT  = 1 << 1;  (入口)
%                      DOOR_POINT      = 1 << 2;  (通道口)
%                      ELEVATOR_POINT  = 1 << 3;  (电梯口)
%                      STAIRCASE_POINT = 1 << 4;  (楼梯口)
%                      FIREHYDRANT_POINT = 1 << 5; (消防栓)     
%        grid_isfree是否可通行：IS_ACCESS       = 0 / 1;   (即是否为障碍物，0 位障碍物)
%%      其他相关火灾信息：
%        grid_temperature 栅格温度大小
%        grid_somke       栅格烟气浓度
%        grid_O2          栅格氧气浓度
%        grid_CO          栅格CO浓度
%        grid_CO2         栅格CO2浓度
%        grid_peoplenum   栅格人员个数
%        保留位两位
%     
%% EntranceGrid : 入口坐标 (1 * 3矩阵)
%% ExitGrids: （m * 3矩阵）
%          和前面相同，是以“空间换时间”；因为出口不止一个，三维情况下还涉及多个楼层，因而，这里是一个矩阵，矩阵里面包含的所有出口的集合

%           矩阵为1*3矩阵，包含信息即入口Grid的x, y, z坐标值
%% FireGrids: (m * 3矩阵)
% 起火点位置集合，因为起火点可能不止一个，因此需要一个矩阵
%% cycle_max: 蚁群算法循环迭代的最高次数
%% ant_num :  蚂蚁的个数
%% AcoParameters : 蚁群算法的相关参数矩阵
%           Alpha: 信息素启发因子，表示信息素的重要性，反应蚂蚁之间的协作程度；
%           Beta   : 期望启发因子，表示启发信息（路径的长度）的重要性。
%           Rho  ：信息素挥发因子
%           Q        :  信息素增加强度，为常数，其值会影响算法的收敛速度。
%% GridParameters: 栅格法的相关参数
%  interval_x X轴方向上栅格法的单位间距，单位m 
%  interval_y
%  interval_z
%% OptimizeTypes: 是否为原始的蚁群算法，为1则为是，则所有的优化策略全部不考虑
%% FireParameters: Fire火灾的相关参数
%  warning_time: 火灾报警时火灾发生的时间

% ======================= 常用常量值 ============================ %
% GridInfo中相关参数的位置
GRID_INDEX_TYPE        = 1;
GRID_INDEX_ISFREE      = 2;
GRID_INDEX_TEMPERATURE = 3;
GRID_INDEX_SMOKE       = 4;
GRID_INDEX_O2          = 5;
GRID_INDEX_CO          = 6;
GRID_INDEX_CO2         = 7;
GRID_INDEX_PEOPLENUM   = 8;

EXIT_POINT      = 2 ^ 0;   %(出口)
COMMON_POINT    = 2 ^ 1;   %(普通通道)
DOOR_POINT      = 2 ^ 2;   %(通道口)
ELEVATOR_POINT  = 2 ^ 3;   %(电梯口)
STAIRCASE_POINT = 2 ^ 4;   %(楼梯口)
FIREHYDRANT_POINT = 2 ^ 5; %(消防栓) 


% 优化策略类型
OPTIMIZE_FIRE = 11; % 将火场参数信息引入进来
OPTIMIZE_ALL = 12;  % 选用所有优化策略
OPTIMIZE_NONE = 10;      % 采用原始的蚁群算法
OPTIMIZE_1 = 1;     % 采用单项的优化策略
OPTIMIZE_2 = 2;
OPTIMIZE_3 = 3;
OPTIMIZE_4 = 4;
OPTIMIZE_5 = 5;
OPTIMIZE_6 = 6;
OPTIMIZE_7 = 7;

%% 出参：
%  CycleRoute    : 记录每次迭代中的最佳路径
%  CycleLength : 记录每次迭代中的最佳路径长度
%  CycleMean    : 记录每次迭代中的路径的平均长度
%  BestRoute      : 记录目前所有迭代中最佳的路径
%  best_length  : 记录目前所有迭代中最佳路径的长度
% 


%% =============== 第零步 解析传入的参数值，并进行相应初始化 ==================== %%      
Alpha = AcoParameters(1);
Beta  = AcoParameters(2);
Rho   = AcoParameters(3);
Q     = AcoParameters(4);

interval_x = GridParameters(1);
interval_y = GridParameters(2);
interval_z = GridParameters(3);

x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

warning_time = FireParameters(1); % 获取初始报警时刻火灾已经发展的时间
firenums = size(FireGrids, 1);    % 着火点的数目

grid_size = x_max *  y_max * z_max;  % 获取栅格的总数

max_step = grid_size; %预计使用的最多步长，超过这个值，则不对该蚂蚁的路径继续计算（以此来减少无效的时间循环）

baseinfo_num = size(GridInfo, 4);       % GridInfo中基本信息的长度

v0 = 1.33; % 人在不受干扰下的正常疏散速度

% 需要暂存的相关信息
% 信息素如何进行存储：如果采用传统的邻接矩阵的方法，需要存储n^2个元素，而且这个矩阵为稀疏矩阵，很多空间都是浪费没有必要的（因为是栅格法来划分坐标）
%                                            这里将所有节点信息都存储到一个GridInfo矩阵中，因而考虑将信息素矩阵也与其进行对应，并进行相应更新，这样也有利用二维向三维空间的转换
dimen_num = 3;                                                                  % 指蚁群算法实现的空间维度，这里是三维
adjacent_num = 3 ^ dimen_num;                                                       % 相邻的栅格的数目（二维为8，三维为26）（理论上的存储值为grid_size^2，这里进行简化，只需要存储grid_size * adjacent_num个空间大小）
Tau = ones(x_max, y_max, z_max, 3, 3, 3, 1);  % Tau为信息素矩阵，用以记录每个节点到另一个节点的路径中遗留的信息素大小

% 对于ant_num只蚂蚁，需要记录其走过的路径Route；路径的长度L(用以更新信息素) （这些都和迭代相关）
% 同时还需要在每次迭代之后，记录当前得到的最优解：即最短路径及最短路径长度
% 为了便于之后的性能分析，还应记录每次迭代中的最佳路径及其相关信息
BestRoute = zeros(1, grid_size, dimen_num);             % 记录目前所有迭代中最佳的路径
best_length = inf;                                      % 记录目前所有迭代中最佳路径的长度

CycleRoute    = zeros(cycle_max, grid_size , dimen_num); % 记录每次迭代中的最佳路径
CycleLength   = inf .* ones(cycle_max, 1);               % 记录每次迭代中的最佳路径长度
CycleMean     = zeros(cycle_max, 1);                     % 记录每次迭代中的路径的平均长度 
CycleTime     = inf .* ones(cycle_max, 1);               % 记录每次迭代中的最佳路径疏散时间
CycleTimeMean = zeros(cycle_max, 1);                     % 记录每次迭代中的路径的平均疏散时间


%%% 定义一些常用变量
 %************* 遍历邻域时的范围值 *************** %
 % 未优化之前的版本
nextval_size = 26;
Nextvals = zeros(nextval_size, 3);                              
temp_size = 1;
for next_x = -1 : 1
    for next_y = -1 : 1
        for next_z = -1 : 1
            if (next_x ~= 0) || (next_y ~= 0) || (next_z ~= 0)
                Nextvals(temp_size, :) = [next_x, next_y, next_z];
                temp_size = temp_size + 1;
            end
        end
    end
end
% disp(Nextvals);

% 优化后的邻域集合
% nextval_size = 10;
% Nextvals = zeros(nextval_size, 3);                               % 遍历邻域时的范围值
% temp_size = 1;
% for next_x = -1 : 1
%     for next_y = -1 : 1
%         for next_z = -1 : 1
%             if ( (next_z ~= 0) && (next_x == 0) && (next_y == 0)) || ((next_z == 0) && ((next_x ~= 0) || (next_y ~= 0))) 
%                 Nextvals(temp_size, :) = [next_x, next_y, next_z];
%                 temp_size = temp_size + 1;
%             end
%         end
%     end
% end
% disp(Nextvals);


%%*************************** 开始进入蚁群算法 *************************************%%
cycle_times = 1;  % 循环迭代次数
while cycle_times <= cycle_max
	% 局部变量置于此处也是为了每次迭代都进行清空（注意信息素不需要清空）
	Route = zeros(ant_num, grid_size, dimen_num);      % 记录每只蚂蚁走过的路径 (乘以dimen_num是记录每个栅格的x,y,z坐标)
	L = zeros(ant_num, 1);                             % 记录每只蚂蚁走过的路径步长（区别于真是路径长度），用以更新信息素大小
	Eta = zeros(ant_num, x_max, y_max, z_max, 3, 3, 3, 1);  % 注意这里考虑火灾场景中的动态因素变化，这里计算得到的所有节点的Eta值，和特定的蚂蚁相关。Eta为启发因子，即根据距离向量，火灾因素等计算出的相关系数（注意这里和网络拓扑中权值的区别，两者可类比为倒数的关系）
	
	Inspires = zeros(ant_num, x_max, y_max, z_max, 3, 3, 3, 1);% 蚁群算法中的启发因子（考虑火场影响因素）
	EqualLength = zeros(ant_num, 1);                   % 记录每一只蚂蚁的等效疏散长度（用以更新信息素大小）
	Time = zeros(ant_num, 1);                          % 记录每只蚂蚁的疏散时间（用以更新火场因素，同时统计路疏散时间）
   
   %% ====== 第一步 初始化蚂蚁的位置，这里将蚂蚁的位置至于何处有待商榷，最初做法为将所有蚂蚁放在出口处；（对于优化时，可以考虑将蚂蚁放在入口点，及出口点）
   for i = 1 : ant_num
		Route(i, 1, :) =  EntranceGrid;
		L(i) = 1;
   end
   
   % 这里设置一个标志，如果所有蚂蚁都已到达终点，或者进入死胡同，则蚂蚁不会再移动
   is_moved = 1;
   
   %% ====== 第二步 按照转移概率确定蚂蚁下一步移动的位置 =========== %%
%            count = 0;
   for  i = 1 : max_step                          % 先暂时不考虑进入死胡同的情况，即将Route当做禁忌表，一旦蚂蚁走过该点，就不允许再次重走该点
	   if is_moved == 1 
		   is_moved = -1;  
							 
		   for j = 1 : ant_num                   % 对每只蚂蚁进行操作 
			   CurGrid_pos = Route(j, L(j), :);  % 这里是记录在Route中当前位置的坐标矩阵
												 % 获取当前节点，然后计算从当前节点相关联的adjacent_num个节点的转移概率，注意这里禁忌表中转移概率即为0
												 % 即下一个转移节点即为与当前节点相关的adjacent_num个节点的其中之一
			   
				if CurGrid_pos(1) ~= -1      % -1表示该蚂蚁进入了死胡同，这里现将该情况剔除
					%  *********** 首先判断是否达到终点 ************** %
					is_exited = -1;
					exit_num = size(ExitGrids, 1);
					for k = 1 :  exit_num
					   exitGrid(1, 1, :) = ExitGrids(k, :);
					   if  CurGrid_pos == exitGrid % 表示已经到达终点
						   is_exited = 1;
					   end
					end
				   
					% ************ 如果未达到终点，则进行转移 ************** %
					if is_exited == -1 % 表示到达未出口，需要继续执行往下循环
						% ======= 计算到下一个节点的转移概率 ======= % （这里Route即相当于禁忌表）                                          
						x = CurGrid_pos(1);
						y = CurGrid_pos(2);
						z = CurGrid_pos(3);                
						
						% 遍历该节点相邻的相关点                               
						P = zeros(3, 3, 3, 1);       % 从远点到n个城市的转移矩阵，这里全部初始化为0（注意这里保留了当前点，在统计时，应注意去除）
						Fijs = zeros(3, 3, 3, 1);    % 用以暂存人工势场力
						TempTimes = zeros(3, 3, 3, 1); % 用以暂存通过该转移路径所需要的疏散时间
		
                        
                        for temp_size = 1 : nextval_size
							nextval_x = Nextvals(temp_size, 1);
							nextval_y = Nextvals(temp_size, 2);
							nextval_z = Nextvals(temp_size, 3);
							
							if  [nextval_x nextval_y nextval_z] == [0 0 0] % 原点情况抛除
								P(nextval_x + 2,nextval_y + 2, nextval_z + 2) = 0;
							else
								next_x = x + nextval_x;
								next_y = y + nextval_y;
								next_z = z + nextval_z;                                               

								if ((next_x >= 1) && (next_x <= x_max)) && ((next_y >= 1) && (next_y <= y_max)) && ((next_z >= 1) && (next_z <= z_max))                    %判断该对应点是否存在                                                                                                
									 % 计算转移概率
									 NextGridInfo(1, :) = GridInfo(next_x, next_y, next_z,  : ); % 下一栅格的相关信息
									 % 首先计算每个转移路径的启发式因素大小(这里先暂时是距离的倒数)
									 dis = (((next_x - x) * interval_x) ^ 2 + ((next_y - y) * interval_y) ^ 2 + ((next_z - z) * interval_z) ^ 2) ^ 0.5;       %% TODO:这里是火灾疏散算法需要重要研究的对象，可以加入烟雾，热量等因素的影响
																																										  %    实际的计算会使用CurGridInfo和NextGridInfo信息进行计算
									 eta = 1 / dis;  % 启发因子
									 Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1) = eta; 
%                                    disp(Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1));
									 % 取出该点对应的信息素
%                                      fprintf('current= (%d, %d, %d)\n',x, y, z);
									 tau = Tau(x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1);

									 % *************  再计算转移概率 ************ %
									 % 对于已经访问的节点，即Route矩阵中已经记录了节点，则转移概率为0，（这里只是暂时这样做，有待优化）
									 is_visited = -1; % 标志该节点是否已经访问过
									 for k = 1 : L(j)
										 visited(1, :) = Route(j, k, :);

										 if visited(1, :) == [next_x, next_y, next_z]
											 is_visited = 1;                                                             
										 end                                                      
									 end                                                    
%                                                      disp(is_visited);
									 p_value = 0;
									 if is_visited == 1    % 表示已经访问过，则转移概率为0 （这里做一处优化，为了避免蚂蚁进入死胡同，则允许蚂蚁可以访问已经访问过的节点）                                                         
%												 if (OptimizeTypes(OPTIMIZE_8) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1) 
%													 p_value = (tau ^ Alpha) * (eta ^ Beta) * 0.1;
%												 end                                                         
										 p_value = 0;
									 elseif NextGridInfo(GRID_INDEX_ISFREE) == 0  % 如果是障碍物，转移概率为0
										 p_value = 0;
									 else
										 % TODO:这里再做一次优化，因为以前的方法中，默认是蚂蚁超所有方向前进的概率是相等的，这里适当进行引导，即距离上节点越靠近出口点的，则优先进行引导
										 % 因而这里对靠近出口点的防线乘以一个引导系数

										 % TODO：测试，这里先简单尝试使用前行引导
										 p_value =  (tau ^ Alpha) * (eta ^ Beta);

										 %=============== 引入火场因素影响因子 ============= %
										 if (OptimizeTypes(OPTIMIZE_FIRE) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1) 
											 thita = 0.5; % 危险性惩罚系数
											 % 计算适应火灾场景的蚁群算法启发函数
											 Inspires(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1) = (dis / v0) ^ (thita - 1); 

											 R_total = 1;    % 用以记录危险性系数R的乘积
											 Easy_total = 1; % 用以记录通行难易系数的乘积

											 % =========== 计算火场热量的影响 ======== %
											 T = NextGridInfo(GRID_INDEX_TEMPERATURE); % 火场的温度
											 % 火场温度场随时间变化计算公式
											 t_beta = 0.003;  % 升温系数
											 t_eta = 0.8;   % 温度随距离的衰减系数
											 t_miu = 0.5;
											 cur_time = Time(j);
											 T_deta = 0;

											 for firenum = 1 : firenums
												[fire_x fire_y fire_z] = FireGrids(firenum, :); % 获取火源位置
												if fire_z == next_z % 仅考虑在同一楼层的火源影响
													% 计算火源到用户当前位置的距离
													Tz = GridInfo(fire_x, fire_y, fire_z, GRID_INDEX_TEMPERATURE) + 345 * log10(8 * cur_time / 60 + 1); % 按照最坏估计更新火源的温度值
													t_s = (((next_x - fire_x) * interval_x) ^ 2 + ((next_y - fire_y) * interval_y) ^ 2) ^ 0.5;
													temp_tdeta = Tz * (1 - 0.8 * exp(-t_beta * cur_time) - 0.2 * exp(-0.1 * t_beta * cur_time)) * (t_eta + (1 - t_eta) * exp((0.5 - t_s) / t_miu));
													if temp_tdeta > T_deta
														T_deta = temp_tdeta;
													end
												end
											 end

											 T = T + T_deta;
											 Tc = 30;  % 正常温度为30度

											 r_fai1 = 1;            % 热量危险系数影响因子
											 R1 = (T / Tc) ^ 3.61; % 温度危险系数

											 Tc1 = 30;
											 Tc2 = 60; % 对人体产生危害温度
											 Td = 120; % 致人死亡温度
											 vmax = 3.0; % 正常情况下的最大疏散速度
											 Easy1 = 1;% 该温度下的通行难易系数															 
											 easy_gama1 = 1; % 温度通行难易系数影响因子
											 if (T >= Tc1) && (T < Tc2)
												Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / (Tc2 - Tc1)) + v0);
											 elseif (T >= Tc2) && (T < Td)
												Easy1 = 1.2 / (vamx * (1 - ((T - Tc2) / (Td - Tc2))) ^ 2);
											 elseif T >= Td  
												Easy1 = 0;
											 end

											 R_total = R_total * (R1 ^ r_fai1);
											 Easy_total = Easy_total * (Easy1 ^ easy_gama1);



											 % =========== 计算烟气浓度的影响 ========= %
											 C = NextGridInfo(GRID_INDEX_SMOKE) * 100;   % 烟气浓度
											 C_O2 = NextGridInfo(GRID_INDEX_O2) * 100;   % 氧气浓度
											 C_CO = NextGridInfo(GRID_INDEX_CO) * 100 * 1000;   % 一氧化碳浓度(ppm)
											 C_CO2 = NextGridInfo(GRID_INDEX_CO2) * 100; % 二氧化碳浓度

											 % 引入烟气的扩散公式
											 k_somke = 0.9;
											 C_deta = 0;

											 for firenum = 1 : firenums
												[fire_x fire_y fire_z] = FireGrids(firenum, :); % 获取火源位置
												if fire_z == next_z % 仅考虑在同一楼层的火源影响
													% 计算火源到用户当前位置的距离
													slength = ((next_x - fire_x) * interval_x) ^ 2 + ((next_y - fire_y) * interval_y) ^ 2 + ((next_z - fire_z) * interval_z) ^ 2;
													C_deta = C_deta + (warning_time / cur_time) ^ 1.5 * exp((-slength) / (4 * k_somke * cur_time));
												end
											 end
											 C = C + C_deta; % 考虑扩散的烟气浓度随时间变化值


											 % 安全条件下的各种气体浓度
											 Csafe_O2 = 21;
											 Csafe_CO = 0.01 * 10000;
											 Csafe_CO2 = 5; % 百分比

											 % 先计算疏散速度
											 vk = 0.706 + (-0.057) * 0.248 * (C ^ 1); % 消光系数与逃生速度公式
											 Easy2 = vk / v0;  % 烟气浓度影响下的通行难易系数
											 tk = dis / vk;    % 在该烟气浓度下的通行时间

											 % 计算危险性
											 FEDco = 4.607 * (10 ^ (-7)) * (C_CO ^ 1.036) * tk;
											 FEDo2 = tk / (60 * exp(8.13- 0.54 * (20.9 - C_O2))) ;
											 HVco2 = exp(0.1930 * C_CO2 + 2.004) / 7.1; 
											 FED = FEDco * HVco2 + FEDo2; 

											 % 无危险情况下的窒息公式值
											 FEDc_co = 4.607 * (10 ^ (-7)) * (Csafe_CO ^ 1.036) * tk;
											 FEDc_o2 = tk / (60 * exp(8.13- 0.54 * (20.9 - Csafe_O2))) ;
											 HVcc_o2 = exp(0.1930 * Csafe_CO2 + 2.004) / 7.1; 
											 FEDc = FEDc_co * HVcc_o2 + FEDc_o2; 

											 % 烟气浓度下的危险程度系数 
											 R2 = FED / FEDc;

											 r_fai2 = 1;
											 easy_gama2 = 1;

											 R_total = R_total * (R2 ^ r_fai2);
											 Easy_total = Easy_total * (Easy2 ^ easy_gama2);													 

											 % ============ 计算人流密度的影响 ============ %
											 peoplenum = NextGridInfo(GRID_INDEX_PEOPLENUM); % 人流密度
											 p = peoplenum * 0.18 / (interval_x * interval_y);
											 pc = 0.92; % 无阻碍时的人流密度

											 % 获取该通道的类型
											 grid_type = NextGridInfo(GRID_INDEX_TYPE);

											 % 计算通行速度
											 v3 = (112 * (p ^ 4) - 380 * (p ^ 3) + 434 * (p ^ 2) - 217 * p + 57) / 60;
											 if grid_type == DOOR_POINT % 通过门口通道
												v3 = (1.17 + 0.13 * sin(6.03 * p - 0.12)) * v3;
											 elseif	grid_type ==  STAIRCASE_POINT % 上下楼梯通行速度
												v3 = (1.49 - 0.36 * p) * v3;
												if nextval_z == 1 % 表示上楼
													v3 = 0.4887 * v3;
												elseif nextval_z == -1
													v3 = 0.6466 * v3;
												end
											 end


											 R3 = p / pc;      % 人流密度下的危险系数
											 Easy3 = v3 / v0;  % 人流密度下的通行难易系数

											 r_fai3 = 1;
											 easy_gama3 = 1;

											 R_total = R_total * (R3 ^ r_fai3);
											 Easy_total = Easy_total * (Easy3 ^ easy_gama3);

											 % 用以暂存通过该通道转移所需要的时间
											 v_cur = v0 * Easy_total;
											 TempTimes(nextval_x + 2,nextval_y + 2, nextval_z + 2) = dis / v_cur;


										 end


										 %=============== 引入人工势场影响因子 ============= %
										 if (OptimizeTypes(OPTIMIZE_1) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)

											 % 这里先进行计算，存储起来，然后再引入
											 exit_nums = size(ExitGrids, 1); % 出口对蚂蚁引力作用
											 f_x = 0;   % 人工势场合力矢量参数
											 f_y = 0;
											 f_z = 0;
											 for k = 1 : exit_nums                                                              
												 f_x = f_x + ExitGrids(k, 1);
												 f_y = f_y + ExitGrids(k, 2);
												 f_z = f_z + ExitGrids(k, 3);
											 end

											 fire_nums = size(FireGrids, 1); % 火源点对蚂蚁的斥力作用
											 for k = 1 : fire_nums
												 f_x = f_x - FireGrids(k, 1);
												 f_y = f_y - FireGrids(k, 1);
												 f_z = f_z - FireGrids(k, 1);
											 end

											 % 获得人工势场法合力的矢量参数F
											 f_x = f_x - (exit_nums - fire_nums) * next_x;
											 f_y = f_y - (exit_nums - fire_nums) * next_y;
											 f_z = f_z - (exit_nums - fire_nums) * next_z;

											 % 前进方向的单位向量nij
											 n_x = nextval_x;
											 n_y = nextval_y;
											 n_z = nextval_z;

											 %人工势场力作用大小是合力Fij，与前进位置法向量的矢量点乘
											 Fijs(nextval_x + 2,nextval_y + 2, nextval_z + 2) = dot([f_x, f_y, f_z], [n_x, n_y, n_z]); 
										 end                                                                                                                                                                                  
									 end
									 P(nextval_x + 2,nextval_y + 2, nextval_z + 2) = p_value;                                                    
%                                                      fprintf('next= (%d, %d, %d)， P= %d\n',nextval_x, nextval_y, nextval_z, p_value);
								end 
							end
						end
          
						
						% 对P中所有元素求和，然后求取平均值  
						P = P / sum(P(:));                               
						%========== 计算人工势场影响因子 ========== %
						if (OptimizeTypes(OPTIMIZE_1) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
							f_cigma = 1;  % 人工势场影响因子大小
							Fabs = abs(Fijs);
							Fijs = exp(Fijs / sum(Fabs(:)));  
							Fijs = Fijs .^ f_cigma;
							% 将人工势场引入转移概率的计算中
							P = P .* Fijs;
						end
						
						
						% *************** 轮盘赌方式选择下一个城市 ******************
						rand_line = rand;
						line = 0;
						NextGrid_Selected = zeros(1, 3);
						
						for temp_size = 1 : nextval_size
							nextval_x = Nextvals(temp_size, 1);
							nextval_y = Nextvals(temp_size, 2);
							nextval_z = Nextvals(temp_size, 3);
							if line < rand_line
								line = line + P(nextval_x + 2,nextval_y + 2, nextval_z + 2);
%                                                 fprintf('line= %d, rand = %d\n',line, rand_line);
								if (line >= rand_line)
									if  GridInfo(x + nextval_x, y + nextval_y, z + nextval_z, 2) == 1 % 剔除掉障碍物情况
										NextGrid_Selected(1, :) = [nextval_x ,nextval_y, nextval_z]; %选中下一处落脚点
									end
								end
							end 
						end
						
						
						L(j) = L(j) + 1; % 选中了城市则往后推进一步
						if (L(j) <= grid_size)
							if NextGrid_Selected(1, :) == [0, 0, 0] %表示停滞在原地
								Route(j, L(j), :) = [-1, -1, -1];
							else
								% 更新通行时间
								Time(j) = Time(j) + TempTimes(NextGrid_Selected(1, 1) + 2, NextGrid_Selected(1, 2) + 2, NextGrid_Selected(1, 3) + 2);
								Route(j, L(j), 1) = x + NextGrid_Selected(1, 1);
								Route(j, L(j), 2) = y + NextGrid_Selected(1, 2);
								Route(j, L(j), 3) = z + NextGrid_Selected(1, 3);   %记录下一步路径
								is_moved = 1; % 表示发生了移动，避免算法进入无效的停滞
							end
						end                               
					end
				end    
		   end                                     
	   end               
   end
   
   %% ============== 第三步：记录本次迭代最佳路线 ============= %%
   Length = zeros(ant_num, 1);  % 用来统计每只蚂蚁的路径值(这里不仅仅是指长度)  
   for k = 1 : ant_num
	   Length(k) = +inf;
   end
%  disp(Eta);
   
   for i = 1 : ant_num                      % 统计每只蚂蚁的行走路径的权值和（这里不仅计算路径的距离，同时还包括其他等因素，使用Eta进行计算,这里Eta是时间导向，与时间呈倒数线性关系，故而这里找寻Eta^(-1)和最小的值即可）
		AntRoute(:, :) = Route(i, :, :);             
%                 disp(AntRoute);
		for j = 1 : (min(L(i), max_step) - 1)
		% 处理遇到死胡同的情况
%                     fprintf('j == %d, nextval = (%d, %d, %d) ',  j, AntRoute(j + 1, 1), AntRoute(j + 1, 2), AntRoute(j + 1, 3));
			if AntRoute(j + 1, :) == [-1, -1, -1]
				Length(i) = +inf;
			else
				if Length(i) == +inf
					Length(i) = 0;
				end
				Nextval(1, :) = AntRoute(j + 1, :) - AntRoute(j, :) + 2;
				Length(i) = Length(i) + Eta(i, AntRoute(j, 1), AntRoute(j, 2), AntRoute(j, 3), Nextval(1), Nextval(2) , Nextval(3));
			end
%                     disp(Length(i));
		end
   end
   CycleLength(cycle_times) = min(Length); %记录每次迭代中的最短路径（这里指用时最少路径）
   ant_pos =  find(Length == CycleLength(cycle_times)); % 找到实现最短路径的蚂蚁
   CycleRoute(cycle_times, :, :) = Route(ant_pos(1), :, :); %记录每次迭代的最佳路径
   
   tempLength = Length;
   temp_count = 0;
   temp_total = 0;
   for k = 1 : ant_num
	   if tempLength(k) ~= +inf                  
		   temp_total = temp_total + tempLength(k);
	   else
		   temp_total = temp_total + max_step;
	   end
	   temp_count = temp_count + 1;
   end
%            CycleMean(cycle_times) = mean(Length);                     %记录每次迭代的平均值（用以后面的性能分析）
   CycleMean(cycle_times) = temp_total / temp_count;

   cycle_times = cycle_times + 1; % 进行下一轮迭代
   
   %% ============== 第四步：更新信息素 =================== %%
	Delta_Tau = zeros(x_max, y_max, z_max, 3, 3, 3, 1);        % 开始时信息素为n*n的0矩阵
	Length_min = min(Length);     %找到最大最小值
	Length_max = max(Length);
	thita = 2.0;                  %信息素最佳增量影响因子(优化策略4)
	for i = 1 : ant_num
		for j = 1 : (min(L(i), max_step) - 1)
			pre(1, :) = Route(i, j, :);
			next(1, :) = Route(i, j + 1, :);
			if (next(1, :) == [-1, -1 -1]) | (pre(1, :) == [-1, -1 -1]) %如果蚂蚁进入死胡同
%                         fprintf('ant %d run into blind\n', i);
			else                   
				nextval(1, :) = Route(i, j + 1, :) - Route(i, j, :) + 2;

				x = pre(1);
				y = pre(2);
				z = pre(3);
				nextval_x = nextval(1);
				nextval_y = nextval(2);
				nextval_z = nextval(3);
				% 此次循环在路径（i，j）上的信息素增量 (TODO:对于进入死胡同的蚂蚁有没有必要更新信息素，以及会对后面的蚂蚁产生怎样的影响，这里有待验证)
				temp_deta = Q / Length(i);
				
				% ======= 优化策略4, 最大最小路径的信息素增量优化 ======== %
				if (OptimizeTypes(OPTIMIZE_4) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
					if Length(i) == Length_min
						temp_deta = temp_deta * thita;
					elseif Length(i) == Length_max
						temp_deta = temp_deta / thita;
					end
				end

				Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) = Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) + temp_deta;
			end
		end
		% 此次循环在整个路径上的信息素增量
	end
	
	% =========== 优化策略3， 自适应信息素浓度挥发因子 ================= %
	if (OptimizeTypes(OPTIMIZE_3) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
		% 自定义更新信息素挥发因子Rho值
		Rho0 = 0.95;
		Rho_min = 0.4;
		fai = 0.95;
		temp_rho = Rho0 * (fai ^ (cycle_times - 1));
		if temp_rho <= Rho_min
			temp_rho = Rho_min;
		end
		Rho = temp_rho;
	end
	
   %************************* 更新信息素 ********************* %
   Tau=(1 - Rho) .* Tau + Delta_Tau; % 考虑信息素挥发，更新后的信息素
	
	% =========== 优化策略2， 自适应最大最小蚁群算法阈值 ================= %
	if (OptimizeTypes(OPTIMIZE_2) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
		% 设定最大最小蚁群法的阈值
		Rho_k = 0.5;
		L_min = min(Length);
		tau_max = (1 + Rho_k) / (2 * (1 - Rho_k)* L_min) +  (2 * (1 - Rho_k) )/ L_min;
		tau_k = 20;
		tau_min = tau_max / tau_k;

		%对信息浓度限定阈值 Tau = ones(x_max, y_max, z_max, 3, 3, 3, 1)
	   for x = 1 : x_max
	   for y = 1 : y_max
	   for z = 1 : z_max	   
		   for temp_size = 1 : nextval_size
				next_x = Nextvals(temp_size, 1) + 2;
				next_y = Nextvals(temp_size, 2) + 2;
				next_z = Nextvals(temp_size, 3) + 2;
				data_tau =  Tau(x, y, z, next_x, next_y, next_z, 1) ;
				   if data_tau > tau_max
					   data_tau = tau_max;
				   elseif data_tau < tau_min
					   data_tau =  tau_min;
				   end
				   Tau(x, y, z, next_x, next_y, next_z, 1) = data_tau;
		   end
	   end
	   end
	   end
	end
	
   
   %% ============== 第五步：完成一次迭代，要进行初始化，开始下次迭代=================== %%
 
end

pos = find(CycleLength == min(CycleLength));      % 找到最佳路径（非0为真）
BestRoute(1, :, :) = CycleRoute(pos(1), :, : );   % 最大迭代次数后最佳路径
best_length = CycleLength(pos(1));                % 最大迭代次数后最短距离
fprintf('Best Length = %d', best_length);
% disp(BestRoute);

% 
% %% ============== 第六步：输出计算得出的结果 ================= %%
% % 回执路径曲线
% subplot(1, 2, 1);    
% a = zeros(x_max, y_max, z_max);
% for x = 1 : x_max
%     for y = 1 : y_max
%         for z = 1 : z_max
%             a(x, y, z) = GridInfo(x, y, z, 2);
%         end
%     end
% end
% b = a;
% b(end + 1, end + 1) = 0;
% colormap([0 0 1; 1 1 1]) , pcolor(b);
% axis image ij off
% disp(b);
% 
% pos = find(CycleLength == min(CycleLength));      % 找到最佳路径（非0为真）
% BestRoute(1, :, :) = CycleRoute(pos(1), :, : );      % 最大迭代次数后最佳路径
% best_length = CycleLength(pos(1));        % 最大迭代次数后最短距离
% fprintf('Best Length = %d', best_length);
% % disp(BestRoute);
% 
% hold on;
% n = size(BestRoute, 2);
% for i = 1 : (n - 1)
%     temp(1, :) = BestRoute(1, i + 1, :);
%     if temp(1, :) ~= [0, 0, 0]
%         plot([BestRoute(1, i, 2) + 0.5 , BestRoute(1, i + 1, 2) + 0.5] , [BestRoute(1, i, 1) + 0.5, BestRoute(1, i + 1, 1) + 0.5 ], 'r' );
%     end
% end
% 
% % 绘制蚁群算法相关性能曲线
% subplot(1, 2, 2);                                            % 绘制第二个子图形
% plot(CycleLength);
% hold on;                                                           % 保持图形
% plot(CycleMean, 'r');
% title('平均距离和最短距离');                       % 标题




