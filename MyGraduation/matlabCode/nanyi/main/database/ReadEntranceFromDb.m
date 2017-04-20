%% ===========从数据库中读取当前用户入口点位置，即用户的当前位置=============%%

run('SqlValues');
% 连接MYSQL数据库
conn =database(DATABASE_NAME, MYSQL_USER, MYSQL_PASSWD, CONN_NAME, DB_URI);

read_entrance_sql = sprintf('SELECT * FROM %s order by %s desc limit 1', TABLE_ENTRANCE_INFO, ROW_ENTRANCE_ID);
curs = exec(conn, read_entrance_sql);
curs=fetch(curs);
cur = cell2mat(curs.Data);

EntranceGrid =[cur(DATA_ROW_X + 1), cur(DATA_ROW_Y + 1), cur(DATA_ROW_Z + 1) ];
GridInfo(EntranceGrid(1), EntranceGrid(2), EntranceGrid(3), GRID_INDEX_ISFREE) = ISACCESSED_ZONE;