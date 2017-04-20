run('testACO3');
ss = 'Final_3';
%重新设定一些参数
OUTPUT_ROUTE = 0;

for pp = 2 : 3
    if pp == 3
        ant_num = 50;
        OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
%         OptimizeTypes(OPTIMIZE_7) = 1;
        OptimizeTypes(OPTIMIZE_1) = 1;
%         OptimizeTypes(OPTIMIZE_3) = 1;
%         OptimizeTypes(OPTIMIZE_4) = 1;
%         OptimizeTypes(OPTIMIZE_2) = 1;
        % OptimizeTypes(OPTIMIZE_8) = 1;
        OptimizeTypes(OPTIMIZE_FIRE) = 1;
        OptimizeTypes(OPTIMIZE_FIRE1) = 1;
        OptimizeTypes(OPTIMIZE_FIRE2) = 1;
        OptimizeTypes(OPTIMIZE_FIRE3) = 1;

        Label = sprintf('OP1_TEST_%s', ss)
%     elseif pp == 2
%         OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
% %         OptimizeTypes(OPTIMIZE_7) = 1;
%         OptimizeTypes(OPTIMIZE_1) = 0;
% %         OptimizeTypes(OPTIMIZE_3) = 1;
% %         OptimizeTypes(OPTIMIZE_4) = 1;
% %         OptimizeTypes(OPTIMIZE_2) = 1;
%         % OptimizeTypes(OPTIMIZE_8) = 1;
%         % OptimizeTypes(OPTIMIZE_FIRE) = 1;
%         % OptimizeTypes(OPTIMIZE_FIRE1) = 1;
%         % OptimizeTypes(OPTIMIZE_FIRE2) = 1;
%         % OptimizeTypes(OPTIMIZE_FIRE3) = 1;
% 
%         Label = sprintf('OP000_TEST_%s', ss)

    elseif pp == 2
        cycle_max = 15;
        ant_num = 40;
%         cycle_max = 1;
%         ant_num = 4;
        OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
        OptimizeTypes(OPTIMIZE_7) = 1;
        OptimizeTypes(OPTIMIZE_1) = 1;
        OptimizeTypes(OPTIMIZE_3) = 1;
        OptimizeTypes(OPTIMIZE_4) = 1;
        OptimizeTypes(OPTIMIZE_2) = 1;
        OptimizeTypes(OPTIMIZE_9) = 1;
        OptimizeTypes(OPTIMIZE_8) = 1;
        OptimizeTypes(OPTIMIZE_10) = 1;
        OptimizeTypes(OPTIMIZE_FIRE) = 1;
        OptimizeTypes(OPTIMIZE_FIRE1) = 1;
        OptimizeTypes(OPTIMIZE_FIRE2) = 1;
        OptimizeTypes(OPTIMIZE_FIRE3) = 1;

       Label = sprintf('OP2_TEST_%s', ss)
    else
        OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
        OptimizeTypes(OPTIMIZE_7) = 1;
        OptimizeTypes(OPTIMIZE_1) = 1;
        OptimizeTypes(OPTIMIZE_3) = 1;
        OptimizeTypes(OPTIMIZE_4) = 1;
        OptimizeTypes(OPTIMIZE_2) = 1;
        OptimizeTypes(OPTIMIZE_8) = 1;
        OptimizeTypes(OPTIMIZE_9) = 1;
        OptimizeTypes(OPTIMIZE_10) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE1) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE2) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE3) = 1;

        Label = sprintf('OP3_TEST_%s', ss)
    end

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

    %% ============== 第六步：输出计算得出的结果 ================= %%
    minLength = min(Length);
    minIndex = find(Length == minLength(1));
    
    for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            T = GridInfo(x, y, z, GRID_INDEX_TEMPERATURE) ;
            C_O2 = GridInfo(x, y, z, GRID_INDEX_O2) * 100;   % 氧气浓度
            C_CO = GridInfo(x, y, z, GRID_INDEX_CO) * 100 * 1000;   % 一氧化碳浓度(ppm)
            C_CO2 = GridInfo(x, y, z, GRID_INDEX_CO2) * 100; % 二氧化碳浓度
            
            if (GridInfo(x, y, z, GRID_INDEX_ISFREE) == ISACCESSED_ZONE) &&((T >= DEATH_TEMPERATURE * WARNING_DEATH_PARAM) ...
                    || ((C_O2 > 0) &&(C_O2 <= DEATH_O2/ WARNING_DEATH_PARAM)) || (C_CO >= DEATH_CO* WARNING_DEATH_PARAM) || (C_CO2 >= DEATH_CO2* WARNING_DEATH_PARAM)) 
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = DANGER_ZONE;
            end
            
            if (GridInfo(x, y, z, GRID_INDEX_ISFREE) == ISACCESSED_ZONE) &&((T >= DEATH_TEMPERATURE)|| ((C_O2 > 0) &&(C_O2 <= DEATH_O2)) || (C_CO >= DEATH_CO) || (C_CO2 >= DEATH_CO2)) 
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = FIRED_ZONE;
            end
        end
    end
end
    
    % 绘制路径曲线
    a = zeros(x_max, y_max, z_max);
    for z = 1 : z_max
        for x = 1 : x_max
            for y = 1 : y_max
                a(x, y, z) = GridInfo(x, y, z, 2);
            end
        end
    end
% 
%     figure;
%     % 绘制蚁群算法相关性能曲线
%     plot(CycleLength);
%     title('最短距离');
% 
%     figure;
%     plot(CycleMean, 'r');
%     title('平均距离');                       % 标题
% 
%     % 绘制时间曲线
%     figure;
%     plot(Time);
%     title('计算时间');
%     ylabel('计算时间/s');
%     xlabel('计算次数/次');
%     meanTime = mean(Time)
% 
%     % 绘制最短路径曲线
%     figure;
%     plot(Length);
%     title('最短路径长度');
%     ylabel('最短路径长度/m');
%     xlabel('计算次数/次');
%     meanLength = mean(Length);

    filename = sprintf('ResultData_%s.mat', Label);
    save(filename, 'a', 'BestRoutes','CycleLength', 'CycleMean', 'Time', 'Length', 'PreferedGrids', 'AllAntArriveTimes');
end

    

    