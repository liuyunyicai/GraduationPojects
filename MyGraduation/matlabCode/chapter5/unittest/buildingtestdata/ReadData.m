%%%%%% ��FDS�����Ļ���ģ����������ļ��У����������ʼʱ�̻��ֱ���������ʱ�Ļ𳡳�ʼ��������Ϣ%%%%%%%%%%%%%%%

run('BuildingData');


format = '%f%f%f%f%f%f%f';

max_floor = 1;
for i = 1 : max_floor
    for j = 1 : max_time
        % �ӵ����ļ��ж�ȡ����
        file_name = sprintf('Test%d_%d_Data.txt', j -1, j);
        [a1,a2,a3,a4,a5,a6,a7]=textread(file_name,format,'delimiter', ',','headerlines', 2); % delimiter��ʾΪ����ʽ�� headerlinesΪ��������
        cloumns = size(a1, 1);
        az = ones(cloumns, 1);
        z = 2 * (i - 1) + 1;
        az = az .* z;
        DataInfo= [a1,a2,az, a3,a4,a5,a6,a7];

        % �����ݴ洢��GridInfo��
        m_max = size(DataInfo, 1);
        n_max = size(DataInfo, 2);

    %     fprintf('X max=%d, min=%d; Y max = %d, min=%d\n', max(a1),  min(a1),  max(a2),  min(a2));


        fprintf('cycle=%d\n', i);
        for m = 1 : m_max
                x = DataInfo(m, DATA_ROW_X);
                y = DataInfo(m, DATA_ROW_Y);
                z = DataInfo(m, DATA_ROW_Z);

                if ((x > 0) && (y > 0) ) 
                    GridInfos(j, x, y, z, GRID_INDEX_TEMPERATURE) = max(GridInfos(j, x, y, z, GRID_INDEX_TEMPERATURE) ,DataInfo(m, DATA_ROW_TEMPER)); 
                    GridInfos(j, x, y, z, GRID_INDEX_SMOKE)                = max(GridInfos(j, x, y, z, GRID_INDEX_SMOKE)                , DataInfo(m, DATA_ROW_SMOKE));
                    GridInfos(j, x, y, z, GRID_INDEX_CO2)                      = max(GridInfos(j, x, y, z, GRID_INDEX_CO2)                        , DataInfo(m, DATA_ROW_CO2));
                    GridInfos(j, x, y, z, GRID_INDEX_CO)                         = max(GridInfos(j, x, y, z, GRID_INDEX_CO)                         ,DataInfo(m, DATA_ROW_CO));
                    GridInfos(j, x, y, z, GRID_INDEX_O2)                         = max(GridInfos(j, x, y, z, GRID_INDEX_O2)                          , DataInfo(m, DATA_ROW_O2));
                end 
        end
    end
    
    
   
end
% GridInfo
save('TestFDSInfo.mat', 'GridInfos');