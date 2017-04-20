%% ==== ����x1,x4���α߽�ֵ����λΪm�����դ��ģ�����µ�Grid��Χ ========%%

function [GridScale] = getGridScale(x1, x4, y1, y4)
    run('NanyiConstant');
    GridScale = zeros(1, 4);
    GridScale(1) = max(1, changeToGrid(x1, TYPE_X));
    GridScale(2) = changeToGrid(x4, TYPE_X) ;
    GridScale(3) = changeToGrid(y1, TYPE_Y);
    GridScale(4) = changeToGrid(y4, TYPE_Y);