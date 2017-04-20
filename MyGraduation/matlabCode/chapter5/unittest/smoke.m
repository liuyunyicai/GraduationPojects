%%% =============== ������ػ���״̬�������� ============== %%%
% run('BuildingData');
run('BuildingInitiation');
interval_x = 1;
interval_y = 1;
interval_z = 2;
z_index = 1;
v0 = 1.33;
firenum = 1;
for x_index = 7 : 7
    for y_index = 19 : 19
        run('plotFdsResult');

%         Data = load('TestGridInfo.mat');
        Data = load('InitiationGridData.mat');

        GridInfo = Data.GridInfo;
        
         k_somke = 0.9;
         C_deta = 0;
         
        SomkeC = zeros(1, time_max);
        
        
        Easy2 = zeros(1, time_max);
        
        % ��ȡ��Դλ��
        C_max = 0;
        for time = 1 : time_max
            % ������������ɢ��ʽ
            fire_x = FireGrids(firenum, 1);
            fire_y = FireGrids(firenum, 2);
            fire_z = FireGrids(firenum, 3);
            cur_time = time;
            if fire_z == z_index % ��������ͬһ¥��Ļ�ԴӰ��
                % �����Դ���û���ǰλ�õľ���
                
                slength = ((x_index - fire_x) * interval_x) ^ 2 + ((y_index - fire_y) * interval_y) ^ 2 + ((z_index - fire_z) * interval_z) ^ 2;
                
%                 C_deta =  (Q_CO2 * (1 +cur_time / time_max) )  * exp((-slength) / (4 * k_somke * cur_time));
%                 C_deta =  (Q_O2 )  * exp((-slength) / (4 * k_somke * cur_time));

                Ts(time) = exp((-slength ^ 2) / (4 * k_somke * cur_time));
                C_deta =  (Q * 1)  * exp((-slength ^ 1.5) / (4 * k_somke * cur_time));
            end
%              C = C + C_deta; % ������ɢ������Ũ����ʱ��仯ֵ
                SomkeC(time) =  C_deta;
                
                % �ȼ�����ɢ�ٶ�
                 vk = 0.706 + (-0.057) * 0.248 * (C_deta * 100 ^ 1); % ����ϵ���������ٶȹ�ʽ
                 Easy2(time) = vk / v0;  % ����Ũ��Ӱ���µ�ͨ������ϵ��
        end


        
        figure;
        plot(SomkeC, 'k');
        hold on;
%         plot(Theory_QCO2, 'r');
%         plot(Theory_QO2, 'b');
        plot(Theory_Smoke, '--k');
        
%         title_str = sprintf('����������Ũ��');
        title_str = sprintf('����������Ũ��(%d, %d)', x_index, y_index);
        title(title_str);
        ylabel('����Ũ��/�ٷֱ�');
        xlabel('ʱ��/s');
        legend('Ԥ��ֵ','ʵ��ֵ','Location','NorthWest');
        
%         figure;
%         plot(Easy2);

    end
end



