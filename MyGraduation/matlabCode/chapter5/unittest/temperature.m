%%% =============== ������ػ���״̬�������� ============== %%%
% run('BuildingData');
run('BuildingInitiation');
z_index = 3;
for x_index = 7 : 8
    for y_index = 22 : 24
        firenums = size(FireGrids, 1);
        run('plotFdsResult');

%         Data = load('TestGridInfo.mat');
%         Data = load('InitiationGridData.mat');
%         GridInfo = Data.GridInfo;

        
        % % ���¹�ʽ
        % for firenum = 1 : firenums
        %  % ��ȡ��Դλ��
        % fire_x = FireGrids(firenum, 1);
        % fire_y = FireGrids(firenum, 2);
        % fire_z = FireGrids(firenum, 3);
        % if fire_z == next_z % ��������ͬһ¥��Ļ�ԴӰ��
        %     % �����Դ���û���ǰλ�õľ���
        %     Tz = GridInfo(fire_x, fire_y, fire_z, GRID_INDEX_TEMPERATURE) + 345 * log10(8 * cur_time / 60 + 1); % ��������Ƹ��»�Դ���¶�ֵ
        %     t_s = (((next_x - fire_x) * interval_x) ^ 2 + ((next_y - fire_y) * interval_y) ^ 2) ^ 0.5;
        %     temp_tdeta = Tz * (1 - 0.8 * exp(-t_beta * cur_time) - 0.2 * exp(-0.1 * t_beta * cur_time)) * (t_eta + (1 - t_eta) * exp((0.5 - t_s) / t_miu));
        %     if temp_tdeta > T_deta
        %         T_deta = temp_tdeta;
        %     end
        % end
        % end

        % T = T + T_deta; % �����¶�
        Tc = 30;  % �����¶�Ϊ30��

        interval_x = 2;
        interval_y = 2;

        time_max = 90;
        % ���¶ȳ���ʱ��仯���㹫ʽ
        t_beta = 0.03;  % ����ϵ��
        t_eta = 0.5;   % �¶�������˥��ϵ��
        t_miu = 0.4;
        T_deta = 0;

        Temperature = zeros(1, time_max);
        firenum = 1;
        Tt = zeros(1, time_max);
        Tz_params = zeros(1, time_max);
        for time = 1 : time_max
            % ��ȡ��Դλ��
            fire_x = FireGrids(firenum, 1);
            fire_y = FireGrids(firenum, 2);
            fire_z = FireGrids(firenum, 3);
            Tz = 20+ 345 * log10(8 * time / 60 + 1);
        %     Tz = 500;
            t_s = (((x_index - fire_x) * interval_x) ^ 2 + ((y_index - fire_y) * interval_y) ^ 2) ^ 0.5;
            Tz_param = (1 - 0.8 * exp(-t_beta * time) - 0.2 * exp(-0.1 * t_beta * time)) * (t_eta + (1 - t_eta) * exp((1 - t_s) / t_miu));
            Temperature(time) = Tz * Tz_param;
            Tt(time) = Tz;
            Tz_params(time) = Tz_param;
        end

%         figure;
%         plot(Tz_params, 'b');
%         title_str = sprintf('�¶�(%d, %d)', x_index, y_index);
%         title(title_str);
%         ylabel('�¶�/��');
%         xlabel('ʱ��/s');

        figure;
        plot(Temperature, 'k');
        hold on;
        plot(Theory_Temperature, '--k');
        title_str = sprintf('�¶�(%d, %d)', x_index, y_index);
%         title_str = '�¶�';
        title(title_str);
        ylabel('�¶�/\circC');
        xlabel('ʱ��/s');
        legend('Ԥ��ֵ','ʵ��ֵ','Location','NorthWest');

        % figure;
        % plot(Tt, 'r');
%         title_str = sprintf('�¶�(%d, %d)', x_index, y_index);
%         title(title_str);
        % xlabel('ʱ��/s');

        save('Exper1.mat', 'Tt');
    end
end
% % ȡ���λ��
% x_index = 13;
% y_index = 23;
% z_index = 1;


