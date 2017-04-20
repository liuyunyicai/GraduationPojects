% �Ż���������
OPTIMIZE_FIRE = 11; % ���𳡲�����Ϣ�������
OPTIMIZE_ALL = 12;  % ѡ�������Ż�����
OPTIMIZE_NONE = 10; % ����ԭʼ����Ⱥ�㷨
OPTIMIZE_1 = 1;     % ���õ�����Ż�����
OPTIMIZE_2 = 2;
OPTIMIZE_3 = 3;
OPTIMIZE_4 = 4;
OPTIMIZE_5 = 5;
OPTIMIZE_6 = 6;
OPTIMIZE_7 = 7;

x_grid = 30;
y_grid = 30;
z_grid = 6;

GridInfo = rand(x_grid, y_grid, z_grid, 10);
x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

TempTest = [
    0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0; 
    0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0; 
    0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
    ];
TempTest1 = [TempTest TempTest];
Test = [TempTest1; TempTest1];
%¥��ײ㣬��������¥�ݳ���
Floor = ones(30, 30);
Floor(15,15) = 0;

Data = zeros(x_grid, y_grid, z_grid);
Data(:,:,1) = Test(:,:);
Data(:,:,3) = Test(:,:);
Data(:,:,5) = Test(:,:);

Data(:,:,2) = Floor(:,:);
Data(:,:,4) = Floor(:,:);
Data(:,:,6) = Floor(:,:);


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
 for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            if Test(x,y) == 1
                GridInfo(x, y, z, 2) = 0;
            else 
                GridInfo(x, y, z, 2) = 1;
            end
        end        
    end
end




EntranceGrid = [2, 1, 1];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), 2) = 1;
% ExitGrids = [2, 19, 1;
%                         10, 8, 1];
ExitGrids = [x_max, y_max, z_max];
n = size(ExitGrids, 1);
for k = 1 : n
    GridInfo(ExitGrids(k, 1), ExitGrids(k, 2), ExitGrids(k, 3), 2) = 1;
end
                    
cycle_max = 10;
ant_num = 200;

% cycle_max = 1;
% ant_num = 1;

Alpha = 1.0;
Beta = 1.0;
Rho = 0.5;
Q = 1.5;
AcoParameters = [Alpha, Beta, Rho, Q];

FireGrids = []; % �Ż��λ��
GridParameters = [1 1 1]; % դ�񷨽�ģ��ز���
OptimizeTypes = zeros(1, OPTIMIZE_ALL);
%OptimizeTypes(OPTIMIZE_1) = 1;

FireParameters = [5 0];

%======================== ���в��� =======================%
% ��Ҫ��¼��������
% 10�ε�����ʱ��T(10)������ƽ������ʱ��t
% 10�ε����·������Length��10����������̳�����ƽ������
% �����ٶ�
Nmax = 1; % ָ���ԵĴ���
Time = zeros(Nmax);  % �㷨����ʱ��
Length = zeros(Nmax); % ���·��

grid_size = x_max *  y_max * z_max;
BestRoutes = zeros(Nmax, 1, grid_size, 3);

for N = 1 : Nmax
    t1 = clock;
    [CycleRoute, CycleLength, CycleMean, BestRoute ,best_length] = ACO(GridInfo, EntranceGrid, ExitGrids, FireGrids, cycle_max, ant_num, AcoParameters, GridParameters, OptimizeTypes, FireParameters);
    t2 = clock;
    Time(N) = etime(t2,t1);
    Length(N) = best_length;
    BestRoutes(N, :) = BestRoute(:);
end

%% ============== ���������������ó��Ľ�� ================= %%
minLength = min(Length);
minIndex = find(Length == minLength(1));
figure;
% ��ִ·������
subplot(2, 2, 1);    
a = zeros(x_max, y_max, z_max);
for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            a(x, y, z) = GridInfo(x, y, z, 2);
        end
    end
end
b = a;
b(end + 1, end + 1) = 0;
colormap([0 0 1; 1 1 1]) , pcolor(b);
axis image ij off
disp(b);

hold on;
n = size(BestRoute, 2);
for i = 1 : (n - 1)
    temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
    if temp(1, :) ~= [0, 0, 0]
        plot([BestRoutes(minIndex, 1, i, 2) + 0.5 , BestRoutes(minIndex, 1, i + 1, 2) + 0.5] , [BestRoutes(minIndex, 1, i, 1) + 0.5, BestRoutes(minIndex, 1, i + 1, 1) + 0.5 ], 'r' );
    end
end

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


