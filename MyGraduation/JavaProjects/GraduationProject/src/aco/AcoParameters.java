package aco;
/*
 * 蚁群算法相关参数 
 **/
public class AcoParameters {
    public double Alpha;
    public double Beta;
    public double Rho;
    public double Q;
    public int cycle_max;
    public int ant_num;
    public int max_step;
    public int optimizeTypes = 0;
    public int[][] mNextvals;

    private AcoParameters() {
    }

    public AcoParameters(double alpha, double beta, double rho, double q, int cycle_max, int ant_num, int max_step, int optimizeTypes) {
        Alpha = alpha;
        Beta = beta;
        Rho = rho;
        Q = q;
        this.cycle_max = cycle_max;
        this.ant_num = ant_num;
        this.max_step = max_step;
        this.optimizeTypes = optimizeTypes;
        
        // 对mNextvals赋值
        mNextvals = new int[10][3];
        int temp_size = 0;
        
        for (int next_x = -1; next_x <= 1; next_x ++) {
        	for (int next_y = -1; next_y <= 1; next_y ++) {
        		for (int next_z = -1; next_z <= 1; next_z ++) {
        			if (((next_z != 0) && (next_x == 0) && (next_y == 0)) || ((next_z == 0) && ((next_x != 0) || (next_y != 0)))){
        				mNextvals[temp_size][0]= next_x;
        				mNextvals[temp_size][1]= next_y;
        				mNextvals[temp_size][2]= next_z;
        				temp_size = temp_size + 1;
        			}
        		}
        	}
        	
        }
    }

    public double getAlpha() {
        return Alpha;
    }

    public void setAlpha(double alpha) {
        Alpha = alpha;
    }

    public double getBeta() {
        return Beta;
    }

    public void setBeta(double beta) {
        Beta = beta;
    }

    public double getRho() {
        return Rho;
    }

    public void setRho(double rho) {
        Rho = rho;
    }

    public double getQ() {
        return Q;
    }

    public void setQ(double q) {
        Q = q;
    }

    public int getCycle_max() {
        return cycle_max;
    }

    public void setCycle_max(int cycle_max) {
        this.cycle_max = cycle_max;
    }

    public int getAnt_num() {
        return ant_num;
    }

    public void setAnt_num(int ant_num) {
        this.ant_num = ant_num;
    }
    
    public int getMaxStep() {
    	return max_step;
    }
    
    public void setMaxStep(int max_step) {
    	this.max_step = max_step;
    }
    
    public int getOptimizeTypes() {
    	return optimizeTypes;
    }
    
    public void setOptimizeTypes(int optimizeTypes) {
    	this.optimizeTypes = optimizeTypes;
    } 
    
    // 使用优化类型位置进行设置
    public void setOptimizeTypesUseIndexs(int[] indexs) {
    	for (int index : indexs) {
    		this.optimizeTypes = setOptimizeTypesUseIndex(this.optimizeTypes, index);
    	}
    }
    
    public static int getOptimizedTypeUseIndexs(int[] indexs) {
    	int optimizeTypes = 0;
    	for (int index : indexs) {
    		optimizeTypes = setOptimizeTypesUseIndex(optimizeTypes, index);
    	}
    	return optimizeTypes;
    }
    
    public static int setOptimizeTypesUseIndex(int optimizeTypes, int index) {
    	optimizeTypes |= (1 << index);
    	return optimizeTypes;
    }
    
    public boolean getIsOptimized(int index) {
    	return ((optimizeTypes & (1 << index)) > 0);
    }
}