%%% =============== ����Fire============== %%%
% run('BuildingData');
run('BuildingInitiation');
z_index = 1;
for x_index = 2 : 2
    for y_index = 30 : 30
        
        run('plotFdsResult');

        Data = load('TestGridInfo.mat');
        GridInfo = Data.GridInfo;

        firenums = size(FireGrids, 1);
        
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

        interval_x = 1;
        interval_y = 1;

        time_max = 150;
        % ���¶ȳ���ʱ��仯���㹫ʽ
        t_beta = 0.04;  % ����ϵ��
        t_eta = 0.6;   % �¶�������˥��ϵ��
        t_miu = 0.5;
        T_deta = 0;

        Temperature = zeros(1, time_max);
        firenum = 1;
        Tt = zeros(1, time_max);
        Tz_params = zeros(1, time_max);
        
        R_totals = zeros(1, time_max);
        Easy_totals = zeros(1, time_max);
        
        Tc = 30;  % �����¶�Ϊ30��
         r_fai1 = 0.2;            % ����Σ��ϵ��Ӱ������
         

         Tc1 = 30;
         Tc2 = 60; % ���������Σ���¶�
         Td = DEATH_TEMPERATURE; % ���������¶�
         vmax = 3.0; % ��������µ������ɢ�ٶ�
         Easy1 = 1;% ���¶��µ�ͨ������ϵ��															 
         easy_gama1 = 1; % �¶�ͨ������ϵ��Ӱ������
         
         v0 = 1.33; % ���ڲ��ܸ����µ�������ɢ�ٶ�
        
        for time = 1 : time_max
            % ��ȡ��Դλ��
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
            
            R1 = (T / Tc) ^ 3.61; % �¶�Σ��ϵ��
            if (T >= Tc1) && (T < Tc2)
                Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / ((Tc2 - Tc1) ^ 2)) + v0);
             elseif (T >= Tc2) && (T < Td)
                Easy1 = (1.2 / vmax) * (1 - ((T - Tc2) / (Td - Tc2)) ^ 2);
             elseif T >= Td  
                Easy1 = 0;
            end
             
            %==== �õ����ս�� =====% 
             % ����Σ����Ӱ��������ͨ�����׶�Ӱ������
             R_totals(time) = R1 ^ r_fai1;
             Easy_totals(time) = Easy1 ^ easy_gama1;
            
        end
        
        
         

         

%         figure;
%         plot(Tz_params, 'b');
%         title_str = sprintf('�¶�(%d, %d)', x_index, y_index);
%         title(title_str);
%         ylabel('�¶�/��');
%         xlabel('ʱ��/s');

        figure;
        plot(Temperature, 'b');
        hold on;
        plot(Theory_Temperature, 'r');
        title_str = sprintf('�¶�(%d, %d)', x_index, y_index);
        title_str = '�¶�';
        title(title_str);
        ylabel('�¶�/��');
        xlabel('ʱ��/s');
        
        figure;
        plot(R_totals, 'r');
        title_str = 'Σ����';
        title(title_str);
        ylabel('�¶�/��');
        xlabel('ʱ��/s');
        
        figure;
        plot(Easy_totals, 'r');
        title_str = '������';
        title(title_str);
        ylabel('�¶�/��');
        xlabel('ʱ��/s');
        

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


