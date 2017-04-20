function [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length]=ACO(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters)
%%  ��Σ�
%      GridInfo: դ����ÿһ�������Ϣ����
%%  GridInfo�ľ����ʽ��x_max*y_max*z_max*10  
%        grid_type�ڵ�����ͣ�EXIT_POINT      = 1 << 0;  (����)
%                      ENTRANCE_POINT  = 1 << 1;  (���)
%                      DOOR_POINT      = 1 << 2;  (ͨ����)
%                      ELEVATOR_POINT  = 1 << 3;  (���ݿ�)
%                      STAIRCASE_POINT = 1 << 4;  (¥�ݿ�)
%                      FIREHYDRANT_POINT = 1 << 5; (����˨)     
%        grid_isfree�Ƿ��ͨ�У�IS_ACCESS       = 0 / 1;   (���Ƿ�Ϊ�ϰ��0 λ�ϰ���)
%%      ������ػ�����Ϣ��
%        grid_temperature դ���¶ȴ�С
%        grid_somke       դ������Ũ��
%        grid_O2          դ������Ũ��
%        grid_CO          դ��COŨ��
%        grid_CO2         դ��CO2Ũ��
%        grid_peoplenum   դ����Ա����
%        ����λ��λ
%     
%% EntranceGrid : ������� (1 * 3����)
%% ExitGrids: ��m * 3����
%          ��ǰ����ͬ�����ԡ��ռ任ʱ�䡱����Ϊ���ڲ�ֹһ������ά����»��漰���¥�㣬�����������һ�����󣬾���������������г��ڵļ���

%           ����Ϊ1*3���󣬰�����Ϣ�����Grid��x, y, z����ֵ
%% FireGrids: (m * 3����)
% ����λ�ü��ϣ���Ϊ������ܲ�ֹһ���������Ҫһ������
%% cycle_max: ��Ⱥ�㷨ѭ����������ߴ���
%% ant_num :  ���ϵĸ���
%% AcoParameters : ��Ⱥ�㷨����ز�������
%           Alpha: ��Ϣ���������ӣ���ʾ��Ϣ�ص���Ҫ�ԣ���Ӧ����֮���Э���̶ȣ�
%           Beta   : �����������ӣ���ʾ������Ϣ��·���ĳ��ȣ�����Ҫ�ԡ�
%           Rho  ����Ϣ�ػӷ�����
%           Q        :  ��Ϣ������ǿ�ȣ�Ϊ��������ֵ��Ӱ���㷨�������ٶȡ�
%% GridParameters: դ�񷨵���ز���
%  interval_x X�᷽����դ�񷨵ĵ�λ��࣬��λm 
%  interval_y
%  interval_z
%% OptimizeTypes: �Ƿ�Ϊԭʼ����Ⱥ�㷨��Ϊ1��Ϊ�ǣ������е��Ż�����ȫ��������
%% FireParameters: Fire���ֵ���ز���
%  warning_time: ���ֱ���ʱ���ַ�����ʱ��

% ======================= ���ó���ֵ ============================ %
% GridInfo����ز�����λ��
GRID_INDEX_TYPE        = 1;
GRID_INDEX_ISFREE      = 2;
GRID_INDEX_TEMPERATURE = 3;
GRID_INDEX_SMOKE       = 4;
GRID_INDEX_O2          = 5;
GRID_INDEX_CO          = 6;
GRID_INDEX_CO2         = 7;
GRID_INDEX_PEOPLENUM   = 8;

EXIT_POINT      = 2 ^ 0;   %(����)
COMMON_POINT    = 2 ^ 1;   %(��ͨͨ��)
DOOR_POINT      = 2 ^ 2;   %(ͨ����)
ELEVATOR_POINT  = 2 ^ 3;   %(���ݿ�)
STAIRCASE_POINT = 2 ^ 4;   %(¥�ݿ�)
FIREHYDRANT_POINT = 2 ^ 5; %(����˨) 


% �Ż���������
OPTIMIZE_FIRE = 11; % ���𳡲�����Ϣ�������
OPTIMIZE_ALL = 12;  % ѡ�������Ż�����
OPTIMIZE_NONE = 10;      % ����ԭʼ����Ⱥ�㷨
OPTIMIZE_1 = 1;     % ���õ�����Ż�����
OPTIMIZE_2 = 2;
OPTIMIZE_3 = 3;
OPTIMIZE_4 = 4;
OPTIMIZE_5 = 5;
OPTIMIZE_6 = 6;
OPTIMIZE_7 = 7;

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

interval_x = GridParameters(1);
interval_y = GridParameters(2);
interval_z = GridParameters(3);

x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

warning_time = FireParameters(1); % ��ȡ��ʼ����ʱ�̻����Ѿ���չ��ʱ��
firenums = size(FireGrids, 1);    % �Ż�����Ŀ

grid_size = x_max *  y_max * z_max;  % ��ȡդ�������

max_step = grid_size; %Ԥ��ʹ�õ���ಽ�����������ֵ���򲻶Ը����ϵ�·���������㣨�Դ���������Ч��ʱ��ѭ����

baseinfo_num = size(GridInfo, 4);       % GridInfo�л�����Ϣ�ĳ���

v0 = 1.33; % ���ڲ��ܸ����µ�������ɢ�ٶ�

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
best_length = inf;                                      % ��¼Ŀǰ���е��������·���ĳ���

CycleRoute    = zeros(cycle_max, grid_size , dimen_num); % ��¼ÿ�ε����е����·��
CycleLength   = inf .* ones(cycle_max, 1);               % ��¼ÿ�ε����е����·������
CycleMean     = zeros(cycle_max, 1);                     % ��¼ÿ�ε����е�·����ƽ������ 
CycleTime     = inf .* ones(cycle_max, 1);               % ��¼ÿ�ε����е����·����ɢʱ��
CycleTimeMean = zeros(cycle_max, 1);                     % ��¼ÿ�ε����е�·����ƽ����ɢʱ��


%%% ����һЩ���ñ���
 %************* ��������ʱ�ķ�Χֵ *************** %
 % δ�Ż�֮ǰ�İ汾
nextval_size = 26;
Nextvals = zeros(nextval_size, 3);                              
temp_size = 1;
for next_x = -1 : 1
    for next_y = -1 : 1
        for next_z = -1 : 1
            if (next_x ~= 0) || (next_y ~= 0) || (next_z ~= 0)
                Nextvals(temp_size, :) = [next_x, next_y, next_z];
                temp_size = temp_size + 1;
            end
        end
    end
end
% disp(Nextvals);

% �Ż�������򼯺�
% nextval_size = 10;
% Nextvals = zeros(nextval_size, 3);                               % ��������ʱ�ķ�Χֵ
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


%%*************************** ��ʼ������Ⱥ�㷨 *************************************%%
cycle_times = 1;  % ѭ����������
while cycle_times <= cycle_max
	% �ֲ��������ڴ˴�Ҳ��Ϊ��ÿ�ε�����������գ�ע����Ϣ�ز���Ҫ��գ�
	Route = zeros(ant_num, grid_size, dimen_num);      % ��¼ÿֻ�����߹���·�� (����dimen_num�Ǽ�¼ÿ��դ���x,y,z����)
	L = zeros(ant_num, 1);                             % ��¼ÿֻ�����߹���·������������������·�����ȣ������Ը�����Ϣ�ش�С
	Eta = zeros(ant_num, x_max, y_max, z_max, 3, 3, 3, 1);  % ע�����￼�ǻ��ֳ����еĶ�̬���ر仯���������õ������нڵ��Etaֵ�����ض���������ء�EtaΪ�������ӣ������ݾ����������������صȼ���������ϵ����ע�����������������Ȩֵ���������߿����Ϊ�����Ĺ�ϵ��
	
	Inspires = zeros(ant_num, x_max, y_max, z_max, 3, 3, 3, 1);% ��Ⱥ�㷨�е��������ӣ����ǻ�Ӱ�����أ�
	EqualLength = zeros(ant_num, 1);                   % ��¼ÿһֻ���ϵĵ�Ч��ɢ���ȣ����Ը�����Ϣ�ش�С��
	Time = zeros(ant_num, 1);                          % ��¼ÿֻ���ϵ���ɢʱ�䣨���Ը��»����أ�ͬʱͳ��·��ɢʱ�䣩
   
   %% ====== ��һ�� ��ʼ�����ϵ�λ�ã����ｫ���ϵ�λ�����ںδ��д���ȶ���������Ϊ���������Ϸ��ڳ��ڴ����������Ż�ʱ�����Կ��ǽ����Ϸ�����ڵ㣬�����ڵ㣩
   for i = 1 : ant_num
		Route(i, 1, :) =  EntranceGrid;
		L(i) = 1;
   end
   
   % ��������һ����־������������϶��ѵ����յ㣬���߽�������ͬ�������ϲ������ƶ�
   is_moved = 1;
   
   %% ====== �ڶ��� ����ת�Ƹ���ȷ��������һ���ƶ���λ�� =========== %%
%            count = 0;
   for  i = 1 : max_step                          % ����ʱ�����ǽ�������ͬ�����������Route�������ɱ�һ�������߹��õ㣬�Ͳ������ٴ����߸õ�
	   if is_moved == 1 
		   is_moved = -1;  
							 
		   for j = 1 : ant_num                   % ��ÿֻ���Ͻ��в��� 
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
						
						% �����ýڵ����ڵ���ص�                               
						P = zeros(3, 3, 3, 1);       % ��Զ�㵽n�����е�ת�ƾ�������ȫ����ʼ��Ϊ0��ע�����ﱣ���˵�ǰ�㣬��ͳ��ʱ��Ӧע��ȥ����
						Fijs = zeros(3, 3, 3, 1);    % �����ݴ��˹��Ƴ���
						TempTimes = zeros(3, 3, 3, 1); % �����ݴ�ͨ����ת��·������Ҫ����ɢʱ��
		
                        
                        for temp_size = 1 : nextval_size
							nextval_x = Nextvals(temp_size, 1);
							nextval_y = Nextvals(temp_size, 2);
							nextval_z = Nextvals(temp_size, 3);
							
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
									 dis = (((next_x - x) * interval_x) ^ 2 + ((next_y - y) * interval_y) ^ 2 + ((next_z - z) * interval_z) ^ 2) ^ 0.5;       %% TODO:�����ǻ�����ɢ�㷨��Ҫ��Ҫ�о��Ķ��󣬿��Լ����������������ص�Ӱ��
																																										  %    ʵ�ʵļ����ʹ��CurGridInfo��NextGridInfo��Ϣ���м���
									 eta = 1 / dis;  % ��������
									 Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1) = eta; 
%                                    disp(Eta(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1));
									 % ȡ���õ��Ӧ����Ϣ��
%                                      fprintf('current= (%d, %d, %d)\n',x, y, z);
									 tau = Tau(x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1);

									 % *************  �ټ���ת�Ƹ��� ************ %
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
%												 if (OptimizeTypes(OPTIMIZE_8) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1) 
%													 p_value = (tau ^ Alpha) * (eta ^ Beta) * 0.1;
%												 end                                                         
										 p_value = 0;
									 elseif NextGridInfo(GRID_INDEX_ISFREE) == 0  % ������ϰ��ת�Ƹ���Ϊ0
										 p_value = 0;
									 else
										 % TODO:��������һ���Ż�����Ϊ��ǰ�ķ����У�Ĭ�������ϳ����з���ǰ���ĸ�������ȵģ������ʵ������������������Ͻڵ�Խ�������ڵ�ģ������Ƚ�������
										 % �������Կ������ڵ�ķ��߳���һ������ϵ��

										 % TODO�����ԣ������ȼ򵥳���ʹ��ǰ������
										 p_value =  (tau ^ Alpha) * (eta ^ Beta);

										 %=============== ���������Ӱ������ ============= %
										 if (OptimizeTypes(OPTIMIZE_FIRE) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1) 
											 thita = 0.5; % Σ���Գͷ�ϵ��
											 % ������Ӧ���ֳ�������Ⱥ�㷨��������
											 Inspires(j, x, y, z, nextval_x + 2,nextval_y + 2, nextval_z + 2, 1) = (dis / v0) ^ (thita - 1); 

											 R_total = 1;    % ���Լ�¼Σ����ϵ��R�ĳ˻�
											 Easy_total = 1; % ���Լ�¼ͨ������ϵ���ĳ˻�

											 % =========== �����������Ӱ�� ======== %
											 T = NextGridInfo(GRID_INDEX_TEMPERATURE); % �𳡵��¶�
											 % ���¶ȳ���ʱ��仯���㹫ʽ
											 t_beta = 0.003;  % ����ϵ��
											 t_eta = 0.8;   % �¶�������˥��ϵ��
											 t_miu = 0.5;
											 cur_time = Time(j);
											 T_deta = 0;

											 for firenum = 1 : firenums
												[fire_x fire_y fire_z] = FireGrids(firenum, :); % ��ȡ��Դλ��
												if fire_z == next_z % ��������ͬһ¥��Ļ�ԴӰ��
													% �����Դ���û���ǰλ�õľ���
													Tz = GridInfo(fire_x, fire_y, fire_z, GRID_INDEX_TEMPERATURE) + 345 * log10(8 * cur_time / 60 + 1); % ��������Ƹ��»�Դ���¶�ֵ
													t_s = (((next_x - fire_x) * interval_x) ^ 2 + ((next_y - fire_y) * interval_y) ^ 2) ^ 0.5;
													temp_tdeta = Tz * (1 - 0.8 * exp(-t_beta * cur_time) - 0.2 * exp(-0.1 * t_beta * cur_time)) * (t_eta + (1 - t_eta) * exp((0.5 - t_s) / t_miu));
													if temp_tdeta > T_deta
														T_deta = temp_tdeta;
													end
												end
											 end

											 T = T + T_deta;
											 Tc = 30;  % �����¶�Ϊ30��

											 r_fai1 = 1;            % ����Σ��ϵ��Ӱ������
											 R1 = (T / Tc) ^ 3.61; % �¶�Σ��ϵ��

											 Tc1 = 30;
											 Tc2 = 60; % ���������Σ���¶�
											 Td = 120; % ���������¶�
											 vmax = 3.0; % ��������µ������ɢ�ٶ�
											 Easy1 = 1;% ���¶��µ�ͨ������ϵ��															 
											 easy_gama1 = 1; % �¶�ͨ������ϵ��Ӱ������
											 if (T >= Tc1) && (T < Tc2)
												Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / (Tc2 - Tc1)) + v0);
											 elseif (T >= Tc2) && (T < Td)
												Easy1 = 1.2 / (vamx * (1 - ((T - Tc2) / (Td - Tc2))) ^ 2);
											 elseif T >= Td  
												Easy1 = 0;
											 end

											 R_total = R_total * (R1 ^ r_fai1);
											 Easy_total = Easy_total * (Easy1 ^ easy_gama1);



											 % =========== ��������Ũ�ȵ�Ӱ�� ========= %
											 C = NextGridInfo(GRID_INDEX_SMOKE) * 100;   % ����Ũ��
											 C_O2 = NextGridInfo(GRID_INDEX_O2) * 100;   % ����Ũ��
											 C_CO = NextGridInfo(GRID_INDEX_CO) * 100 * 1000;   % һ����̼Ũ��(ppm)
											 C_CO2 = NextGridInfo(GRID_INDEX_CO2) * 100; % ������̼Ũ��

											 % ������������ɢ��ʽ
											 k_somke = 0.9;
											 C_deta = 0;

											 for firenum = 1 : firenums
												[fire_x fire_y fire_z] = FireGrids(firenum, :); % ��ȡ��Դλ��
												if fire_z == next_z % ��������ͬһ¥��Ļ�ԴӰ��
													% �����Դ���û���ǰλ�õľ���
													slength = ((next_x - fire_x) * interval_x) ^ 2 + ((next_y - fire_y) * interval_y) ^ 2 + ((next_z - fire_z) * interval_z) ^ 2;
													C_deta = C_deta + (warning_time / cur_time) ^ 1.5 * exp((-slength) / (4 * k_somke * cur_time));
												end
											 end
											 C = C + C_deta; % ������ɢ������Ũ����ʱ��仯ֵ


											 % ��ȫ�����µĸ�������Ũ��
											 Csafe_O2 = 21;
											 Csafe_CO = 0.01 * 10000;
											 Csafe_CO2 = 5; % �ٷֱ�

											 % �ȼ�����ɢ�ٶ�
											 vk = 0.706 + (-0.057) * 0.248 * (C ^ 1); % ����ϵ���������ٶȹ�ʽ
											 Easy2 = vk / v0;  % ����Ũ��Ӱ���µ�ͨ������ϵ��
											 tk = dis / vk;    % �ڸ�����Ũ���µ�ͨ��ʱ��

											 % ����Σ����
											 FEDco = 4.607 * (10 ^ (-7)) * (C_CO ^ 1.036) * tk;
											 FEDo2 = tk / (60 * exp(8.13- 0.54 * (20.9 - C_O2))) ;
											 HVco2 = exp(0.1930 * C_CO2 + 2.004) / 7.1; 
											 FED = FEDco * HVco2 + FEDo2; 

											 % ��Σ������µ���Ϣ��ʽֵ
											 FEDc_co = 4.607 * (10 ^ (-7)) * (Csafe_CO ^ 1.036) * tk;
											 FEDc_o2 = tk / (60 * exp(8.13- 0.54 * (20.9 - Csafe_O2))) ;
											 HVcc_o2 = exp(0.1930 * Csafe_CO2 + 2.004) / 7.1; 
											 FEDc = FEDc_co * HVcc_o2 + FEDc_o2; 

											 % ����Ũ���µ�Σ�ճ̶�ϵ�� 
											 R2 = FED / FEDc;

											 r_fai2 = 1;
											 easy_gama2 = 1;

											 R_total = R_total * (R2 ^ r_fai2);
											 Easy_total = Easy_total * (Easy2 ^ easy_gama2);													 

											 % ============ ���������ܶȵ�Ӱ�� ============ %
											 peoplenum = NextGridInfo(GRID_INDEX_PEOPLENUM); % �����ܶ�
											 p = peoplenum * 0.18 / (interval_x * interval_y);
											 pc = 0.92; % ���谭ʱ�������ܶ�

											 % ��ȡ��ͨ��������
											 grid_type = NextGridInfo(GRID_INDEX_TYPE);

											 % ����ͨ���ٶ�
											 v3 = (112 * (p ^ 4) - 380 * (p ^ 3) + 434 * (p ^ 2) - 217 * p + 57) / 60;
											 if grid_type == DOOR_POINT % ͨ���ſ�ͨ��
												v3 = (1.17 + 0.13 * sin(6.03 * p - 0.12)) * v3;
											 elseif	grid_type ==  STAIRCASE_POINT % ����¥��ͨ���ٶ�
												v3 = (1.49 - 0.36 * p) * v3;
												if nextval_z == 1 % ��ʾ��¥
													v3 = 0.4887 * v3;
												elseif nextval_z == -1
													v3 = 0.6466 * v3;
												end
											 end


											 R3 = p / pc;      % �����ܶ��µ�Σ��ϵ��
											 Easy3 = v3 / v0;  % �����ܶ��µ�ͨ������ϵ��

											 r_fai3 = 1;
											 easy_gama3 = 1;

											 R_total = R_total * (R3 ^ r_fai3);
											 Easy_total = Easy_total * (Easy3 ^ easy_gama3);

											 % �����ݴ�ͨ����ͨ��ת������Ҫ��ʱ��
											 v_cur = v0 * Easy_total;
											 TempTimes(nextval_x + 2,nextval_y + 2, nextval_z + 2) = dis / v_cur;


										 end


										 %=============== �����˹��Ƴ�Ӱ������ ============= %
										 if (OptimizeTypes(OPTIMIZE_1) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)

											 % �����Ƚ��м��㣬�洢������Ȼ��������
											 exit_nums = size(ExitGrids, 1); % ���ڶ�������������
											 f_x = 0;   % �˹��Ƴ�����ʸ������
											 f_y = 0;
											 f_z = 0;
											 for k = 1 : exit_nums                                                              
												 f_x = f_x + ExitGrids(k, 1);
												 f_y = f_y + ExitGrids(k, 2);
												 f_z = f_z + ExitGrids(k, 3);
											 end

											 fire_nums = size(FireGrids, 1); % ��Դ������ϵĳ�������
											 for k = 1 : fire_nums
												 f_x = f_x - FireGrids(k, 1);
												 f_y = f_y - FireGrids(k, 1);
												 f_z = f_z - FireGrids(k, 1);
											 end

											 % ����˹��Ƴ���������ʸ������F
											 f_x = f_x - (exit_nums - fire_nums) * next_x;
											 f_y = f_y - (exit_nums - fire_nums) * next_y;
											 f_z = f_z - (exit_nums - fire_nums) * next_z;

											 % ǰ������ĵ�λ����nij
											 n_x = nextval_x;
											 n_y = nextval_y;
											 n_z = nextval_z;

											 %�˹��Ƴ������ô�С�Ǻ���Fij����ǰ��λ�÷�������ʸ�����
											 Fijs(nextval_x + 2,nextval_y + 2, nextval_z + 2) = dot([f_x, f_y, f_z], [n_x, n_y, n_z]); 
										 end                                                                                                                                                                                  
									 end
									 P(nextval_x + 2,nextval_y + 2, nextval_z + 2) = p_value;                                                    
%                                                      fprintf('next= (%d, %d, %d)�� P= %d\n',nextval_x, nextval_y, nextval_z, p_value);
								end 
							end
						end
          
						
						% ��P������Ԫ����ͣ�Ȼ����ȡƽ��ֵ  
						P = P / sum(P(:));                               
						%========== �����˹��Ƴ�Ӱ������ ========== %
						if (OptimizeTypes(OPTIMIZE_1) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
							f_cigma = 1;  % �˹��Ƴ�Ӱ�����Ӵ�С
							Fabs = abs(Fijs);
							Fijs = exp(Fijs / sum(Fabs(:)));  
							Fijs = Fijs .^ f_cigma;
							% ���˹��Ƴ�����ת�Ƹ��ʵļ�����
							P = P .* Fijs;
						end
						
						
						% *************** ���̶ķ�ʽѡ����һ������ ******************
						rand_line = rand;
						line = 0;
						NextGrid_Selected = zeros(1, 3);
						
						for temp_size = 1 : nextval_size
							nextval_x = Nextvals(temp_size, 1);
							nextval_y = Nextvals(temp_size, 2);
							nextval_z = Nextvals(temp_size, 3);
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
						
						
						L(j) = L(j) + 1; % ѡ���˳����������ƽ�һ��
						if (L(j) <= grid_size)
							if NextGrid_Selected(1, :) == [0, 0, 0] %��ʾͣ����ԭ��
								Route(j, L(j), :) = [-1, -1, -1];
							else
								% ����ͨ��ʱ��
								Time(j) = Time(j) + TempTimes(NextGrid_Selected(1, 1) + 2, NextGrid_Selected(1, 2) + 2, NextGrid_Selected(1, 3) + 2);
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
%  disp(Eta);
   
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
	Length_min = min(Length);     %�ҵ������Сֵ
	Length_max = max(Length);
	thita = 2.0;                  %��Ϣ���������Ӱ������(�Ż�����4)
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
				temp_deta = Q / Length(i);
				
				% ======= �Ż�����4, �����С·������Ϣ�������Ż� ======== %
				if (OptimizeTypes(OPTIMIZE_4) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
					if Length(i) == Length_min
						temp_deta = temp_deta * thita;
					elseif Length(i) == Length_max
						temp_deta = temp_deta / thita;
					end
				end

				Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) = Delta_Tau(x, y, z, nextval_x, nextval_y, nextval_z) + temp_deta;
			end
		end
		% �˴�ѭ��������·���ϵ���Ϣ������
	end
	
	% =========== �Ż�����3�� ����Ӧ��Ϣ��Ũ�Ȼӷ����� ================= %
	if (OptimizeTypes(OPTIMIZE_3) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
		% �Զ��������Ϣ�ػӷ�����Rhoֵ
		Rho0 = 0.95;
		Rho_min = 0.4;
		fai = 0.95;
		temp_rho = Rho0 * (fai ^ (cycle_times - 1));
		if temp_rho <= Rho_min
			temp_rho = Rho_min;
		end
		Rho = temp_rho;
	end
	
   %************************* ������Ϣ�� ********************* %
   Tau=(1 - Rho) .* Tau + Delta_Tau; % ������Ϣ�ػӷ������º����Ϣ��
	
	% =========== �Ż�����2�� ����Ӧ�����С��Ⱥ�㷨��ֵ ================= %
	if (OptimizeTypes(OPTIMIZE_2) == 1) || (OptimizeTypes(OPTIMIZE_ALL) == 1)
		% �趨�����С��Ⱥ������ֵ
		Rho_k = 0.5;
		L_min = min(Length);
		tau_max = (1 + Rho_k) / (2 * (1 - Rho_k)* L_min) +  (2 * (1 - Rho_k) )/ L_min;
		tau_k = 20;
		tau_min = tau_max / tau_k;

		%����ϢŨ���޶���ֵ Tau = ones(x_max, y_max, z_max, 3, 3, 3, 1)
	   for x = 1 : x_max
	   for y = 1 : y_max
	   for z = 1 : z_max	   
		   for temp_size = 1 : nextval_size
				next_x = Nextvals(temp_size, 1) + 2;
				next_y = Nextvals(temp_size, 2) + 2;
				next_z = Nextvals(temp_size, 3) + 2;
				data_tau =  Tau(x, y, z, next_x, next_y, next_z, 1) ;
				   if data_tau > tau_max
					   data_tau = tau_max;
				   elseif data_tau < tau_min
					   data_tau =  tau_min;
				   end
				   Tau(x, y, z, next_x, next_y, next_z, 1) = data_tau;
		   end
	   end
	   end
	   end
	end
	
   
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




