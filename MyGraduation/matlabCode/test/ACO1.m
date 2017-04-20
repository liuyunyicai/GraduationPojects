function [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length]=ACO(GridInfo, EntranceGrid, ExitGrids, cycle_max, ant_num, AcoParameters)
%%  ��Σ�
%      GridInfo: դ����ÿһ�������Ϣ����
%%  GridInfo�ľ����ʽ��x_max*y_max*z_max*10
%           �ڵ�����ͣ�EXIT_POINT               = 1 << 0;  (����)
%                                     ENTRANCE_POINT = 1 << 1;  (���)
%                                     DOOR_POINT          = 1 << 2;  (ͨ����)
%                                     ELEVATOR_POINT  = 1 << 3;  (���ݿ�)
%                                     STAIRCASE_POINT = 1 << 4;  (¥�ݿ�)
%                                     FIREHYDRANT_POINT = 1 << 5; (����˨)
%           �Ƿ��ͨ�У�IS_ACCESS                 = 0 / 1;   (���Ƿ�Ϊ�ϰ��0 λ�ϰ���)
%%      ������ػ�����Ϣ��
%           ��ǰ������
%           ����Ũ��
%           ����
%           �ɼ��ԣ�����ȣ�
%           ����λ��λ
%     
%% EntranceGrid : ������� (1 * 3����)
%% ExitNos: ��m * 3����
%          ��ǰ����ͬ�����ԡ��ռ任ʱ�䡱����Ϊ���ڲ�ֹһ������ά����»��漰���¥�㣬�����������һ�����󣬾���������������г��ڵļ���

%           ����Ϊ1*3���󣬰�����Ϣ�����Grid��x, y, z����ֵ
%% cycle_max: ��Ⱥ�㷨ѭ����������ߴ���
%% ant_num :  ���ϵĸ���
%% AcoParameters : ��Ⱥ�㷨����ز�������
%           Alpha: ��Ϣ���������ӣ���ʾ��Ϣ�ص���Ҫ�ԣ���Ӧ����֮���Э���̶ȣ�
%           Beta   : �����������ӣ���ʾ������Ϣ��·���ĳ��ȣ�����Ҫ�ԡ�
%           Rho  ����Ϣ�ػӷ�����
%           Q        :  ��Ϣ������ǿ�ȣ�Ϊ��������ֵ��Ӱ���㷨�������ٶȡ�


%% ���Σ�
%  CycleRoute    : ��¼ÿ�ε����е����·��
%  CycleLength : ��¼ÿ�ε����е����·������
%  CycleMean    : ��¼ÿ�ε����е�·����ƽ������
%  BestRoute      : ��¼Ŀǰ���е�������ѵ�·��
%  best_length  : ��¼Ŀǰ���е��������·���ĳ���
% 


%% =============== ���㲽 ��������Ĳ���ֵ����������Ӧ��ʼ�� ==================== %%      
Alpha = AcoParameters(1);
Beta  = AcoParameters(2);
Rho   = AcoParameters(3);
Q     = AcoParameters(4);

x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

grid_size = x_max *  y_max * z_max;  % ��ȡդ�������

max_step = (x_max +  y_max + z_max) * 30; %Ԥ��ʹ�õ���ಽ�����������ֵ���򲻶Ը����ϵ�·���������㣨�Դ���������Ч��ʱ��ѭ����

baseinfo_num = size(GridInfo, 4);       % GridInfo�л�����Ϣ�ĳ���

% ��Ҫ�ݴ�������Ϣ
% ��Ϣ����ν��д洢��������ô�ͳ���ڽӾ���ķ�������Ҫ�洢n^2��Ԫ�أ������������Ϊϡ����󣬺ܶ�ռ䶼���˷�û�б�Ҫ�ģ���Ϊ��դ�����������꣩
%                                            ���ｫ���нڵ���Ϣ���洢��һ��GridInfo�����У�������ǽ���Ϣ�ؾ���Ҳ������ж�Ӧ����������Ӧ���£�����Ҳ�����ö�ά����ά�ռ��ת��
dimen_num = 3;                                                                  % ָ��Ⱥ�㷨ʵ�ֵĿռ�ά�ȣ���������ά
adjacent_num = 3 ^ dimen_num;                                                       % ���ڵ�դ�����Ŀ����άΪ8����άΪ26���������ϵĴ洢ֵΪgrid_size^2��������м򻯣�ֻ��Ҫ�洢grid_size * adjacent_num���ռ��С��
Tau = ones(x_max, y_max, z_max, 3, 3, 3, 1);  % TauΪ��Ϣ�ؾ������Լ�¼ÿ���ڵ㵽��һ���ڵ��·������������Ϣ�ش�С

