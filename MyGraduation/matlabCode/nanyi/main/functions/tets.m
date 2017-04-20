% 将数据插入到数据库
if fire_zone_num > 0
    InitDataIntoDb(FiredZone, TABLE_FIRE_INFO);
end

if danger_zone_num > 0
    InitDataIntoDb(DangerZone, TABLE_DANGER_INFO);
end

if crowed_zone_num > 0
    InitDataIntoDb(CrowedZone, TABLE_CROWED_INFO);
end

%% ======= 将结果信息输出到数据库中供服务器读取，发送给客户端 ============= %%
run('OutputRouteIntoDb');