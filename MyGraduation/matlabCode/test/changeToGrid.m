function [index] = changeToGrid(coord, type)
% ָ����ֵ
% ָ����ת�����ͣ�����X��ת��
run('NanyiConstant');
if type == TYPE_X
    index = (coord + x_max_miles) / x_step;
elseif type == TYPE_Y
    index = (coord + y_max_miles) / y_step;
else
    index = coord;
end
index = round(index);
