function [index] = changeToGrid(coord, type)
% 指坐标值
% 指坐标转换类型：比如X轴转换
run('NanyiConstant');
if type == TYPE_X
    index = (coord + x_max_miles) / x_step;
elseif type == TYPE_Y
    index = (coord + y_max_miles) / y_step;
else
    index = coord;
end
index = round(index);
