% ************** 将数据存储到数据库 ********************** %
run('SqlValues');
run('ConstantValues');

% 连接MYSQL数据库
conn =database(DATABASE_NAME, MYSQL_USER, MYSQL_PASSWD, CONN_NAME, DB_URI);

%% 插入数据前注意先清空表中数据
delete_route_sql = sprintf('DELETE FROM %s WHERE 1', TABLE_GRID_INFO);
curs = exec(conn, delete_route_sql);

Data = load('data.mat');
GridInfo = Data.GridInfo;


x_max = size(GridInfo, 1);
y_max = size(GridInfo, 2);
z_max = size(GridInfo, 3);

%% 先插入建筑物整体信息 %%%
delete_param_sql = sprintf('DELETE FROM %s WHERE 1', TABLE_PARAM_INFO);
curs = exec(conn, delete_param_sql);
insert_param_sql = sprintf('INSERT INTO %s(%s, %s, %s, %s, %s, %s,%s) VALUES(%d,%d,%d,%d,%d,%d,%d)', TABLE_PARAM_INFO, ...
                                                      ROW_PARAM_ID, ROW_X_MAX, ROW_Y_MAX, ROW_Z_MAX, ROW_X_INTERVAL, ROW_Y_INTERVAL, ROW_Z_INTERVAL, ...
                                                      1, x_max, y_max, z_max, 1, 1, 2);
curs = exec(conn, insert_param_sql);
fprintf('%s inserted\n', 'param');


count = 0;


for x = 1 :  x_max
    for y = 1 : y_max
        for z = 1 : z_max              
                Values(1, :) = GridInfo(x, y, z,  : );
                
                if (Values(1) ~= BLOCKED_ZONE) 
                     count = count + 1;
                    insert_grid_sql =sprintf('INSERT INTO %s(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s) VALUES(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)', ...
                    TABLE_GRID_INFO, ROW_GRID_ID, ROW_GRID_X, ROW_GRID_Y, ROW_GRID_Z, ROW_GRID_TYPE, ROW_GRID_ISFREE, ROW_GRID_TEMPERATURE, ...
                    ROW_GRID_SMOKE, ROW_GRID_O2,ROW_GRID_CO, ROW_GRID_CO2, ROW_GRID_PEOPLENUM, ...
                    count, x, y, z, Values(1), Values(2), Values(3), Values(4), Values(5), Values(6), Values(7), Values(8));
                    curs = exec(conn, insert_grid_sql);

                    fprintf('%d inserted\n', count);
                end
                
                
        end
    end
end