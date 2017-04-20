%%%%%% 从FDS导出的火灾模拟仿真数据文件中，解析导入初始时刻火灾报警器响起时的火场初始化数据信息%%%%%%%%%%%%%%%

run('BuildingData');


format = '%f%f%f%f%f%f%f';

max_floor = z_max / 2;
max_time = 90;
warning_time = 40;
for i = 1 : max_floor
    for j = warning_time : warning_time
        % 从导出文件中读取数据
        file_name = sprintf('Test%d_%d_%d_Data.txt',i,  j -1, j);
        [a1,a2,a3,a4,a5,a6,a7]=textread(file_name,format,'delimiter', ',','headerlines', 2); % delimiter表示为，格式， headerlines为跳过几行
        cloumns = size(a1, 1);
        az = ones(cloumns, 1);
        z = 2 * (i - 1) + 1;
        az = az .* z;
        DataInfo= [a1,a2,az, a3,a4,a5,a6,a7];

        % 将数据存储到GridInfo中
        m_max = size(DataInfo, 1);
        n_max = size(DataInfo, 2);

    %     fprintf('X max=%d, min=%d; Y max = %d, min=%d\n', max(a1),  min(a1),  max(a2),  min(a2));


        fprintf('cycle=%d\n', i);
        for m = 1 : m_max
                x = DataInfo(m, DATA_ROW_X);
                y = DataInfo(m, DATA_ROW_Y);
                z = DataInfo(m, DATA_ROW_Z);

                if ((x > 0) && (y > 0) && (x <= x_max) && (y <= y_max) ) 
                    fprintf('j = %d, (%d,%d,%d), m =%d\n', j, x, y, z, m);
                    GridInfo(x, y, z, GRID_INDEX_TEMPERATURE) = max(GridInfo( x, y, z, GRID_INDEX_TEMPERATURE) ,DataInfo(m, DATA_ROW_TEMPER)); 
                    GridInfo(x, y, z, GRID_INDEX_SMOKE)                = 1 - max(GridInfo( x, y, z, GRID_INDEX_SMOKE)                , DataInfo(m, DATA_ROW_SMOKE));
                    GridInfo(x, y, z, GRID_INDEX_CO2)                      = max(GridInfo(x, y, z, GRID_INDEX_CO2)                        , DataInfo(m, DATA_ROW_CO2));
                    GridInfo(x, y, z, GRID_INDEX_CO)                         = max(GridInfo( x, y, z, GRID_INDEX_CO)                         ,DataInfo(m, DATA_ROW_CO));
                    GridInfo(x, y, z, GRID_INDEX_O2)                         = max(GridInfo(x, y, z, GRID_INDEX_O2)                          , DataInfo(m, DATA_ROW_O2));
                end 
        end
    end
    
    
   
end
% GridInfo
ss = sprintf('InitiationGridData_%ds.mat', warning_time);
save(ss, 'GridInfo');