% ����ant_numֻ���ϣ���Ҫ��¼���߹���·��Route��·���ĳ���L(���Ը�����Ϣ��) ����Щ���͵�����أ�
% ͬʱ����Ҫ��ÿ�ε���֮�󣬼�¼��ǰ�õ������Ž⣺�����·�������·������
% Ϊ�˱���֮������ܷ�������Ӧ��¼ÿ�ε����е����·�����������Ϣ
BestRoute = zeros(1, grid_size, dimen_num);             % ��¼Ŀǰ���е�������ѵ�·��
best_length = inf;                                                                     % ��¼Ŀǰ���е��������·���ĳ���

CycleRoute = zeros(cycle_max, grid_size , dimen_num); % ��¼ÿ�ε����е����·��
CycleLength = inf .* ones(cycle_max, 1);                                % ��¼ÿ�ε����е����·������
CycleMean   = zeros(cycle_max, 1);                                          % ��¼ÿ�ε����е�·����ƽ������ 

%%*************************** ��ʼ������Ⱥ�㷨 *************************************%%
cycle_times = 1;  % ѭ����������
while cycle_times <= cycle_max
            % �ֲ��������ڴ˴�Ҳ��Ϊ��ÿ�ε�����������գ�ע����Ϣ�ز���Ҫ��գ�
            Route = zeros(ant_num, grid_size, dimen_num);      % ��¼ÿֻ�����߹���·�� (����dimen_num�Ǽ�¼ÿ��դ���x,y,z����)
            L = zeros(ant_num, 1);                                                         % ��¼ÿֻ�����߹���·������������������·�����ȣ������Ը�����Ϣ�ش�С
            Eta = zeros(ant_num, x_max, y_max, z_max, 3, 3, 3, 1);  % ע�����￼�ǻ��ֳ����еĶ�̬���ر仯���������õ������нڵ��Etaֵ�����ض���������ء�EtaΪ�������ӣ������ݾ����������������صȼ���������ϵ����ע�����������������Ȩֵ���������߿����Ϊ�����Ĺ�ϵ��
    
           %% ====== ��һ�� ��ʼ�����ϵ�λ�ã����ｫ���ϵ�λ�����ںδ��д���ȶ���������Ϊ���������Ϸ��ڳ��ڴ����������Ż�ʱ�����Կ��ǽ����Ϸ�����ڵ㣬�����ڵ㣩
           for i = 1 : ant_num
                Route(i, 1, :) =  EntranceGrid;
                L(i) = 1;
           end
           
           % ��������һ����־������������϶��ѵ����յ㣬���߽�������ͬ�������ϲ������ƶ�
           is_moved = 1;
           
           %% ====== �ڶ��� ����ת�Ƹ���ȷ��������һ���ƶ���λ�� =========== %%
%            count = 0;
           for  i = 1 :  max_step                          % ����ʱ�����ǽ�������ͬ�����������Route�������ɱ�һ�������߹��õ㣬�Ͳ������ٴ����߸õ�
               if is_moved == 1 
                   is_moved = -1;  
                                     
                   for j = 1 : ant_num                            % ��ÿֻ���Ͻ��в��� 
                       CurGrid_pos = Route(j, L(j), :);  % �����Ǽ�¼��Route�е�ǰλ�õ��������
                                                                                   % ��ȡ��ǰ�ڵ㣬Ȼ�����ӵ�ǰ�ڵ��������adjacent_num���ڵ��ת�Ƹ��ʣ�ע��������ɱ���ת�Ƹ��ʼ�Ϊ0
                                                                                   % ����һ��ת�ƽڵ㼴Ϊ�뵱ǰ�ڵ���ص�adjacent_num���ڵ������֮һ
                       
                        if CurGrid_pos(1) ~= -1      % -1��ʾ�����Ͻ���������ͬ�������ֽ�������޳�
                            %  *********** �����ж��Ƿ�ﵽ�յ� ************** %
                            is_exited = -1;
                            exit_num = size(ExitGrids, 1);
                            for k = 1 :  exit_num
                                   exitGrid(1, 1, :) = ExitGrids(k, :);
                                   if  CurGrid_pos == exitGrid % ��ʾ�Ѿ������յ�
                                       is_exited = 1;
                                   end
                            end
                           
                            % ************ ���δ�ﵽ�յ㣬�����ת�� ************** %
                            if is_exited == -1 % ��ʾ����δ���ڣ���Ҫ����ִ������ѭ��
                                % ======= ���㵽��һ���ڵ��ת�Ƹ��� ======= % ������Route���൱�ڽ��ɱ�                                          
                                x = CurGrid_pos(1);
                                y = CurGrid_pos(2);
                                z = CurGrid_pos(3);
                                
                                %�������
