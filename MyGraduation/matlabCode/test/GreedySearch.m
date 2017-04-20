function [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length]=GreedySearch(GridInfo, EntranceGrid, ExitGrids)
x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

cycle_max = (x_max + y_max + z_max) * 3;
cur_cycle = 1;
dimen_size = 3;
CycleRoute = zeros(cycle_max + 1, dimen_size);
CycleRoute(1, :) = EntranceGrid(:);
cur_length = 1;
%% 开始进行贪心计算
[BestRoute, best_length] = GreedyNextSearch(GridInfo, EntranceGrid, ExitGrids, cycle_max, EntranceGrid, cur_cycle, cur_length, CycleRoute);
disp(best_length);

%% 回执路劲曲线
a = zeros(x_max, y_max, z_max);
for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            a(x, y, z) = GridInfo(x, y, z, 2);
        end
    end
end
b = a;
b(end + 1, end + 1) = 0;
colormap([0 0 1; 1 1 1]) , pcolor(b);
axis image ij off
disp(b);

hold on;
n = size(BestRoute, 2);
fprintf('Route= (%d, %d)',BestRoute(1, 1),  BestRoute(1, 2));
for i = 1 : (n - 1)
    if BestRoute(i + 1, :) ~= [0, 0, 0]
        plot([BestRoute(i, 2) + 0.5 , BestRoute(i + 1, 2) + 0.5] , [BestRoute(i, 1) + 0.5, BestRoute(i + 1, 1) + 0.5 ], 'r' );
        fprintf('=> (%d, %d)',BestRoute(i + 1, 1),  BestRoute(i + 1, 2));
    end
end






function [BestRoute, best_length] = GreedyNextSearch(GridInfo, EntranceGrid, ExitGrids, cycle_max, CurGrid, cur_cycle, cur_length, CycleRoute) 
%% CurGrid 表示当前循环中的Grid
%     cur_cycle表示当前循环次数（避免无限递归导致的无限循环）,最多不超过cycle_max
%     cur_length 表示当前的路径长度
%     CycleRoute 表示之前的最佳的路径

best_length = cur_length;
BestRoute = CycleRoute;
fprintf('cur_cycle = %d, curGrid=(%d, %d, %d), cur_length = %d\n',cur_cycle, CurGrid(1), CurGrid(2), CurGrid(3), cur_length);
cur_cycle = cur_cycle + 1;
if cur_cycle > cycle_max
    best_length = inf;
else
     is_exited = -1;  % 判断是否已经到达终点，如果已经到达，则直接返回
    exit_num = size(ExitGrids, 1);
    for k = 1 :  exit_num
           exitGrid(1, :) = ExitGrids(k, :);
           if  CurGrid == exitGrid % 表示已经到达终点
               is_exited = 1;
           end
    end
    if is_exited == 1          % 表示已经到达终点,则直接返回
        best_length = cur_length;
        BestRoute = CycleRoute;
        fprintf('the Ant arrived, Length=%d', best_length);
    else                                 % 否则需要向下进行遍历
        x_max = size(GridInfo, 1);
        y_max = size(GridInfo, 2);
        z_max = size(GridInfo, 3);
        dimen_size = 3; 
        BestRoutes = zeros(3, 3, 3, cycle_max + 1, dimen_size);
        BestLengths = inf .* ones(3, 3, 3, 1);
        for  nextval_x = -1 : 1
            for  nextval_y = -1 : 1
                for nextval_z = -1 : 1
                    if  [nextval_x nextval_y nextval_z] == [0 0 0]                                % 原点情况抛除
                        BestLengths(nextval_x + 2,nextval_y + 2, nextval_z + 2) = inf;
                    else                                                
                        NextGrid = CurGrid + [nextval_x, nextval_y, nextval_z];
                        next_x = NextGrid(1);
                        next_y = NextGrid(2);
                        next_z = NextGrid(3);
                        
                        % 这里采取不允许重复的策略
                        is_visited = -1;
                        for k = 1 : cur_cycle - 1
                            if CycleRoute(k, :) == [next_x, next_y, next_z]
                                is_visited = 1;
                            end
                        end

                        if is_visited == -1 %表示该城市在该循环中未访问过
                            if ((next_x >= 1) && (next_x <= x_max)) && ((next_y >= 1) && (next_y <= y_max)) && ((next_z >= 1) && (next_z <= z_max))                    %判断该对应点是否存在
                                %% 进行递归实现
                                CycleRoute(cur_cycle, :) = NextGrid(:);

                                % 还要判断该点是否为障碍点，如果为障碍点，则不允许通行
                                if GridInfo(next_x, next_y, next_z, 2) == 1
                                    dis = ((nextval_x) ^ 2 + (nextval_y) ^ 2 + (nextval_z) ^ 2) ^ 0.5; 
                                    cur_length = cur_length + dis;
                                    [tempBestRoute, temp_length] = GreedyNextSearch(GridInfo, EntranceGrid, ExitGrids, cycle_max, NextGrid, cur_cycle, cur_length, CycleRoute);                 
                                    BestRoutes(nextval_x + 2,nextval_y + 2, nextval_z + 2, :, :) = tempBestRoute;
                                    BestLengths(nextval_x + 2,nextval_y + 2, nextval_z + 2) = temp_length;       
                                end                         
                            else
                                BestLengths(nextval_x + 2,nextval_y + 2, nextval_z + 2) = inf;
                            end                
                        else
                            BestLengths(nextval_x + 2,nextval_y + 2, nextval_z + 2) = inf;
                        end                        
                    end
                end
            end
        end

        % 找到其中的最短路径返回
        best_length = min(BestLengths(:));
        if best_length~= inf
            for i = 1 : 3
                for j = 1 : 3
                    for k = 1 : 3
                        if BestLengths(i, j , k) == best_length %计算最大值位置的单下标
                            BestRoute(:, :) = BestRoutes(i, j, k, :, :);
%                             fprintf('Next Grid= (%d, %d, %d)\n', i - 2, j - 2 ,k - 2);
                        end
                    end
                end
            end
        end        
    end
end








