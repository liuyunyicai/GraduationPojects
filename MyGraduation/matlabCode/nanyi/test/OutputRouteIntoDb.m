%% ====== �������ɢ·����Ϣд�뵽���ݿ��й���������ȡ ========== %%

%% ��������ǰע������ձ�������
delete_route_sql = sprintf('DELETE FROM %s WHERE 1', TABLE_ROUTE_INFO);
curs = exec(conn, delete_route_sql);

n = size(BestRoute, 2);
step_num = 0;
for i = 1 : (n - 1)
    temp(1, :) = BestRoutes(minIndex, 1, i + 1, :);
    if (temp(1, :) ~= [0, 0, 0]) 
        % ���뵽���ݿ���
        step_num = step_num + 1;
        insert_route_sql =sprintf('INSERT INTO %s(%s,%s, %s, %s) VALUES(%d,%d, %d, %d)',TABLE_ROUTE_INFO, ROW_ROUTE_STEP, ROW_GRID_X, ROW_GRID_Y, ROW_GRID_Z, step_num, BestRoutes(minIndex, 1, i, 1) , BestRoutes(minIndex, 1, i, 2) , BestRoutes(minIndex, 1, i, 3) );
        curs = exec(conn, insert_route_sql);
    end
end