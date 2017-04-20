function [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length]=ACO(GridInfo, EntranceGrid, ExitGrids, cycle_max, ant_num, AcoParameters)
%%  入参：
%      GridInfo: 栅格中每一个点的信息矩阵
%%  GridInfo的矩阵格式：x_max*y_max*z_max*10
%           节点的类型：EXIT_POINT               = 1 << 0;  (出口)
%                                     ENTRANCE_POINT = 1 << 1;  (入口)
%                                     DOOR_POINT          = 1 << 2;  (通道口)
%                                     ELEVATOR_POINT  = 1 << 3;  (电梯口)
%                                     STAIRCASE_POINT = 1 << 4;  (楼梯口)
%                                     FIREHYDRANT_POINT = 1 << 5; (消防栓)
%           是否可通行：IS_ACCESS                 = 0 / 1;   (即是否为障碍物，0 位障碍物)
%%      其他相关火灾信息：
%           当前人流量
%           烟雾浓度
%           热量
%           可见性（见光度）
%           保留位三位
%     
%% EntranceGrid : 入口坐标 (1 * 3矩阵)
%% ExitNos: （m * 3矩阵）
%          和前面相同，是以“空间换时间”；因为出口不止一个，三维情况下还涉及多个楼层，因而，这里是一个矩阵，矩阵里面包含的所有出口的集合

%           矩阵为1*3矩阵，包含信息即入口Grid的x, y, z坐标值
%% cycle_max: 蚁群算法循环迭代的最高次数
%% ant_num :  蚂蚁的个数
%% AcoParameters : 蚁群算法的相关参数矩阵
%           Alpha: 信息素启发因子，表示信息素的重要性，反应蚂蚁之间的协作程度；
%           Beta   : 期望启发因子，表示启发信息（路径的长度）的重要性。
%           Rho  ：信息素挥发因子
%           Q        :  信息素增加强度，为常数，其值会影响算法的收敛速度。


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

x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

grid_size = x_max *  y_max * z_max;  % 获取栅格的总数

max_step = (x_max +  y_max + z_max) * 30; %预计使用的最多步长，超过这个值，则不对该蚂蚁的路径继续计算（以此来减少无效的时间循环）

baseinfo_num = size(GridInfo, 4);       % GridInfo中基本信息的长度

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
best_length = inf;                                                                     % 记录目前所有迭代中最佳路径的长度

CycleRoute = zeros(cycle_max, grid_size , dimen_num); % 记录每次迭代中的最佳路径
CycleLength = inf .* ones(cycle_max, 1);                                % 记录每次迭代中的最佳路径长度
CycleMean   = zeros(cycle_max, 1);                                          % 记录每次迭代中的路径的平均长度 

%%*************************** 开始进入蚁群算法 *************************************%%
cycle_times = 1;  % 循环迭代次数
while cycle_times <= cycle_max
            % 局部变量置于此处也是为了每次迭代都进行清空（注意信息素不需要清空）
            Route = zeros(ant_num, grid_size, dimen_num);      % 记录每只蚂蚁走过的路径 (乘以dimen_num是记录每个栅格的x,y,z坐标)
            L = zeros(ant_num, 1);                                                         % 记录每只蚂蚁走过的路径步长（区别于真是路径长度），用以更新信息素大小
            Eta = zeros(ant_num, x_max, y_max, z_max, 3, 3, 3, 1);  % 注意这里考虑火灾场景中的动态因素变化，这里计算得到的所有节点的Eta值，和特定的蚂蚁相关。Eta为启发因子，即根据距离向量，火灾因素等计算出的相关系数（注意这里和网络拓扑中权值的区别，两者可类比为倒数的关系）
    
           %% ====== 第一步 初始化蚂蚁的位置，这里将蚂蚁的位置至于何处有待商榷，最初做法为将所有蚂蚁放在出口处；（对于优化时，可以考虑将蚂蚁放在入口点，及出口点）
           for i = 1 : ant_num
                Route(i, 1, :) =  EntranceGrid;
                L(i) = 1;
           end
           
           % 这里设置一个标志，如果所有蚂蚁都已到达终点，或者进入死胡同，则蚂蚁不会再移动
           is_moved = 1;
           
           %% ====== 第二步 按照转移概率确定蚂蚁下一步移动的位置 =========== %%
