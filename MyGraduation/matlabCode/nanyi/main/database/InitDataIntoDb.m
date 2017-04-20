%%%%%%%% �����ݿ��в������� %%%%%%%%%%%%%
function [] = InitDataIntoDb(DataZones, type)

run('SqlValues');

% ����MYSQL���ݿ�
conn =database(DATABASE_NAME, MYSQL_USER, MYSQL_PASSWD, CONN_NAME, DB_URI);

%% ��������ǰע������ձ�������
delete_route_sql = sprintf('DELETE FROM %s WHERE 1', type);
curs = exec(conn, delete_route_sql);

if strcmp(type, TABLE_FIRE_INFO)
    ROW_ID = ROW_FIRE_ID;
elseif strcmp(type, TABLE_DANGER_INFO)
    ROW_ID = ROW_DANDER_ID;
elseif strcmp(type, TABLE_CROWED_INFO)
    ROW_ID = ROW_CROWED_ID;
end

zone_size = size(DataZones, 1);

for i = 1 : zone_size
    insert_route_sql =sprintf('INSERT INTO %s(%s, %s, %s) VALUES(%d, %d, %d)',type, ROW_GRID_X, ROW_GRID_Y, ROW_GRID_Z, DataZones(i, 1), DataZones(i, 2), DataZones(i, 3));
    curs = exec(conn, insert_route_sql);
end




