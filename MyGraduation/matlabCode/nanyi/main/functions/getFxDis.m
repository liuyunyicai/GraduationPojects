function [fx] = getFxDis(fx, total_dis_length, deta_x, deta_l, thita)
% if (deta_x == 0)
%     deta_x = 0.5;
% %     thita = 0;
% end
% 
% if deta_l == 0
%     deta_l = 0.5;
% %     thita = 0;
% end
% fx = fx +(thita * total_dis_length / deta_x) / deta_l;
fx = fx +(thita *  total_dis_length * deta_x) / (deta_l ^ 3) ;
