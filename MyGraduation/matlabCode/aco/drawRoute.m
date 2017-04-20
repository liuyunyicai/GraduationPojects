function [r] = drawRoute(BestRoutes, minIndex, z_index, color)
% ªÊ÷∆ Ë…¢¬∑æ∂
    hold on;
    n = size(BestRoutes, 3);
    for i = 1 : (n - 1)
        temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
        if (temp(1, :) ~= [0, 0, 0]) & (BestRoutes(minIndex, 1, i, 3) == z_index)
            r = plot([BestRoutes(minIndex, 1, i, 2)  , BestRoutes(minIndex, 1, i + 1, 2) ] , [BestRoutes(minIndex, 1, i, 1), BestRoutes(minIndex, 1, i + 1, 1)  ], color, 'LineWidth',3);
        end
    end