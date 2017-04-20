package test;

import aco.AcoAlgorithm;
import aco.AcoParameters;
import aco.ConstantValues;
import aco.FireParameters;
import aco.GridInfo;
import aco.GridParameters;

public class AcoMain implements ConstantValues{

	private AcoParameters mAcoParameters;	
	private AcoAlgorithm mAcoAlgorithm;
	private int gridSize;
	
	public static void main(String[] args) {
		AcoMain acoMain = new AcoMain(); 
		
		
	}
	
	/**
	 * 执行主函数 
	 **/
	private void initACO() {
		
		mAcoParameters = initAcoParameters(gridSize);
		
		if (null != mAcoAlgorithm) {
			mAcoAlgorithm.doACO();
			
		}
		
		
		
		
		
	}
	
	
	
	/**
	 *  初始化其他信息
	 ***/
	private AcoAlgorithm initAcoAlgorithm() {
//		mGridInfos
//		
//		private GridInfo[][][] mGridInfos;
//	    private int[] mEntranceGrid; // 入口点
//	    private int[][] mExitGrids;  // 出口点
//	    private int[][] mFireGrids;
//	    private int[][] mPreferedGrids;
//	    private AcoParameters mAcoParameters;
//	    private GridParameters mGridParameters;
//	    private FireParameters mFireParameters;
		
		mAcoAlgorithm = new AcoAlgorithm();
		return mAcoAlgorithm;
		
	}
	
	/**
	 * 设置蚁群算法的参数 
	 **/
	private AcoParameters initAcoParameters(int gridSize) {
		int cycle_max = 50;
		int ant_num = 50;
		double Alpha = 1.0;
		double Beta = 1.0;
		double Rho = 0.5;
		double Q = 10;
		
		int max_step = (int) Math.pow(gridSize, 0.65);
		
		
		int[] optimizedIndexs = {OPTIMIZE_1, OPTIMIZE_2, OPTIMIZE_3,
				OPTIMIZE_4, OPTIMIZE_5, OPTIMIZE_6,
				OPTIMIZE_7, OPTIMIZE_8, OPTIMIZE_9,
				OPTIMIZE_10, OPTIMIZE_FIRE, 
//				OPTIMIZE_FIRE1, OPTIMIZE_FIRE2,OPTIMIZE_FIRE3, 
				OPTIMIZE_ALL}; 
		int optimizeTypes = AcoParameters.getOptimizedTypeUseIndexs(optimizedIndexs);
		
		AcoParameters instance = new AcoParameters(Alpha, Beta, Rho, Q, cycle_max, ant_num, max_step, optimizeTypes);
		return instance;
	}
	
}
