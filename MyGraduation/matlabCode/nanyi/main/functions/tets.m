% �����ݲ��뵽���ݿ�
if fire_zone_num > 0
    InitDataIntoDb(FiredZone, TABLE_FIRE_INFO);
end

if danger_zone_num > 0
    InitDataIntoDb(DangerZone, TABLE_DANGER_INFO);
end

if crowed_zone_num > 0
    InitDataIntoDb(CrowedZone, TABLE_CROWED_INFO);
end

%% ======= �������Ϣ��������ݿ��й���������ȡ�����͸��ͻ��� ============= %%
run('OutputRouteIntoDb');