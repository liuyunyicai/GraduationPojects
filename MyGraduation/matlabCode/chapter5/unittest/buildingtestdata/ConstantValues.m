% �Ż���������
OPTIMIZE_FIRE = 11; % ���𳡲�����Ϣ�������
OPTIMIZE_FIRE1 = 12; % ���𳡲�����Ϣ�������
OPTIMIZE_FIRE2 = 13; % ���𳡲�����Ϣ�������
OPTIMIZE_FIRE3 = 14; % ���𳡲�����Ϣ�������
OPTIMIZE_ALL = 15;  % ѡ�������Ż�����
OPTIMIZE_10 = 10; % ����ԭʼ����Ⱥ�㷨
OPTIMIZE_1 = 1;     % ���õ�����Ż�����
OPTIMIZE_2 = 2;
OPTIMIZE_3 = 3;
OPTIMIZE_4 = 4;
OPTIMIZE_5 = 5;
OPTIMIZE_6 = 6;
OPTIMIZE_7 = 7;
OPTIMIZE_8 = 8;
OPTIMIZE_9 = 9;
% GridInfo����ز�����λ��
GRID_INDEX_TYPE        = 1;
GRID_INDEX_ISFREE      = 2;
GRID_INDEX_TEMPERATURE = 3;
GRID_INDEX_SMOKE       = 4;
GRID_INDEX_O2          = 5;
GRID_INDEX_CO          = 6;
GRID_INDEX_CO2         = 7;
GRID_INDEX_PEOPLENUM   = 8;

% ��������
EXIT_POINT      = 2 ^ 0;   %(����)
COMMON_POINT    = 2 ^ 1;   %(��ͨͨ��)
DOOR_POINT      = 2 ^ 2;   %(ͨ����)
ELEVATOR_POINT  = 2 ^ 3;   %(���ݿ�)
STAIRCASE_POINT = 2 ^ 4;   %(¥�ݿ�)
FIREHYDRANT_POINT = 2 ^ 5; %(����˨) 

% ����¥���ܹ�ǰ���ķ���
STAIR_UP = 1;  % ������
STAIR_DOWN = 2; % ������
STAIR_IP_DOWN = 0; % ������ͨ��

% �����ϰ�������
ISACCESSED_ZONE = 1; % ��ͨ��
BLOCKED_ZONE = 2;      % ���ϰ����赲
FIRED_ZONE = 0;%������������

% �𳡸����ص����ֵ��С
DEATH_TEMPERATURE = 120; % �����¶�120��
DEATH_O2 = 10;
DEATH_CO = 100;
DEATH_CO2 = 10;
DEATH_PEOPLE_NUM = 1.5;

%DATA������ÿ�����ݶ�Ӧ��λ��
DATA_ROW_X = 1;
DATA_ROW_Y = 2;
DATA_ROW_Z = 3;
DATA_ROW_TEMPER =4;
DATA_ROW_SMOKE = 5;
DATA_ROW_CO2 = 6;
DATA_ROW_CO = 7;
DATA_ROW_O2= 8;