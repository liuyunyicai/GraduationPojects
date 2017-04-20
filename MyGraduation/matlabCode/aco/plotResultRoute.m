%% ===================== 画出最后的算法优化结果 ============== %%
clear;
run('ConstantValues');

Data =  load('ResultData_OP1_TEST_Final_1.mat');
Data2 =  load('ResultData_OP2_TEST_Final_1.mat');
Data3 =  load('ResultData_OP3_TEST_Final_1.mat');

grid = Data.a;
x_max = size(grid, 1);
y_max = size(grid, 2);
z_max = size(grid, 3);

Length = Data.Length;
minLength = max(Length);
minIndexs = find(Length == minLength(1));
minIndex = minIndexs(1);

Length2 = Data2.Length;
minLength2 = min(Length2);
minIndexs2 = find(Length2 == minLength2(1));
minIndex2 = minIndexs2(1);

Length3 = Data3.Length;
minLength3 = min(Length3);
minIndexs3 = find(Length3 == minLength3(1));
minIndex3 = minIndexs3(1);

PreferedGrids = Data.PreferedGrids;
BestRoutes = Data.BestRoutes;
BestRoutes2 = Data2.BestRoutes;
BestRoutes3 = Data3.BestRoutes;

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

    scale = 1;
    figure;
    bar3(data2, scale, 'b');
    hold on;
    bar3(data, scale, 'red');
    title(['Floor' num2str(z)]); 
    axis image ij off
    hold on;
    bar3(data1, scale, 'white');
    
     % 绘制疏散路径
%     hold on;
%     n = size(BestRoutes, 3);
%     for i = 1 : (n - 1)
%         temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
%         if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z_index)
%             plot([BestRoutes(minIndex, 1, i, 2)  , BestRoutes(minIndex, 1, i + 1, 2) ] , [BestRoutes(minIndex, 1, i, 1), BestRoutes(minIndex, 1, i + 1, 1)  ], 'g' , 'LineWidth',4);
%         end
%     end
    r1 = drawRoute(BestRoutes, minIndex, z_index, 'g');
%     r2 = drawRoute(BestRoutes2, minIndex2, z_index, 'y');
    r3 = drawRoute(BestRoutes3, minIndex3, z_index, 'm');
%     legend([r1, r2, r3],'类人工势场影响力优化', '自适应信息素更新策略优化', '火场因素优化');
    
end

