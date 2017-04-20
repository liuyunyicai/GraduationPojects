%% ===================== 画出最后的算法优化结果 ============== %%
clear;
run('ConstantValues');
run('BuildingInitiation');

% Data =  load('ResultData_P5_1.mat');

Data =  load('ResultData_P4_1.mat');

grid = Data.a;
x_max = size(grid, 1);
y_max = size(grid, 2);
z_max = size(grid, 3);

Length = Data.Length;
minLength = min(Length);
minIndexs = find(Length == minLength(1));
minIndex = minIndexs(1);

% PreferedGrids = Data.PreferedGrids;
BestRoutes = Data.BestRoutes;
% BestRoutes = RoutesData.BestRoutes;

for z = 1 :  z_max / 2
    z_index = 2 * z - 1;
    data = grid(:, :, z_index);
    data1 = grid(:, :, z_index);
    data2 = grid(:, :, z_index);
    data3 = grid(:, :, z_index);
    data4 = grid(:, :, z_index);
    for i = 1 : x_max
        for j = 1 : y_max
            if data(i, j) == ISACCESSED_ZONE
                data(i, j) = 0;
                data1(i, j) = 0;
                data2(i, j) = 0;
                data3(i, j) = 0;
                data4(i, j) = 0;
            elseif data(i, j) == BLOCKED_ZONE
                data(i, j) = 1;
                data1(i, j) = 1;
                data2(i, j) = 0;
                data3(i, j) = 0;
                data4(i, j) = 0;
            elseif data(i, j) == FIRED_ZONE
                data(i, j) = 0.001;
                data1(i, j) = 0;
                data2(i, j) = 0;
                data3(i, j) = 0;
                data4(i, j) = 0;
            elseif data(i, j) == DANGER_ZONE
                data(i, j) = 0;
                data1(i, j) = 0;
                data2(i, j) = 0;
                data3(i, j) = 0.001;
                data4(i, j) = 0;
            elseif data(i, j) == CROWED_ZONE
                data(i, j) = 0;
                data1(i, j) = 0;
                data2(i, j) = 0;
                data3(i, j) = 0;
                data4(i, j) = 0.001;
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
    hold on;
    bar3(data3, scale, 'yellow');
    hold on;
    bar3(data4, scale, 'm');
    title(['Floor' num2str(z)]); 
    axis image ij off
    hold on;
    bar3(data1, scale, 'white');
    
     % 绘制疏散路径
    hold on;
    n = size(BestRoutes, 3);
    for i = 1 : (n - 1)
        temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
        if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z_index)
            plot([BestRoutes(minIndex, 1, i, 2)  , BestRoutes(minIndex, 1, i + 1, 2) ] , [BestRoutes(minIndex, 1, i, 1), BestRoutes(minIndex, 1, i + 1, 1)  ], 'g' , 'LineWidth',4);
        end
    end
    
end

