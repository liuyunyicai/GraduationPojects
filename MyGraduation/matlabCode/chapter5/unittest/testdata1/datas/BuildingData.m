%%%% ================ 单元测试：构造数据 =============== %%%%%%
run('ConstantValues');
% 对坐标数据进行栅格化
x_step = 1;
y_step = 1;
z_step = 2;

x_max_miles = 20;
y_max_miles =40;
z_max_miles =8;

x_miles_min = 0;
x_miles_max = 20;

y_miles_min =0;
y_miles_max =40;

info_length = 10;

x_max = (x_miles_max - x_miles_min) / x_step ;
y_max = (y_miles_max - y_miles_min) / y_step;
z_max =z_max_miles / z_step;

GridInfo = zeros(x_max, y_max, z_max, info_length);


for x = 1 : x_max
    for y = 1 : y_max
        for z = 1 : z_max
            if (x == 1) | (x == x_max) | (mod(z, 2) == 0) % z如果为偶数，则表示为中间层
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = BLOCKED_ZONE;
            else
                GridInfo(x, y, z, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
            end 
        end
    end
end 

disp('Data Builded\n');