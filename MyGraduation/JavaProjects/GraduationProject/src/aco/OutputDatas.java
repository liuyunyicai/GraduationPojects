package aco;

public class OutputDatas {
    public int[][][] mCycleRoute;// zeros(cycle_max, max_step + 1, dimen_num); % ��¼ÿ�ε����е����·��
    public double[] mCycleLength; // ones(cycle_max, 1);               % ��¼ÿ�ε����е����·������
    public double[] mCycleMean;   // zeros(cycle_max, 1);                     % ��¼ÿ�ε����е�·����ƽ������
    public double[] mCycleTime;   // ones(cycle_max, 1);               % ��¼ÿ�ε����е����·����ɢʱ��
    public double[] mCycleTimeMean; // zeros(cycle_max, 1);                     % ��¼ÿ�ε����е�·����ƽ����ɢʱ��
    public int[] mAntArriveTimes; // zeros(cycle_max, 1);                % ��¼�������յ��������Ŀ

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

    /** ��ȡ����Ĺ��캯��**/
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
