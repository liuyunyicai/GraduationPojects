% 
% % 
% n = 30;
% m = 40;
% a = rand(n, n, m);
% 
% for i = 1 : n
%     for j = 1 : n
%         for k = 1 : m
%             if a(i, j, k) >= 0.95
%                 a(i, j, k) = 1;
%             else 
%                 a(i, j, k) = 0;
%             end
%         end 
%     end
% end
% 
% b = a;
% b(end + 1, end + 1, end + 1) = 0;
% colormap([1 1 1; 0 0 1]) , pcolor(b);
% axis image ij off
% 
% 
% hold on;
% 
% points = [0, 15, 30, 10, 7, 19, 21];
% plot(points, 'r-');

% x = ones(3, 3, 3, 100);
% y = zeros(3, 3, 3, 10);
% z = [x y]
% 
% Exits = ones(2 , 3);
% Exits(1, :) = [1 2 3];
% Exits(2, :) = [12 4 6];
% disp(Exits);
% for exit = Exits
%     disp(exit);
% end
% zeross = [1, 2 ,3;
%                  4, 5, 6];
% next(1, :) =zeross(2, :);
% disp(next(2));


% GridInfo = rand(20, 20, 1, 10);
% x_max = size(GridInfo, 1);
% y_max = size(GridInfo, 2);
% z_max = size(GridInfo, 3);
% 
%  for x = 1 : x_max
%     for y = 1 : y_max
%         for z = 1 : z_max
%             if GridInfo(x, y, z, 2) >= 0.95
%                 GridInfo(x, y, z, 2) = 0;
%             else 
%                 GridInfo(x, y, z, 2) = 1;
%             end
%         end        
%     end
% end

% a = [10, 20, 13,
%          3, 4 ,6];
% b = min(a(:))

%% ====== ª‘÷…˝Œ¬«˙œﬂ ===== %% 
%  T = T0 + 345lg(8 * t  + 1)
% T0 = 20;
% t = 1 : 0.5 : 50;
% T = T0 + 345 * log10(8 * t  + 1);
% Z = 1 : 0.5 : 50;
% plot3(t, T, Z);

% alpha = 0.04689;
% t = 1 : 10 : 400;
% n = size(t, 2);
% Q = zeros(t, n);
% for k = 1 : n
%     Q(k) = alpha * t(k) * t(k);
% end
% Q
% Infos = zeros(1, 10);
% testfunc(Infos);
% Infos
% i = 2 && 4
% nextval_size = 10;
% Nextvals = zeros(nextval_size, 3);                               % ±È¿˙¡⁄”Ú ±µƒ∑∂Œß÷µ
% temp_size = 1;
% for next_x = -1 : 1
%     for next_y = -1 : 1
%         for next_z = -1 : 1
%             if ( (next_z ~= 0) && (next_x == 0) && (next_y == 0)) || ((next_z == 0) && ((next_x ~= 0) || (next_y ~= 0))) 
%                 Nextvals(temp_size, :) = [next_x, next_y, next_z];
%                 temp_size = temp_size + 1;
%             end
%         end
%     end
% end
% disp(Nextvals);
% next_x = -1;
% next_y = 1;
% next_z = 0;
% B = [next_x next_y next_z];
% find(ismember(Nextvals,B,'rows'))

%  [next_x next_y next_z] = Nextvals(temp_size, 1) ;
% EntranceGrid = [2, 1, 1;
%                                  1, 4, 4];
% CurGrid_pos = [2, 1, 1];
% if find(ismember(EntranceGrid,CurGrid_pos,'rows')) > 0
%     disp('get');
% end

% A = [1 2 3]
% B = [1, 2 , 3]

% temp_size = 0;
% % …Ë÷√ª‘÷«¯”Ú
% for x = 8 : 9
%     for y = 1 : 4
%         for z = 8 : 10
%             temp_size = temp_size + 1;
%             FireZones(temp_size,:) = [x, y, z]; 
%         end
%     end
% end
% disp(FireZones);

a = zeros(1, 10);
file_name = sprintf('result\\%s.mat', 'a');
save(file_name, 'a');



