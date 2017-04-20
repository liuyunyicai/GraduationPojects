package com.example;

/**
 * Created by nealkyliu on 2017/4/5.
 */
public class OutputDatas {
    private int[][][] mCycleRoute;// zeros(cycle_max, max_step + 1, dimen_num); % 记录每次迭代中的最佳路径
    private int[] mCycleLength; // ones(cycle_max, 1);               % 记录每次迭代中的最佳路径长度
    private int[] mCycleMean;   // zeros(cycle_max, 1);                     % 记录每次迭代中的路径的平均长度
    private int[] mCycleTime;   // ones(cycle_max, 1);               % 记录每次迭代中的最佳路径疏散时间
    private int[] mCycleTimeMean; // zeros(cycle_max, 1);                     % 记录每次迭代中的路径的平均疏散时间
    private int[] mAntArriveTimes; // zeros(cycle_max, 1);                % 记录到到达终点的蚂蚁数目

    public OutputDatas() {
    }

    public OutputDatas(int[][][] mCycleRoute, int[] mCycleLength, int[] mCycleMean, int[] mCycleTime, int[] mCycleTimeMean, int[] mAntArriveTimes) {
        this.mCycleRoute = mCycleRoute;
        this.mCycleLength = mCycleLength;
        this.mCycleMean = mCycleMean;
        this.mCycleTime = mCycleTime;
        this.mCycleTimeMean = mCycleTimeMean;
        this.mAntArriveTimes = mAntArriveTimes;
    }

    private OutputDatas(int cycle_max, int max_step) {
        mCycleRoute = new int[cycle_max][max_step + 1][3];
        mCycleMean = new int[cycle_max];
        mCycleLength = new int[cycle_max];
        mCycleTime = new int[cycle_max];
        mCycleTimeMean = new int[cycle_max];
        mAntArriveTimes = new int[cycle_max];
    }

    /** 获取结果的构造函数**/
    public OutputDatas getInstance(int cycle_max, int max_step) {
        OutputDatas instance = new OutputDatas(cycle_max, max_step);
        return instance;

    }

    public int[][][] getCycleRoute() {
        return mCycleRoute;
    }

    public void setCycleRoute(int[][][] mCycleRoute) {
        this.mCycleRoute = mCycleRoute;
    }

    public int[] getCycleLength() {
        return mCycleLength;
    }

    public void setCycleLength(int[] mCycleLength) {
        this.mCycleLength = mCycleLength;
    }

    public int[] getCycleMean() {
        return mCycleMean;
    }

    public void setCycleMean(int[] mCycleMean) {
        this.mCycleMean = mCycleMean;
    }

    public int[] getCycleTime() {
        return mCycleTime;
    }

    public void setCycleTime(int[] mCycleTime) {
        this.mCycleTime = mCycleTime;
    }

    public int[] getCycleTimeMean() {
        return mCycleTimeMean;
    }

    public void setCycleTimeMean(int[] mCycleTimeMean) {
        this.mCycleTimeMean = mCycleTimeMean;
    }

    public int[] getAntArriveTimes() {
        return mAntArriveTimes;
    }

    public void setAntArriveTimes(int[] mAntArriveTimes) {
        this.mAntArriveTimes = mAntArriveTimes;
    }
}