%                                 count = count + 1;
%                                 fprintf('count=%d, index=(%d, %d, %d)\n', count, x, y, z);
                                
%                                 if [x, y, z] == [5, 1, 1]
%                                     pppp = 1;
%                                 else
%                                     fprintf('(%d, %d, %d)\n',x, y, z);
%                                 end
                                CurGridInfo(1, :) = GridInfo(x, y, z,  :);  %��ǰ�ڵ��������Ϣ                 
                                
                                % �����ýڵ����ڵ���ص�                               
                                P = zeros(3, 3, 3, 1);       % ��Զ�㵽n�����е�ת�ƾ�������ȫ����ʼ��Ϊ0��ע�����ﱣ���˵�ǰ�㣬��ͳ��ʱ��Ӧע��ȥ����
                                for  nextval_x = -1 : 1
                                    for  nextval_y = -1 : 1
                                        for nextval_z = -1 : 1
                                            if  [nextval_x nextval_y nextval_z] == [0 0 0] % ԭ������׳�
                                                P(nextval_x + 2,nextval_y + 2, nextval_z + 2) = 0;
                                            else
                                                next_x = x + nextval_x;
                                                next_y = y + nextval_y;
                                                next_z = z + nextval_z;                                               
                                                
                                                if ((next_x >= 1) && (next_x <= x_max)) && ((next_y >= 1) && (next_y <= y_max)) && ((next_z >= 1) && (next_z <= z_max))                    %�жϸö�Ӧ���Ƿ����                                                                                                
                                                     % ����ת�Ƹ���
                                                     NextGridInfo(1, :) = GridInfo(next_x, next_y, next_z,  : ); % ��һդ��������Ϣ
                                                     % ���ȼ���ÿ��ת��·��������ʽ���ش�С(��������ʱ�Ǿ���ĵ���)
                                                     dis = ((next_x - x) ^ 2 + (next_y - y) ^ 2 + (next_z - z) ^ 2) ^ 0.5;       %% TODO:�����ǻ�����ɢ�㷨��Ҫ��Ҫ�о��Ķ��󣬿��Լ����������������ص�Ӱ��
                                                                                                                                                                                          %    ʵ�ʵļ����ʹ��CurGridInfo��NextGridInfo��Ϣ���м���
                                                     eta = 1 / dis;  % ��������
                                                     Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1) = eta; 
%                                                      disp(Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1));
                                                     % ȡ���õ��Ӧ����Ϣ��
                                                     tau = Tau(x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1);
                                                     % *************  �ټ���ת�Ƹ��� ************
                                                     % �����Ѿ����ʵĽڵ㣬��Route�������Ѿ���¼�˽ڵ㣬��ת�Ƹ���Ϊ0��������ֻ����ʱ���������д��Ż���
                                                     is_visited = -1; % ��־�ýڵ��Ƿ��Ѿ����ʹ�
                                                     for k = 1 : L(j)
                                                         visited(1, :) = Route(j, k, :);
                                                         
                                                         if visited(1, :) == [next_x, next_y, next_z]
                                                             is_visited = 1;                                                             
                                                         end                                                      
                                                     end                                                    
%                                                      disp(is_visited);
                                                     p_value = 0;
                                                     if is_visited == 1    % ��ʾ�Ѿ����ʹ�����ת�Ƹ���Ϊ0 ��������һ���Ż���Ϊ�˱������Ͻ�������ͬ�����������Ͽ��Է����Ѿ����ʹ��Ľڵ㣩
%                                                          p_value = (tau ^ Alpha) * (eta ^ Beta) * 0.1;
                                                         p_value = 0;
                                                     elseif NextGridInfo(2) == 0  % ������ϰ��ת�Ƹ���Ϊ0
                                                         p_value = 0;
                                                     else
                                                         % TODO:��������һ���Ż�����Ϊ��ǰ�ķ����У�Ĭ�������ϳ����з���ǰ���ĸ�������ȵģ������ʵ������������������Ͻڵ�Խ�������ڵ�ģ������Ƚ�������
                                                         % �������Կ������ڵ�ķ��߳���һ������ϵ��
                                                         
                                                         % TODO�����ԣ������ȼ򵥳���ʹ��ǰ������
                                                         p_value =  (tau ^ Alpha) * (eta ^ Beta); 