%            count = 0;
           for  i = 1 :  max_step                          % 先暂时不考虑进入死胡同的情况，即将Route当做禁忌表，一旦蚂蚁走过该点，就不允许再次重走该点
               if is_moved == 1 
                   is_moved = -1;  
                                     
                   for j = 1 : ant_num                            % 对每只蚂蚁进行操作 
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
                                
                                %测试输出
%                                 count = count + 1;
%                                 fprintf('count=%d, index=(%d, %d, %d)\n', count, x, y, z);
                                
%                                 if [x, y, z] == [5, 1, 1]
%                                     pppp = 1;
%                                 else
%                                     fprintf('(%d, %d, %d)\n',x, y, z);
%                                 end
                                CurGridInfo(1, :) = GridInfo(x, y, z,  :);  %当前节点的所有信息                 
                                
                                % 遍历该节点相邻的相关点                               
                                P = zeros(3, 3, 3, 1);       % 从远点到n个城市的转移矩阵，这里全部初始化为0（注意这里保留了当前点，在统计时，应注意去除）
                                for  nextval_x = -1 : 1
                                    for  nextval_y = -1 : 1
                                        for nextval_z = -1 : 1
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
                                                     dis = ((next_x - x) ^ 2 + (next_y - y) ^ 2 + (next_z - z) ^ 2) ^ 0.5;       %% TODO:这里是火灾疏散算法需要重要研究的对象，可以加入烟雾，热量等因素的影响
                                                                                                                                                                                          %    实际的计算会使用CurGridInfo和NextGridInfo信息进行计算
                                                     eta = 1 / dis;  % 启发因子
                                                     Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1) = eta; 
%                                                      disp(Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1));
                                                     % 取出该点对应的信息素
                                                     tau = Tau(x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1);
                                                     % *************  再计算转移概率 ************
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
%                                                          p_value = (tau ^ Alpha) * (eta ^ Beta) * 0.1;
                                                         p_value = 0;
                                                     elseif NextGridInfo(2) == 0  % 如果是障碍物，转移概率为0
                                                         p_value = 0;
                                                     else
                                                         % TODO:这里再做一次优化，因为以前的方法中，默认是蚂蚁超所有方向前进的概率是相等的，这里适当进行引导，即距离上节点越靠近出口点的，则优先进行引导
                                                         % 因而这里对靠近出口点的防线乘以一个引导系数
                                                         
                                                         % TODO：测试，这里先简单尝试使用前行引导
                                                         p_value =  (tau ^ Alpha) * (eta ^ Beta); 
%                                                          if (nextval_x > 0) | ( nextval_y > 0) | (nextval_z > 0)
%                                                              p_value = p_value * 1.5;
%                                                          end
%                                                          if (nextval_x > 0) && ( nextval_y > 0) &&(nextval_z > 0)
%                                                              p_value = p_value * 1.5;
%                                                          end
                                                     end
                                                     P(nextval_x + 2,nextval_y + 2, nextval_z + 2) = p_value;                                                    
%                                                      fprintf('next= (%d, %d, %d)， P= %d\n',nextval_x, nextval_y, nextval_z, p_value);
                                                end 
                                            end
                                        end
                                    end
                                end
                                
                                P = P / sum(P(:)); % 对P中所有元素求和
                                % *************** 轮盘赌方式选择下一个城市 ******************
                                rand_line = rand;
                                line = 0;
                                NextGrid_Selected = zeros(1, 3);
                                for  nextval_x = -1 : 1
                                    for  nextval_y = -1 : 1
                                        for nextval_z = -1 : 1
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
                                    end
                                end
                                
                                L(j) = L(j) + 1; % 选中了城市则往后推进一步
                                if (L(j) <= grid_size)
                                     if NextGrid_Selected(1, :) == [0, 0, 0] %表示停滞在原地
                                        Route(j, L(j), :) = [-1, -1, -1];
                                    else
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
%            disp(Eta);
           
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
                        Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) = Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) + Q / Length(i);
                    end
                end
                % 此次循环在整个路径上的信息素增量
            end
            Tau=(1 - Rho) .* Tau + Delta_Tau; % 考虑信息素挥发，更新后的信息素
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




