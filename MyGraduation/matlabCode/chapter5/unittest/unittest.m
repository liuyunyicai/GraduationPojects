% T0 = 20; 
% Tc1 = 30;
% Tc2 = 80; % ���������Σ���¶�
% Td = DEATH_TEMPERATURE; % ���������¶�
% vmax = 3.0; % ��������µ������ɢ�ٶ�
% Easy1 = 1;% ���¶��µ�ͨ������ϵ��															 
% easy_gama1 = 1; % �¶�ͨ������ϵ��Ӱ������
% 
v0 = 1.33; % ���ڲ��ܸ����µ�������ɢ�ٶ�
% 
% Tmax = 500;
% Easy_totals = zeros(1, Tmax);
%          
% for T = 1 : Tmax   
%     if (T >= Tc1) && (T < Tc2)
%                 Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / ((Tc2 - Tc1) ^ 2)) + v0);
%              elseif (T >= Tc2) && (T < Td)
%                 Easy1 = (1.2 / vmax) * (1 - ((T - Tc2) / (Td - Tc2)) ^ 2);
%              elseif T >= Td  
%                 Easy1 = 0;
%     end
%     Easy_totals(T) = Easy1 ^ easy_gama1;
% end
% 
% figure;
% plot(Easy_totals, 'r');
max = 8;
vs = zeros(1, max);
R_totals = zeros(1, max);
Easy_totals = zeros(1, max);
for peoplenum = 1 : max
    p = peoplenum * 0.12 / (interval_x * interval_y);
    pc = 0.92; % ���谭ʱ�������ܶ�
    % ����ͨ���ٶ�
     v3 = (112 * (p ^ 4) - 380 * (p ^ 3) + 434 * (p ^ 2) - 217 * p + 57)  / 60;
%      v3 = (1.17 + 0.13 * sin(6.03 * p - 0.12)) * v3;
     v3 = (1.49 - 0.36 * p) * v3 * v0;
     vs (peoplenum) = v3;
%      if grid_type == DOOR_POINT % ͨ���ſ�ͨ��
%         v3 = (1.17 + 0.13 * sin(6.03 * p - 0.12)) * v3;
%      elseif	grid_type ==  STAIRCASE_POINT % ����¥��ͨ���ٶ�
%         v3 = (1.49 - 0.36 * p) * v3;
%         if nextval_z == 1 % ��ʾ��¥
%             v3 = 0.4887 * v3;
%         elseif nextval_z == -1
%             v3 = 0.6466 * v3;
%         end
%      end
     R3 = p / pc;      % �����ܶ��µ�Σ��ϵ��
     Easy3 = v3 / v0;  % �����ܶ��µ�ͨ������ϵ��

     r_fai3 = 1;
     easy_gama3 = 1;

     R_totals(peoplenum) = R3 ^ r_fai3;
     Easy_totals(peoplenum) = Easy3 ^ easy_gama3;
end

plot(vs, 'k');
title_str = '�����ܶȶ���ɢ�ٶ�Ӱ��';
title(title_str);
ylabel('��ɢ�ٶ�/m/s');
xlabel('դ��������/��');
% plot(R_totals);
% plot(Easy_totals);