%                                                          if (nextval_x > 0) | ( nextval_y > 0) | (nextval_z > 0)
%                                                              p_value = p_value * 1.5;
%                                                          end
%                                                          if (nextval_x > 0) && ( nextval_y > 0) &&(nextval_z > 0)
%                                                              p_value = p_value * 1.5;
%                                                          end
                                                     end
                                                     P(nextval_x + 2,nextval_y + 2, nextval_z + 2) = p_value;                                                    
%                                                      fprintf('next= (%d, %d, %d)�� P= %d\n',nextval_x, nextval_y, nextval_z, p_value);
                                                end 
                                            end
                                        end
                                    end
                                end
                                
                                P = P / sum(P(:)); % ��P������Ԫ�����
                                % *************** ���̶ķ�ʽѡ����һ������ ******************
                                rand_line = rand;
                                line = 0;
                                NextGrid_Selected = zeros(1, 3);
                                for  nextval_x = -1 : 1
                                    for  nextval_y = -1 : 1
                                        for nextval_z = -1 : 1
                                            if line < rand_line
                                                line = line + P(nextval_x + 2,nextval_y + 2, nextval_z + 2);
%                                                 fprintf('line= %d, rand = %d\n',line, rand_line);
                                                if (line >= rand_line)
                                                    if  GridInfo(x + nextval_x, y + nextval_y, z + nextval_z, 2) == 1 % �޳����ϰ������
                                                        NextGrid_Selected(1, :) = [nextval_x ,nextval_y, nextval_z]; %ѡ����һ����ŵ�
                                                    end
                                                end
                                            end  
                                        end
                                    end
                                end
                                
                                L(j) = L(j) + 1; % ѡ���˳����������ƽ�һ��
                                if (L(j) <= grid_size)
                                     if NextGrid_Selected(1, :) == [0, 0, 0] %��ʾͣ����ԭ��
                                        Route(j, L(j), :) = [-1, -1, -1];
                                    else
                                        Route(j, L(j), 1) = x + NextGrid_Selected(1, 1);
                                        Route(j, L(j), 2) = y + NextGrid_Selected(1, 2);
                                        Route(j, L(j), 3) = z + NextGrid_Selected(1, 3);   %��¼��һ��·��
                                        is_moved = 1; % ��ʾ�������ƶ��������㷨������Ч��ͣ��
                                    end
                                end                               
                            end
                        end    
                   end                                     
               end               
           end
           
           %% ============== ����������¼���ε������·�� ============= %%
           Length = zeros(ant_num, 1);  % ����ͳ��ÿֻ���ϵ�·��ֵ(���ﲻ������ָ����)  
           for k = 1 : ant_num
               Length(k) = +inf;
           end
%            disp(Eta);
           
           for i = 1 : ant_num                      % ͳ��ÿֻ���ϵ�����·����Ȩֵ�ͣ����ﲻ������·���ľ��룬ͬʱ���������������أ�ʹ��Eta���м���,����Eta��ʱ�䵼����ʱ��ʵ������Թ�ϵ���ʶ�������ѰEta^(-1)����С��ֵ���ɣ�
                AntRoute(:, :) = Route(i, :, :);             
%                 disp(AntRoute);
                for j = 1 : (min(L(i), max_step) - 1)
                % ������������ͬ�����
%                     fprintf('j == %d, nextval = (%d, %d, %d) ',  j, AntRoute(j + 1, 1), AntRoute(j + 1, 2), AntRoute(j + 1, 3));
                    if AntRoute(j + 1, :) == [-1, -1, -1]
                        Length(i) = +inf;
                    else
                        if Length(i) == +inf
                            Length(i) = 0;
                        end
                        Nextval(1, :) = AntRoute(j + 1, :) - AntRoute(j, :) + 2;
                        Length(i) = Length(i) + Eta(i, AntRoute(j, 1), AntRoute(j, 2), AntRoute(j, 3), Nextval(1), Nextval(2) , Nextval(3));
                    end
