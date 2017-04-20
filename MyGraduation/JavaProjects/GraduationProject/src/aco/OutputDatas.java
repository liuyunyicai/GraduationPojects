package aco;

public class OutputDatas {
    public int[][][] mCycleRoute;// zeros(cycle_max, max_step + 1, dimen_num); % 记录每次迭代中的最佳路径
    public double[] mCycleLength; // ones(cycle_max, 1);               % 记录每次迭代中的最佳路径长度
    public double[] mCycleMean;   // zeros(cycle_max, 1);                     % 记录每次迭代中的路径的平均长度
    public double[] mCycleTime;   // ones(cycle_max, 1);               % 记录每次迭代中的最佳路径疏散时间
    public double[] mCycleTimeMean; // zeros(cycle_max, 1);                     % 记录每次迭代中的路径的平均疏散时间
    public int[] mAntArriveTimes; // zeros(cycle_max, 1);                % 记录到到达终点的蚂蚁数目

    public OutputDatas() {
    }

    public OutputDatas(int[][][] mCycleRoute, double[] mCycleLength, double[] mCycleMean, double[] mCycleTime, double[] mCycleTimeMean, int[] mAntArriveTimes) {
        this.mCycleRoute = mCycleRoute;
        this.mCycleLength = mCycleLength;
        this.mCycleMean = mCycleMean;
        this.mCycleTime = mCycleTime;
        this.mCycleTimeMean = mCycleTimeMean;
        this.mAntArriveTimes = mAntArriveTimes;
    }
    
    private OutputDatas(int cycle_max, int max_step) {
        mCycleRoute = new int[cycle_max][max_step + 1][3];
        mCycleMean = new double[cycle_max];
        mCycleLength = new double[cycle_max];
        mCycleTime = new double[cycle_max];
        mCycleTimeMean = new double[cycle_max];
        mAntArriveTimes = new int[cycle_max];
    }

    /** 获取结果的构造函数**/
    public static OutputDatas getInstance(int cycle_max, int max_step) {
        OutputDatas instance = new OutputDatas(cycle_max, max_step);
        return instance;

    }

    public int[][][] getCycleRoute() {
        return mCycleRoute;
    }

    public void setCycleRoute(int[][][] mCycleRoute) {
        this.mCycleRoute = mCycleRoute;
    }


    public int[] getAntArriveTimes() {
        return mAntArriveTimes;
    }

    public void setAntArriveTimes(int[] mAntArriveTimes) {
        this.mAntArriveTimes = mAntArriveTimes;
    }
}
