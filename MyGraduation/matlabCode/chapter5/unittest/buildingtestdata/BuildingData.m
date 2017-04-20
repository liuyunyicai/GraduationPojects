%%%% ================ 单元测试：构造数据 =============== %%%%%%
run('ConstantValues');
TYPE_X = 1;
TYPE_Y = 2;
TYPE_Z = 3;

% 对坐标数据进行栅格化
x_step = 1;
y_step = 1;
z_step = 2;

x_max_miles = 20;
y_max_miles =40;
z_max_miles =4;

x_miles_min = 0;
x_miles_max = 20;

y_miles_min =0;
y_miles_max =40;




x_max = (x_miles_max - x_miles_min) / x_step ;
y_max = (y_miles_max - y_miles_min) / y_step;
z_max =z_max_miles / z_step;

max_time = 150;
info_length = 10;


GridInfos = zeros(max_time, x_max, y_max, z_max, info_length);

% 全部设置为障碍物
for times = 1 : max_time
     for x = 1 : x_max
        for y = 1 : y_max
            for z = 1 : z_max
                GridInfos(times, x, y, z, GRID_INDEX_ISFREE) = ISACCESSED_ZONE;
            end
        end
    end
end


disp('Data Builded\n');