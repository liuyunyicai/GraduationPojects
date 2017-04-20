% T0 = 20; 
% Tc1 = 30;
% Tc2 = 80; % 对人体产生危害温度
% Td = DEATH_TEMPERATURE; % 致人死亡温度
% vmax = 3.0; % 正常情况下的最大疏散速度
% Easy1 = 1;% 该温度下的通行难易系数															 
% easy_gama1 = 1; % 温度通行难易系数影响因子
% 
v0 = 1.33; % 人在不受干扰下的正常疏散速度
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
    pc = 0.92; % 无阻碍时的人流密度
    % 计算通行速度
     v3 = (112 * (p ^ 4) - 380 * (p ^ 3) + 434 * (p ^ 2) - 217 * p + 57)  / 60;
%      v3 = (1.17 + 0.13 * sin(6.03 * p - 0.12)) * v3;
     v3 = (1.49 - 0.36 * p) * v3 * v0;
     vs (peoplenum) = v3;
%      if grid_type == DOOR_POINT % 通过门口通道
%         v3 = (1.17 + 0.13 * sin(6.03 * p - 0.12)) * v3;
%      elseif	grid_type ==  STAIRCASE_POINT % 上下楼梯通行速度
%         v3 = (1.49 - 0.36 * p) * v3;
%         if nextval_z == 1 % 表示上楼
%             v3 = 0.4887 * v3;
%         elseif nextval_z == -1
%             v3 = 0.6466 * v3;
%         end
%      end
     R3 = p / pc;      % 人流密度下的危险系数
     Easy3 = v3 / v0;  % 人流密度下的通行难易系数

     r_fai3 = 1;
     easy_gama3 = 1;

     R_totals(peoplenum) = R3 ^ r_fai3;
     Easy_totals(peoplenum) = Easy3 ^ easy_gama3;
end

plot(vs, 'k');
title_str = '人流密度对疏散速度影响';
title(title_str);
ylabel('疏散速度/m/s');
xlabel('栅格内人数/人');
% plot(R_totals);
% plot(Easy_totals);
