run('SqlValues');

% ����MYSQL���ݿ�
conn =database(DATABASE_NAME, MYSQL_USER, MYSQL_PASSWD, CONN_NAME, DB_URI);

%% ��������ǰע������ձ�������
delete_route_sql = sprintf('DELETE FROM %s WHERE 1', TABLE_ROUTE_INFO);
curs = exec(conn, delete_route_sql);

insert_route_sql =sprintf('INSERT INTO %s(%s, %s, %s) VALUES(%d, %d, %d)',TABLE_ROUTE_INFO, ROW_GRID_X, ROW_GRID_Y, ROW_GRID_Z, 1, 1, 1);
curs = exec(conn, insert_route_sql);

% ���GridInfo��
delete_grid_sql = sprintf('DELETE FROM %s WHERE 1', TABLE_GRID_INFO);