%% ===================== ���������㷨�Ż���� ============== %%
clear;
run('ConstantValues');

Data =  load('ResultData_OP00_TEST_Final_5.mat');
Data2 =  load('ResultData_OP2_TEST_Final_3.mat');
Data3 =  load('ResultData_OP0_TEST_Final_5.mat');

grid = Data.a;
x_max = size(grid, 1);
y_max = size(grid, 2);
z_max = size(grid, 3);

Length = Data.Length;
minLength = min(Length);
minIndexs = find(Length == minLength(1));
minIndex = minIndexs(1);

PreferedGrids = Data.PreferedGrids;
BestRoutes = Data.BestRoutes;

for z = 1 :  z_max / 2
    z_index = 2 * z - 1;
    data = grid(:, :, z_index);
    data1 = grid(:, :, z_index);
    data2 = grid(:, :, z_index);
    for i = 1 : x_max
        for j = 1 : y_max
            if data(i, j) == ISACCESSED_ZONE
                data(i, j) = 0;
                data1(i, j) = 0;
                data2(i, j) = 0;
            elseif data(i, j) == BLOCKED_ZONE
                data(i, j) = 1;
                data1(i, j) = 1;
                data2(i, j) = 0;
            elseif data(i, j) == FIRED_ZONE
                data(i, j) = 0.001;
                data1(i, j) = 0;
                data2(i, j) = 0;
            end
        end
    end
    
    for i = 1 : size(PreferedGrids, 1) 
        if PreferedGrids(i, 3) == z_index
            data2(PreferedGrids(i, 1), PreferedGrids(i, 2)) = 0.001;
        end
    end

%     scale = 1;
%     figure;
%     bar3(data2, scale, 'b');
%     hold on;
%     bar3(data, scale, 'red');
%     title(['Floor' num2str(z)]); 
%     axis image ij off
%     hold on;
%     bar3(data1, scale, 'white');
%     
%      % ������ɢ·��
%     hold on;
%     n = size(BestRoutes, 3);
%     for i = 1 : (n - 1)
%         temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
%         if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z_index)
%             plot([BestRoutes(minIndex, 1, i, 2)  , BestRoutes(minIndex, 1, i + 1, 2) ] , [BestRoutes(minIndex, 1, i, 1), BestRoutes(minIndex, 1, i + 1, 1)  ], 'g' , 'LineWidth',4);
%         end
%     end
    
end

% figure;
% % ������Ⱥ�㷨�����������
% plot(Data.CycleLength, 'g');
% hold on;
% plot(Data2.CycleLength, 'y');
% hold on;
% plot(Data3.CycleLength, 'm');
% title('�㷨���������������ɢ����ͳ��');                       % ����
% ylabel('�����ɢ����/m');
% xlabel('��������/��');

% figure;
% hold on;
% plot(Data.CycleMean, 'g');
% hold on;
% % plot(Data2.CycleMean, 'y');
% hold on;
% plot(Data3.CycleMean, 'm');
% title('�㷨����������ƽ����ɢ����ͳ��');                       % ����
% ylabel('ƽ����ɢ����/m');
% xlabel('��������/��');


% ����ʱ������
% figure;
% plot(Data.Time, 'g');
% hold on;
% % plot(Data2.Time, 'y');
% % hold on;
% plot(Data3.Time, 'm');
% title('�㷨����ʱ��ͳ��');
% ylabel('�㷨����ʱ��/s');
% xlabel('ʵ�����/��');
% meanTime = mean(Data.Time)

% �������·������


% figure;
% plot(Data.Length, 'g');
% hold on;
% % plot(Data2.Length, 'm');
% hold on;
% plot(Data3.Length, 'm');
% title('�����ɢ·������ͳ��');
% ylabel('�����ɢ·������/m');
% xlabel('ʵ�����/��');
% ylim([20 100]);
% meanLength = mean(Data.Length);

% �������д���
figure;
size = size(Data.AllAntArriveTimes, 1);
for i = 1 : 1
    hold on;
    plot(Data.AllAntArriveTimes(i, :) / 200, 'g');
    hold on;
%     plot(Data2.AllAntArriveTimes(i, :) / 30, 'y');
    hold on;
    plot(Data3.AllAntArriveTimes(i, :) / 20, 'm');
end
ylim([0 1.1]);
title('�����յ����ϱ���ͳ��');
ylabel('�ﵽ�յ�����ռ�����ϵı���');
xlabel('��������/��');



