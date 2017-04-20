%%% =============== 测试Fire============== %%%
% run('BuildingData');
run('BuildingInitiation');
z_index = 1;
for x_index = 2 : 2
    for y_index = 30 : 30
        
        run('plotFdsResult');

        Data = load('TestGridInfo.mat');
        GridInfo = Data.GridInfo;

        firenums = size(FireGrids, 1);
        
        % % 升温公式
        % for firenum = 1 : firenums
        %  % 获取火源位置
        % fire_x = FireGrids(firenum, 1);
        % fire_y = FireGrids(firenum, 2);
        % fire_z = FireGrids(firenum, 3);
        % if fire_z == next_z % 仅考虑在同一楼层的火源影响
        %     % 计算火源到用户当前位置的距离
        %     Tz = GridInfo(fire_x, fire_y, fire_z, GRID_INDEX_TEMPERATURE) + 345 * log10(8 * cur_time / 60 + 1); % 按照最坏估计更新火源的温度值
        %     t_s = (((next_x - fire_x) * interval_x) ^ 2 + ((next_y - fire_y) * interval_y) ^ 2) ^ 0.5;
        %     temp_tdeta = Tz * (1 - 0.8 * exp(-t_beta * cur_time) - 0.2 * exp(-0.1 * t_beta * cur_time)) * (t_eta + (1 - t_eta) * exp((0.5 - t_s) / t_miu));
        %     if temp_tdeta > T_deta
        %         T_deta = temp_tdeta;
        %     end
        % end
        % end

        % T = T + T_deta; % 计算温度
        Tc = 30;  % 正常温度为30度

        interval_x = 1;
        interval_y = 1;

        time_max = 150;
        % 火场温度场随时间变化计算公式
        t_beta = 0.04;  % 升温系数
        t_eta = 0.6;   % 温度随距离的衰减系数
        t_miu = 0.5;
        T_deta = 0;

        Temperature = zeros(1, time_max);
        firenum = 1;
        Tt = zeros(1, time_max);
        Tz_params = zeros(1, time_max);
        
        R_totals = zeros(1, time_max);
        Easy_totals = zeros(1, time_max);
        
        Tc = 30;  % 正常温度为30度
         r_fai1 = 0.2;            % 热量危险系数影响因子
         

         Tc1 = 30;
         Tc2 = 60; % 对人体产生危害温度
         Td = DEATH_TEMPERATURE; % 致人死亡温度
         vmax = 3.0; % 正常情况下的最大疏散速度
         Easy1 = 1;% 该温度下的通行难易系数															 
         easy_gama1 = 1; % 温度通行难易系数影响因子
         
         v0 = 1.33; % 人在不受干扰下的正常疏散速度
        
        for time = 1 : time_max
            % 获取火源位置
            fire_x = FireGrids(firenum, 1);
            fire_y = FireGrids(firenum, 2);
            fire_z = FireGrids(firenum, 3);
            Tz = 20+ 345 * log10(8 * time / 60 + 1);
            t_s = (((x_index - fire_x) * interval_x) ^ 2 + ((y_index - fire_y) * interval_y) ^ 2) ^ 0.5;
            Tz_param = (1 - 0.8 * exp(-t_beta * time) - 0.2 * exp(-0.1 * t_beta * time)) * (t_eta + (1 - t_eta) * exp((1 - t_s) / t_miu));
            Temperature(time) = Tz * Tz_param;
            Tt(time) = Tz;
            Tz_params(time) = Tz_param;
            
            T = Temperature(time);
            
            R1 = (T / Tc) ^ 3.61; % 温度危险系数
            if (T >= Tc1) && (T < Tc2)
                Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / ((Tc2 - Tc1) ^ 2)) + v0);
             elseif (T >= Tc2) && (T < Td)
                Easy1 = (1.2 / vmax) * (1 - ((T - Tc2) / (Td - Tc2)) ^ 2);
             elseif T >= Td  
                Easy1 = 0;
            end
             
            %==== 得到最终结果 =====% 
             % 计算危害性影响因子与通行难易度影响因子
             R_totals(time) = R1 ^ r_fai1;
             Easy_totals(time) = Easy1 ^ easy_gama1;
            
        end
        
        
         

         

%         figure;
%         plot(Tz_params, 'b');
%         title_str = sprintf('温度(%d, %d)', x_index, y_index);
%         title(title_str);
%         ylabel('温度/度');
%         xlabel('时间/s');

        figure;
        plot(Temperature, 'b');
        hold on;
        plot(Theory_Temperature, 'r');
        title_str = sprintf('温度(%d, %d)', x_index, y_index);
        title_str = '温度';
        title(title_str);
        ylabel('温度/度');
        xlabel('时间/s');
        
        figure;
        plot(R_totals, 'r');
        title_str = '危险性';
        title(title_str);
        ylabel('温度/度');
        xlabel('时间/s');
        
        figure;
        plot(Easy_totals, 'r');
        title_str = '难易性';
        title(title_str);
        ylabel('温度/度');
        xlabel('时间/s');
        

        % figure;
        % plot(Tt, 'r');
%         title_str = sprintf('温度(%d, %d)', x_index, y_index);
%         title(title_str);
        % xlabel('时间/s');

        save('Exper1.mat', 'Tt');
    end
end
% % 取点的位置
% x_index = 13;
% y_index = 23;
% z_index = 1;


