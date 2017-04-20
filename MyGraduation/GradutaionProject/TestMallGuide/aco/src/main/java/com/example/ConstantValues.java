package com.example;

/**
 * Created by nealkyliu on 2017/4/5.
 * 基本常量
 */
public class ConstantValues {
    // 优化策略类型
    public static final int OPTIMIZE_FIRE = 11; // 将火场参数信息引入进来
    public static final int OPTIMIZE_FIRE1 = 12; // 将火场参数信息引入进来
    public static final int OPTIMIZE_FIRE2 = 13; // 将火场参数信息引入进来
    public static final int OPTIMIZE_FIRE3 = 14; // 将火场参数信息引入进来
    public static final int OPTIMIZE_ALL = 15;  // 选用所有优化策略
    public static final int OPTIMIZE_10 = 10; // 采用原始的蚁群算法
    public static final int OPTIMIZE_1 = 1;     // 采用单项的优化策略
    public static final int OPTIMIZE_2 = 2;
    public static final int OPTIMIZE_3 = 3;
    public static final int OPTIMIZE_4 = 4;
    public static final int OPTIMIZE_5 = 5;
    public static final int OPTIMIZE_6 = 6;
    public static final int OPTIMIZE_7 = 7;
    public static final int OPTIMIZE_8 = 8;
    public static final int OPTIMIZE_9 = 9;
    // GridInfo中相关参数的位置
    public static final int GRID_INDEX_TYPE = 1;
    public static final int GRID_INDEX_ISFREE = 2;
    public static final int GRID_INDEX_TEMPERATURE = 3;
    public static final int GRID_INDEX_SMOKE = 4;
    public static final int GRID_INDEX_O2 = 5;
    public static final int GRID_INDEX_CO = 6;
    public static final int GRID_INDEX_CO2 = 7;
    public static final int GRID_INDEX_PEOPLENUM = 8;

    // 出口类型
    public static final int EXIT_POINT = 2 ^ 0;   //(出口)
    public static final int COMMON_POINT = 2 ^ 1;   //(普通通道)
    public static final int DOOR_POINT = 2 ^ 2;   //(通道口)
    public static final int ELEVATOR_POINT = 2 ^ 3;   //(电梯口)
    public static final int STAIRCASE_POINT = 2 ^ 4;   //(楼梯口)
    public static final int FIREHYDRANT_POINT = 2 ^ 5; //(消防栓)

    // 表征楼梯能够前进的方向
    public static final int STAIR_UP = 1;  // 可上行
    public static final int STAIR_DOWN = 2; // 可下行
    public static final int STAIR_IP_DOWN = 0; // 可上下通行

    // 表征障碍物性质
    public static final int ISACCESSED_ZONE = 1; // 可通行
    public static final int BLOCKED_ZONE = 2;      // 有障碍物阻挡
    public static final int FIRED_ZONE = 0;//火灾死亡区域
    public static final int DANGER_ZONE = 3;        // 危险区域
    public static final int CROWED_ZONE = 4;      // 拥挤区域

    // 火场各因素的最大值大小
    public static final float DEATH_TEMPERATURE = 120; // 死亡温度120度
    public static final float DEATH_O2 = 10;
    public static final float DEATH_CO = 100;
    public static final float DEATH_CO2 = 10;
    public static final float DEATH_PEOPLE_NUM = 1.5f;

    public static final int OUTPUT_ROUTE = 0;
}