%                     disp(Length(i));
                end
           end
           CycleLength(cycle_times) = min(Length); %��¼ÿ�ε����е����·��������ָ��ʱ����·����
           ant_pos =  find(Length == CycleLength(cycle_times)); % �ҵ�ʵ�����·��������
           CycleRoute(cycle_times, :, :) = Route(ant_pos(1), :, :); %��¼ÿ�ε��������·��
           
           tempLength = Length;
           temp_count = 0;
           temp_total = 0;
           for k = 1 : ant_num
               if tempLength(k) ~= +inf                  
                   temp_total = temp_total + tempLength(k);
               else
                   temp_total = temp_total + max_step;
               end
               temp_count = temp_count + 1;
           end
%            CycleMean(cycle_times) = mean(Length);                     %��¼ÿ�ε�����ƽ��ֵ�����Ժ�������ܷ�����
           CycleMean(cycle_times) = temp_total / temp_count;

           cycle_times = cycle_times + 1; % ������һ�ֵ���
           
           %% ============== ���Ĳ���������Ϣ�� =================== %%
            Delta_Tau = zeros(x_max, y_max, z_max, 3, 3, 3, 1);        % ��ʼʱ��Ϣ��Ϊn*n��0����
            for i = 1 : ant_num
                for j = 1 : (min(L(i), max_step) - 1)
                    pre(1, :) = Route(i, j, :);
                    next(1, :) = Route(i, j + 1, :);
                    if (next(1, :) == [-1, -1 -1]) | (pre(1, :) == [-1, -1 -1]) %������Ͻ�������ͬ
%                         fprintf('ant %d run into blind\n', i);
                    else                   
                        nextval(1, :) = Route(i, j + 1, :) - Route(i, j, :) + 2;

                        x = pre(1);
                        y = pre(2);
                        z = pre(3);
                        nextval_x = nextval(1);
                        nextval_y = nextval(2);
                        nextval_z = nextval(3);
                        % �˴�ѭ����·����i��j���ϵ���Ϣ������ (TODO:���ڽ�������ͬ��������û�б�Ҫ������Ϣ�أ��Լ���Ժ�������ϲ���������Ӱ�죬�����д���֤)
                        Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) = Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) + Q / Length(i);
                    end
                end
                % �˴�ѭ��������·���ϵ���Ϣ������
            end
            Tau=(1 - Rho) .* Tau + Delta_Tau; % ������Ϣ�ػӷ������º����Ϣ��
           %% ============== ���岽�����һ�ε�����Ҫ���г�ʼ������ʼ�´ε���=================== %%
 
end

pos = find(CycleLength == min(CycleLength));      % �ҵ����·������0Ϊ�棩
BestRoute(1, :, :) = CycleRoute(pos(1), :, : );   % ���������������·��
best_length = CycleLength(pos(1));                % ��������������̾���
fprintf('Best Length = %d', best_length);
% disp(BestRoute);

% 
% %% ============== ���������������ó��Ľ�� ================= %%
% % ��ִ·������
% subplot(1, 2, 1);    
% a = zeros(x_max, y_max, z_max);
% for x = 1 : x_max
%     for y = 1 : y_max
%         for z = 1 : z_max
%             a(x, y, z) = GridInfo(x, y, z, 2);
%         end
%     end
% end
% b = a;
% b(end + 1, end + 1) = 0;
% colormap([0 0 1; 1 1 1]) , pcolor(b);
% axis image ij off
% disp(b);
% 
% pos = find(CycleLength == min(CycleLength));      % �ҵ����·������0Ϊ�棩
% BestRoute(1, :, :) = CycleRoute(pos(1), :, : );      % ���������������·��
% best_length = CycleLength(pos(1));        % ��������������̾���
% fprintf('Best Length = %d', best_length);
% % disp(BestRoute);
% 
% hold on;
% n = size(BestRoute, 2);
% for i = 1 : (n - 1)
%     temp(1, :) = BestRoute(1, i + 1, :);
%     if temp(1, :) ~= [0, 0, 0]
%         plot([BestRoute(1, i, 2) + 0.5 , BestRoute(1, i + 1, 2) + 0.5] , [BestRoute(1, i, 1) + 0.5, BestRoute(1, i + 1, 1) + 0.5 ], 'r' );
%     end
% end
% 
% % ������Ⱥ�㷨�����������
% subplot(1, 2, 2);                                            % ���Ƶڶ�����ͼ��
% plot(CycleLength);
% hold on;                                                           % ����ͼ��
% plot(CycleMean, 'r');
% title('ƽ���������̾���');                       % ����




