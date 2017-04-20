run('ReadNanyiData');

%% =============== ������Ⱥ�㷨���ϵ�� ================== %%
cycle_max = 20;
ant_num = 30;

% cycle_max = 1;
% ant_num = 1;

Alpha = 1.0;
Beta = 1.0;
Rho = 0.5;
Q = 10;
AcoParameters = [Alpha, Beta, Rho, Q];

GridParameters = [1 1 1]; % դ�񷨽�ģ��ز���
%% ====================== �����Ż����� ============== %% 
OptimizeTypes = zeros(1, OPTIMIZE_ALL); % �Ż�����
OptimizeTypes(OPTIMIZE_7) = 1;
OptimizeTypes(OPTIMIZE_1) = 1;
OptimizeTypes(OPTIMIZE_3) = 1;
OptimizeTypes(OPTIMIZE_4) = 1;
% OptimizeTypes(OPTIMIZE_2) = 1;
OptimizeTypes(OPTIMIZE_8) = 1;
% OptimizeTypes(OPTIMIZE_FIRE) = 1;
% OptimizeTypes(OPTIMIZE_FIRE1) = 1;
% OptimizeTypes(OPTIMIZE_FIRE2) = 1;
% OptimizeTypes(OPTIMIZE_FIRE3) = 1;

FireParameters = [5 0];

%======================== ���в��� =======================%
% ��Ҫ��¼��������
% 10�ε�����ʱ��T(10)������ƽ������ʱ��t
% 10�ε����·������Length��10����������̳�����ƽ������
% �����ٶ�
Nmax = 5; % ָ���ԵĴ���
Time = zeros(Nmax);  % �㷨����ʱ��
Length = zeros(Nmax); % ���·��

grid_size = x_max *  y_max * z_max;
max_step = 1000;
BestRoutes = zeros(Nmax, 1, max_step + 1, 3);

for N = 1 : Nmax
    t1 = clock;
    [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length] = ACO5(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters, max_step, PreferedGrids);
    t2 = clock;
    Time(N) = etime(t2,t1);
    Length(N) = best_length;
    BestRoutes(N, :) = BestRoute(:);
end

%% ============== ���������������ó��Ľ�� ================= %%
minLength = min(Length);
minIndex = find(Length == minLength(1));
% ����·������
subplot(2, 2, 1);    
a = zeros(x_max, y_max, z_max);
for z = 1 : z_max
    for x = 1 : x_max
        for y = 1 : y_max
            a(x, y, z) = GridInfo(x, y, z, 2);
        end
    end
    if mod(z, 2) ~= 0
        figure;
        % ������ά����
        title(['Floor' num2str((z + 1) / 2)]); 
        b = a(:, :, z);
        b(end + 1, end + 1) = 0;
        colormap([239/255,65/255,53/255; 1 1 1; 0 0 1; ]) , pcolor(b);
        axis image ij off
        disp(b);

        % ������ɢ·��
        hold on;
        n = size(BestRoute, 2);
        for i = 1 : (n - 1)
            temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
            if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z)
                plot([BestRoutes(minIndex, 1, i, 2) + 0.5 , BestRoutes(minIndex, 1, i + 1, 2) + 0.5] , [BestRoutes(minIndex, 1, i, 1) + 0.5, BestRoutes(minIndex, 1, i + 1, 1) + 0.5 ], 'r' );
            end
        end
        
        % ���ƻ�������
        hold on;
        fill([0 1 1 0],[0 0 1 1],'r');
    end
end


figure;
% ������Ⱥ�㷨�����������
subplot(2, 2, 2);                                % ���Ƶڶ�����ͼ��
plot(CycleLength);
hold on;                                         % ����ͼ��
plot(CycleMean, 'r');
title('ƽ���������̾���');                       % ����

% ����ʱ������
hold on;
subplot(2, 2, 3); 
plot(Time);
title('����ʱ��');
ylabel('����ʱ��/s');
xlabel('�������/��');
meanTime = mean(Time)

% �������·������
hold on;
subplot(2, 2, 4);  
plot(Length);
title('���·������');
ylabel('���·������/m');
xlabel('�������/��');
meanLength = mean(Length)

% GreedySearch(GridInfo, EntranceGrid, ExitGrids);