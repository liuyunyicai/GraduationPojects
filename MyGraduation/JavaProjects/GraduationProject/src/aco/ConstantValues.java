package aco;

/**
 * Created by nealkyliu on 2017/4/5.
 * ��������
 */
public interface ConstantValues {
    // �Ż���������
    int OPTIMIZE_FIRE = 11; // ���𳡲�����Ϣ�������
    int OPTIMIZE_FIRE1 = 12; // ���𳡲�����Ϣ�������
    int OPTIMIZE_FIRE2 = 13; // ���𳡲�����Ϣ�������
    int OPTIMIZE_FIRE3 = 14; // ���𳡲�����Ϣ�������
    int OPTIMIZE_ALL = 15;  // ѡ�������Ż�����
    int OPTIMIZE_10 = 10; // ����ԭʼ����Ⱥ�㷨
    int OPTIMIZE_1 = 1;     // ���õ�����Ż�����
    int OPTIMIZE_2 = 2;
    int OPTIMIZE_3 = 3;
    int OPTIMIZE_4 = 4;
    int OPTIMIZE_5 = 5;
    int OPTIMIZE_6 = 6;
    int OPTIMIZE_7 = 7;
    int OPTIMIZE_8 = 8;
    int OPTIMIZE_9 = 9;
    // GridInfo����ز�����λ��
    int GRID_INDEX_TYPE = 1;
    int GRID_INDEX_ISFREE = 2;
    int GRID_INDEX_TEMPERATURE = 3;
    int GRID_INDEX_SMOKE = 4;
    int GRID_INDEX_O2 = 5;
    int GRID_INDEX_CO = 6;
    int GRID_INDEX_CO2 = 7;
    int GRID_INDEX_PEOPLENUM = 8;

    // ��������
    int EXIT_POINT = 2 ^ 0;   //(����)
    int COMMON_POINT = 2 ^ 1;   //(��ͨͨ��)
    int DOOR_POINT = 2 ^ 2;   //(ͨ����)
    int ELEVATOR_POINT = 2 ^ 3;   //(���ݿ�)
    int STAIRCASE_POINT = 2 ^ 4;   //(¥�ݿ�)
    int FIREHYDRANT_POINT = 2 ^ 5; //(����˨)

    // ����¥���ܹ�ǰ���ķ���
    int STAIR_UP = 1;  // ������
    int STAIR_DOWN = 2; // ������
    int STAIR_IP_DOWN = 0; // ������ͨ��

    // �����ϰ�������
    int ISACCESSED_ZONE = 1; // ��ͨ��
    int BLOCKED_ZONE = 2;      // ���ϰ����赲
    int FIRED_ZONE = 0;//������������
    int DANGER_ZONE = 3;        // Σ������
    int CROWED_ZONE = 4;      // ӵ������

    // �𳡸����ص����ֵ��С
    float DEATH_TEMPERATURE = 120; // �����¶�120��
    float DEATH_O2 = 10;
    float DEATH_CO = 100;
    float DEATH_CO2 = 10;
    float DEATH_PEOPLE_NUM = 1.5f;

    int OUTPUT_ROUTE = 0;
    
    double v0 = 1.33;
    
    int FIRE_LOCKED = 1;
    
    double SEARCH_DEATH_PARAM = 1.2;
}