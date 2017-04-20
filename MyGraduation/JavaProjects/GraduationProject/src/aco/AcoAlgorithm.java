package aco;

import java.util.Arrays;
import java.util.Random;

public class AcoAlgorithm implements ConstantValues{
    private GridInfo[][][] mGridInfos;
    private int[] mEntranceGrid; // 入口点
    private int[][] mExitGrids;  // 出口点
    private int[][] mFireGrids;
    private int[][] mPreferedGrids;
    private AcoParameters mAcoParameters;
    private GridParameters mGridParameters;
    private FireParameters mFireParameters;

    /**
     * 构造函数 
     **/
    public AcoAlgorithm() {
    }

    public AcoAlgorithm(GridInfo[][][] mGridInfos, int[] mEntranceGrid, int[][] mExitGrids, int[][] mFireGrids, int[][] mPreferedGrids, AcoParameters mAcoParameters, GridParameters mGridParameters, FireParameters mFireParameters) {
        this.mGridInfos = mGridInfos;
        this.mEntranceGrid = mEntranceGrid;
        this.mExitGrids = mExitGrids;
        this.mFireGrids = mFireGrids;
        this.mPreferedGrids = mPreferedGrids;
        this.mAcoParameters = mAcoParameters;
        this.mGridParameters = mGridParameters;
        this.mFireParameters = mFireParameters;
    }
    
    /**
     * 主要的执行函数 
     **/
    public OutputDatas doACO() {
    	OutputDatas outputDatas = OutputDatas.getInstance(mAcoParameters.getCycle_max(), mAcoParameters.getMaxStep());
    	// 信息素浓度矩阵
    	double[][][][] Tau = new double[mGridParameters.x_max][mGridParameters.y_max][mGridParameters.z_max][mAcoParameters.mNextvals.length];
    	
    	int cycle_times = 1;
    	
    	while (cycle_times <= mAcoParameters.cycle_max) {
    		acoRecycle(cycle_times, outputDatas, Tau);
    	}
    	
    	return outputDatas;
    	
    }
    
    /**
     * 蚁群搜索具体 
     ***/
    private void acoRecycle(int cycle_times, OutputDatas outputDatas, double[][][][] Tau) {
    	int ant_num = mAcoParameters.ant_num;
    	int max_step = mAcoParameters.max_step;
    	int nextval_size = mAcoParameters.mNextvals.length;
    	
    	int x_max = mGridParameters.x_max;
    	int y_max = mGridParameters.y_max;
    	int z_max = mGridParameters.z_max;
    	
    	
    	int[][][] Route = new int[ant_num][max_step + 1][3];
    	int[] Step = new int[ant_num];
    	int[] L = new int[ant_num];
    	double[] EqualLength = new double[ant_num];
    	double[] Time = new double[ant_num];
    	double[][][][][] Eta = new double[ant_num][x_max][y_max][z_max][nextval_size];
    	double[][][][][] Inspires = new double[ant_num][x_max][y_max][z_max][nextval_size];

    	
    	// 初始化第一步
    	for (int i = 0; i < mAcoParameters.ant_num; i++) {
    		Route[i][1] = mEntranceGrid;
    		L[i] = 1;
    		Step[i] = 1;
    	}
    	
    	boolean is_moved = true;
    	
    	for (int j = 0; j < ant_num; j++) {
    		int count = 0;
    		
    		for (int i = 0; i < max_step; i++) {
    			int[] CurGrid_pos = Route[j][L[j] - 1];
    			// 如果到达终点
    			if (isMember(mExitGrids, CurGrid_pos) >= 0) {
    				outputDatas.mAntArriveTimes[cycle_times] += 1; 
    				System.out.printf("ant%d arrive,total %d arrived \n", j, outputDatas.mAntArriveTimes[cycle_times]);
    			}
    			
    			// 该情况下表示该蚂蚁不用继续搜索，跳出循环
    			if ((CurGrid_pos[0] == -1) || (isMember(mExitGrids, CurGrid_pos) >= 0)) 
    				break;
    			
    		    // 表示到达未出口，需要继续执行往下循环
    			// ======= 计算到下一个节点的转移概率 ======= % （这里Route即相当于禁忌表）                                          
    			int x = CurGrid_pos[1];
    			int y = CurGrid_pos[2];
    			int z = CurGrid_pos[3]; 
    			
    			// 遍历该节点相邻的相关点                               
    			double[] P = new double[nextval_size];       // 从远点到n个城市的转移矩阵，这里全部初始化为0（注意这里保留了当前点，在统计时，应注意去除）
    			double[] Fijs = new double[nextval_size];    // 用以暂存人工势场力
    			double[][][] TempTimes = new double[ant_num][max_step + 1][nextval_size]; // 用以暂存通过该转移路径所需要的疏散时间
    			
    			double[] Temp_Inspires = new double[nextval_size];
    			double[] Temp_Eta = new double[nextval_size];
    			double[] Temp_T = new double[nextval_size];
    			
    			// 遍历相邻节点
    			for (int temp_size = 0; temp_size < nextval_size; temp_size ++) {
    				int nextval_x = mAcoParameters.mNextvals[temp_size][0];
    				int nextval_y = mAcoParameters.mNextvals[temp_size][1];
    				int nextval_z = mAcoParameters.mNextvals[temp_size][2];
    				
    				int next_x = x + nextval_x;
    				int next_y = y + nextval_y;
    				int next_z = z + nextval_z;
    				
    				// 判断该对应点是否存在
    				if (((next_x >= 1) && (next_x <= x_max)) && ((next_y >= 1) && (next_y <= y_max)) && ((next_z >= 1) && (next_z <= z_max))) {
    					// ==================== 计算转移概率 ==============
    					GridInfo NextGridInfo = mGridInfos[next_x - 1][next_y - 1][next_z - 1]; // 下一栅格的相关信息
    					// 首先计算每个转移路径的启发式因素大小(这里先暂时是距离的倒数)
   					 	double dis = Math.pow((nextval_x * mGridParameters.interval_x), 2) + 
   					 				 Math.pow((nextval_y * mGridParameters.interval_y), 2) + 
   					 				 Math.pow((nextval_z * mGridParameters.interval_z), 2);
   					 	dis = Math.pow(dis, 0.5);   
    					double eta = 1 / dis;  // 启发因子
    					Eta[j][x - 1][y - 1][z - 1][temp_size] = eta; // 记录距离
    					Temp_Eta[temp_size] = eta;
    					
    					// 取出该点对应的信息素
   					 	double tau = Tau[x - 1][y - 1][z - 1][temp_size];
   					 	
   					 	// *************  再计算转移概率 ************
   					 	boolean is_visited = false; // 标志该节点是否已经访问过
   					 	int[] ToSearch = {next_x, next_y, next_z};
   					 	if (isMember(Route[j], ToSearch) >= 0)
   					 		is_visited = true;
   					 	
   					 	double p_value = 0;
   					 	double p_coeff = 1; // 系数
   					 	
   					 	if (is_visited) { // 表示已经访问过，则转移概率为0 （这里做一处优化，为了避免蚂蚁进入死胡同，则允许蚂蚁可以访问已经访问过的节点） 
   					 		if ((mAcoParameters.getIsOptimized(OPTIMIZE_8)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
   					 			p_coeff = 0.000001;
   					 		} else {
                                p_coeff = 0;
   					 		}
   					 	}
   					 	
   					 	if (NextGridInfo.getIsFree() != ISACCESSED_ZONE)   //	 如果是障碍物或者火灾区域，转移概率为0
   							 p_coeff = 0;
   					 	else {
   					 		// =============== 引入火场因素影响因子 ============= %
   	                         double Easy_total = 1; // 用以记录通行难易系数的乘积
	   	                     if ((mAcoParameters.getIsOptimized(OPTIMIZE_10)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	   	                    	  // 如果下一个节点为PreferGids中的节点，则
	   	                    	  if (isMember(mPreferedGrids, ToSearch) >= 0)
	   	                    		p_coeff = 10;
	   	                     }
	   	                     
	   	                     double v_base = v0;
	   	                     if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	   	                    	 double thita = 0.5; // 危险性惩罚系数
	                             // 计算适应火灾场景的蚁群算法启发函数
	                             double inpsire = Math.pow((dis / v0), (thita - 1));
	                             Inspires[j][x - 1][y - 1][z - 1][temp_size] = inpsire; 							 
	                             double R_total = 1;    // 用以记录危险性系数R的乘积
	                             Easy_total = 1; // 用以记录通行难易系数的乘积
	                             double[] R_totals = new double[3]; // 暂存每一项中的数据
	                             double[] Easy_totals = new double[3];
	                             double v_cur = v0; // 最终通行的速度
	                             double cur_time = Time[j] + mFireParameters.warning_time; // 获取当前路径上的Time时刻
	                             
	                             if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE1)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            	 double T = NextGridInfo.temperature;// 火场的温度
	                            	 
	                            	 if (T >= DEATH_TEMPERATURE)  { // 表示死亡区域，不同通行
	                            		 Easy_totals[0] = 0;
	                            		 System.out.println("DEATH_TEMPERATURE");
	                            	 } else {
                                         double t_beta = 0.03;  // 升温系数
                                         double t_eta = 0.5;   // 温度随距离的衰减系数
                                         double t_miu = 0.4;
                                         double T_deta = 0;
                                         
                                         if (0 == FIRE_LOCKED) {
                                        	 for (int[] fireGrid : mFireGrids) {
                                        		 // 获取火源位置
	                                             int fire_x = fireGrid[0];
	                                             int fire_y = fireGrid[1];
	                                             int fire_z = fireGrid[2];
	                                             
	                                             if (fire_z == next_z ) {// 仅考虑在同一楼层的火源影响
	                                            	// 计算火源到用户当前位置的距离
	                                            	 double Tfire = mGridInfos[fire_x - 1][fire_y - 1][fire_z - 1].temperature;
	                                            	 double Tz = 345 * Math.log10(8 * cur_time / 60 + 1);// 按照最坏估计更新火源的温度值
	                                            	 double t_s = Math.pow(((next_x - fire_x) * mGridParameters.interval_x), 2) + 
	                                            			 Math.pow(((next_y - fire_y) * mGridParameters.interval_y), 2);
	                                            	 t_s = Math.pow(t_s, 0.5);
	                                            	 
	                                            	 double temp_tdeta = Tz * (1 - 0.8 * Math.exp(-t_beta * cur_time) - 0.2 * Math.exp(-0.1 * t_beta * cur_time))
	                                            			 * (t_eta + (1 - t_eta) * Math.exp((0.5 - t_s) / t_miu));
	                                            	 if (temp_tdeta > T)
	                                            		 T = temp_tdeta;
	                                             }
                                        	 }
                                         }
                                         
                                         if (T < 20) 
	                                         T = 20;
	                                     Temp_T[temp_size] = T;
	                                     double Tc = 30;  // 正常温度为30度
	                                     
	                                     double r_fai1 = 0.2;            // 热量危险系数影响因子
	                                     double R1 = Math.pow((T / Tc), 3.61); // 温度危险系数
	                                     
	                                     double Tc1 = 30;
	                                     double Tc2 = 60; // 对人体产生危害温度
	                                     double Td = DEATH_TEMPERATURE * SEARCH_DEATH_PARAM; // 致人死亡温度
	                                     double  vmax = 3.0; // 正常情况下的最大疏散速度
	                                     double  Easy1 = 1;// 该温度下的通行难易系数															 
	                                     double  easy_gama1 = 1; // 温度通行难易系数影响因子
	                                     
	                                     if ((T >= Tc1) && (T < Tc2)) {
	                                    	 Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / (Math.pow((Tc2 - Tc1), 2))) + v0);
	                                     } else if ((T >= Tc2) && (T < Td)) {
	                                    	 Easy1 = (1.2 / vmax) * (1 - (Math.pow((T - Tc2) / (Td - Tc2), 2)));
	                                     } else if(T >= Td) {
	                                    	 Easy1 = 0;
	                                     }
	                                     
	                                     //==== 得到最终结果 =====// 
	                                     // 计算危害性影响因子与通行难易度影响因子
	                                     R_totals[0] = Math.pow(R1, r_fai1) ;
	                                     Easy_totals[0] = Math.pow(Easy1, easy_gama1);
	                            	 }
	                            	 
	                            	// =========== 计算烟气浓度的影响 ========= //
	                            	 if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE2)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            		 if (Easy_totals[0] != 0)  {// 如果为死亡区域则直接跳过剩下的计算	
	                            			 double C = NextGridInfo.smokeCon * 100;   // 烟气浓度
	                            			 double C_O2 = NextGridInfo.O2Con * 100;   // 氧气浓度
	                            			 double C_CO = NextGridInfo.CO2Con * 100 * 1000;   // 一氧化碳浓度(ppm)
	                            			 double C_CO2 = NextGridInfo.CO2Con * 100; // 二氧化碳浓度
	                            			 
	                            			 if (((C_O2 > 0) &&(C_O2 <= DEATH_O2)) || (C_CO >= DEATH_CO) || (C_CO2 >= DEATH_CO2)) // 超过危险浓度，限制为危险区域
	                                         	Easy_totals[1] = 0;
	                            			 else {
	                            				// 引入烟气的扩散公式
		                                        double k_somke = 0.09;
		                                        double C_deta = 0;
		                                        if (0 == FIRE_LOCKED) {
		                                        	for (int[] fireGrid : mFireGrids) {
		                                        		 // 获取火源位置
			                                             int fire_x = fireGrid[0];
			                                             int fire_y = fireGrid[1];
			                                             int fire_z = fireGrid[2];
			                                             double Q = mGridInfos[fire_x - 1][fire_y - 1][fire_z - 1].smokeCon * 100; 
			                                             if (fire_z == next_z) {// 仅考虑在同一楼层的火源影响
			                                            	// 计算火源到用户当前位置的距离
		                                                    double slength = Math.pow(((next_x - fire_x) * mGridParameters.interval_x), 2) + 
		                                                    		Math.pow(((next_y - fire_y) * mGridParameters.interval_y), 2) +
		                                                    		Math.pow(((next_z - fire_z) * mGridParameters.interval_z), 2);
		                                                    C_deta =  (Q * 1)  * Math.exp((Math.pow(-slength, 1.5)) / (4 * k_somke * cur_time));
			                                             }
		                                        	}
		                                        }
		                                        
		                                        if (C_deta != 0)
		                                        	C = C_deta; // 考虑扩散的烟气浓度随时间变化值
		                                        
		                                        // 安全条件下的各种气体浓度
		                                        double Csafe_O2 = 21;
		                                        double Csafe_CO = 0.01 * 10000;
		                                        double Csafe_CO2 = 5; // 百分比
		                                        
		                                        // 先计算疏散速度
		                                        double vk = 0.706 + (-0.057) * 0.248 * C; // 消光系数与逃生速度公式(C为百分比)
		                                        double Easy2 = vk / v0;  // 烟气浓度影响下的通行难易系数
		                                        double tk = dis / vk;    // 在该烟气浓度下的通行时间
		                                        
		                                        // 计算危险性
		                                        double FEDco = 4.607 * Math.pow(10, -7) * Math.pow(C_CO, 036) * tk;
		                                        double FEDo2 = tk / (60 * Math.exp(8.13- 0.54 * (20.9 - C_O2))) ;
		                                        double HVco2 = Math.exp(0.1930 * C_CO2 + 2.004) / 7.1; 
		                                        double FED = FEDco * HVco2 + FEDo2; 
		                                        
		                                        // 无危险情况下的窒息公式值
		                                        double FEDc_co = 4.607 * (10 ^ (-7)) * Math.pow(Csafe_CO, 1.036) * tk;
		                                        double FEDc_o2 = tk / (60 * Math.exp(8.13- 0.54 * (20.9 - Csafe_O2))) ;
		                                        double HVcc_o2 = Math.exp(0.1930 * Csafe_CO2 + 2.004) / 7.1; 
		                                        double FEDc = FEDc_co * HVcc_o2 + FEDc_o2; 
		                                        
		                                        // 烟气浓度下的危险程度系数 
		                                        double R2 = FED / FEDc;

		                                        double r_fai2 = 1;
		                                        double easy_gama2 = 1;

		                                        // ===== 得到最终结果 ===== //
		                                        R_totals[1] = Math.pow(R2, r_fai2);
		                                        Easy_totals[1] = Math.pow(Easy2, easy_gama2);	
	                            			 }
	                            		 }
	                            	 }
	                            	// ============ 计算人流密度的影响 ============ //
	                            	 if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE3)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            		 if ((Easy_totals[0] != 0) && (Easy_totals[1] != 0)) {
	                            			 int peoplenum = NextGridInfo.peopleNum;// 人流密度
	                            			 double p = peoplenum * 0.12 / (mGridParameters.interval_x * mGridParameters.interval_y);
	                            			 
	                            			 double pc = 0.92; // 无阻碍时的人流密度
	                            			 if (p >= DEATH_PEOPLE_NUM) { // 表示人群过于拥挤，因此不建议通行
	                            				 Easy_totals[2] = 0; 
	                            			 } else {
	                            				 int grid_type = NextGridInfo.gridType; // 获取该通道的类型
	                            				 if (p >= 0)  {// 表示通道中有人
	                            					// 计算通行速度
                                                     double v3 = (112 * Math.pow(p, 4) - 380 * Math.pow(p, 3) + 434 * Math.pow(p, 2) - 217 * p + 57) / 60;
                                                     v3 = (1.49 - 0.36 * p) * v3 * v0;
                                                     v_base = v3;
                                                     if (grid_type == DOOR_POINT) // 通过门口通道
                                                        v3 = (1.17 + 0.13 * Math.sin(6.03 * p - 0.12)) * v3;
                                                     else if (grid_type ==  STAIRCASE_POINT) { // 上下楼梯通行速度
                                                    	 if (nextval_z == 1) // 表示上楼
                                                    		 v3 = 0.4887 * v3;
                                                         else if (nextval_z == -1)
                                                             v3 = 0.6466 * v3;
                                                     }
                                                     
                                                     if (p == 0)
                                                         p = 0.01;
                                                     double R3 = p / pc;      // 人流密度下的危险系数
                                                     double Easy3 = v3 / v0;  // 人流密度下的通行难易系数

                                                     double r_fai3 = 1;
                                                     double easy_gama3 = 1;

                                                     R_totals[2] = Math.pow(R3, r_fai3);
                                                     Easy_totals[2] = Math.pow(Easy3, easy_gama3);
	                            				 }
	                            			 }
	                            		 }
	                            	 }
	                            	 
	                            	 
	                            	 // 计算最后的乘积
	                                 double easy_min = Easy_totals[0];
	                                 for (int index = 0; index <= R_totals.length; index ++) {
	                                	 R_total = R_total * R_totals[index];
	                                	 Easy_total = Easy_total * Easy_totals[index];
		                                 // 选取最小速度
		                                 easy_min = Math.min(easy_min, Easy_totals[index]);
	                                 }
	                                 
	                                 // 根据火灾场景的蚁群算法启发函数来计算最终的启发因子的值
	                                 if ((R_total == 0) || (Easy_total == 0))
	                                    eta = 0;
	                                 else
	                                    eta = Math.pow(R_total, (-thita)) * Math.pow(Easy_total, (1 - thita))* inpsire;						 
	                                 Inspires[j][x - 1][y - 1][z - 1][temp_size] = eta;
	                                                 
	                                 // 用以暂存通过该通道转移所需要的时间
	                                 v_cur = v_base * easy_min;
	                                 if (v_cur == 0)
	                                     TempTimes[j][L[j] - 1][temp_size] = Integer.MAX_VALUE;
	                                 else
	                                	 TempTimes[j][L[j] - 1][temp_size] = dis / v_cur;
	                                 
	                                 Temp_Inspires[temp_size] = eta;
	                             }
	                             //=============== 引入人工势场影响因子 ============= //
	                             if ((mAcoParameters.getIsOptimized(OPTIMIZE_1)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            	// 这里先进行计算，存储起来，然后再引入
                                    int exit_nums = mExitGrids.length; // 出口对蚂蚁引力作用
                                    
                                    double f_x = 0;   // 人工势场合力矢量参数
                                    double f_y = 0;
                                    double f_z = 0;
                                    for (int k = 0; k < exit_nums; k++) {
                                    	double exit_thita = 1;
                                    	if ((mAcoParameters.getIsOptimized(OPTIMIZE_9)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
                                    		exit_thita = 0.5;
                                    	}
                                    	double deta_x = mExitGrids[k][0] - next_x; 
                                    	double deta_y = mExitGrids[k][1] - next_y; 
                                    	double deta_z = mExitGrids[k][2] - next_z; 

                                        double deta_l = Math.pow(deta_x, 2) + Math.pow(deta_y, 2) + Math.pow(deta_z, 2);
                                        if (deta_l != 0) {
                                        	if (deta_z == 0) {
                                        		f_x = f_x  + exit_thita * deta_x / deta_l;
                                                f_y = f_y + exit_thita * deta_y / deta_l;
                                                f_z = f_z  + exit_thita * deta_z / deta_l;
                                        	}
                                        }
                                    } 
                                    
                                    int fire_nums = mFireGrids.length; // 火源点对蚂蚁的斥力作用
                                    double fire_coff = 0.1;
                                    for (int k = 0; k < fire_nums; k++) {
                                    	double deta_x = mFireGrids[k][0] - next_x; 
                                    	double deta_y = mFireGrids[k][1] - next_y; 
                                    	double deta_z = mFireGrids[k][2] - next_z; 
                                    	
                                    	double deta_l = Math.pow(deta_x, 2) + Math.pow(deta_y, 2) + Math.pow(deta_z, 2);
                                    	
                                    	if (deta_l != 0) {
                                    		f_x = f_x  - fire_coff * deta_x / deta_l;
                                            f_y = f_y - fire_coff * deta_y / deta_l;
                                            f_z = f_z  - fire_coff * deta_z / deta_l;
                                    	}
                                    }
                                    
                                    int prefer_sizes = mPreferedGrids.length; // 楼道等出口的引力作用
                                    double prefer_z_param = 1000;
                                    for (int k = 0; k < prefer_sizes; k++) {
                                    	if ((next_z == mPreferedGrids[k][2]) && (next_z != 1))  {// 只考虑同一楼层的出口位置
                                    		double deta_x = mPreferedGrids[k][0] - next_x; 
                                    		double deta_y = mPreferedGrids[k][1] - next_y; 
                                    		double deta_z = mPreferedGrids[k][2] - next_z;
                                    		
                                    		double deta_l = Math.pow(deta_x, 2) + Math.pow(deta_y, 2) + Math.pow(deta_z, 2);
                                    		
                                    		if (deta_l != 0) {
                                    			if (mPreferedGrids[k][2] != 1) {
                                    				f_x = f_x  + deta_x / deta_l;
                                                    f_y = f_y + deta_y / deta_l;
                                                    f_z = f_z  + deta_z / deta_l;
                                    			}
                                    			else
                                                    f_z = f_z - prefer_z_param;
                                    		}
                                    	}
                                    }
                                    
                                    // z轴方向的影响系数
                                    double z_param = 1000;

                                    // 前进方向的单位向量nij
                                    double n_x = nextval_x;
                                    double n_y = nextval_y;
                                    double n_z = nextval_z * z_param;

                                    //人工势场力作用大小是合力Fij，与前进位置法向量的矢量点乘
                                    Fijs[temp_size] = f_x * n_x + f_y * n_y + f_z * n_z; 
	                             }
	   	                     }
   	                         
	   	                  // 原始的转移概率
	 					 p_value =  Math.pow(tau, mAcoParameters.Alpha) * Math.pow(eta, mAcoParameters.Beta);
	 					 p_value = p_coeff * p_value;
	 					 
	 					 P[temp_size] = p_value;     

	//                   fprintf('next= (%d, %d, %d)， P= %d\n',nextval_x, nextval_y, nextval_z, p_value);
   					 	}
    				}
    				
    				//========== 计算人工势场影响因子 ========== //
    				if ((mAcoParameters.getIsOptimized(OPTIMIZE_1)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
    					double f_cigma = 3.5;
    					
    					if ((mAcoParameters.getIsOptimized(OPTIMIZE_9)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
    						f_cigma =7.5;
    						for (int ff_i = 0; ff_i < cycle_times; ff_i ++) {
    							f_cigma = f_cigma - Math.pow(0.7, cycle_times);
    						}
    					}
    					
    					double[] Fabs = Utils.abs(Fijs);
    					double sumValue = Utils.sum(Fabs);
    					
    					if (0 == sumValue) {
    						
    					} else {
    						// 这里有待测试
    						Fijs = Utils.division(Fijs, sumValue);
		                    Fijs = Utils.exps(Fijs);  
		                    Fijs = Utils.pows(Fijs, f_cigma);
		                    // 将人工势场引入转移概率的计算中
		                    P = Utils.dot(P, Fijs);
    					}
    				}
    				// 对P中所有元素求和，然后求取平均值  
    				P = Utils.division(P, Utils.sum(P)); 
    				
    				// *************** 轮盘赌方式选择下一个城市 ******************
    				double rand_line = new Random().nextDouble();
    				double line = 0;
    				int[] NextGrid_Selected = new int[3];
    				
    				for (temp_size = 0; temp_size < nextval_size; temp_size++) {
    					nextval_x = mAcoParameters.mNextvals[temp_size][0];
						nextval_y = mAcoParameters.mNextvals[temp_size][1];
						nextval_z = mAcoParameters.mNextvals[temp_size][2];
						
						if (line < rand_line) {
							line += P[temp_size];
							if (line >= rand_line) {
								if (mGridInfos[x + nextval_x - 1][y + nextval_y - 1][z + nextval_z - 1].isFree == ISACCESSED_ZONE) {// 剔除掉障碍物情况
									NextGrid_Selected[0] = nextval_x; 
									NextGrid_Selected[1] = nextval_y;
									NextGrid_Selected[2] = nextval_z;//选中下一处落脚点
									int[] B = {nextval_x, nextval_y, nextval_z};
									int next_size = isMember(mAcoParameters.mNextvals, B);
									
									// 判断该节点是否已经访问过					 
								    int[] tempToSearch = {x + nextval_x, y + nextval_y, z + nextval_z};
									int temp_visited = isMember(Route[j], tempToSearch);
									
									// 更新时间
		                            Time[j] += TempTimes[j][L[j] - 1][next_size];
		                            double temp_time = TempTimes[j][L[j] - 1][next_size];
		                            
		                            if (temp_visited >= 0) {
		                            	for (int index = temp_visited; index >= L[j] - 1; index ++) {
		                            		for (int i_index = 0; i_index < 3; i_index++)// 将重复值里面的路径全部清空
		                            			Route[j][index][i_index] = -1;
		                            		Time[j] = Time[j] - TempTimes[j][index][next_size];
		                            		TempTimes[j][index][next_size] = 0;
		                            	}
		                            	for (int i_index = 0; i_index < 3; i_index++)
		                            		Route[j][L[j]][i_index] = -1;
		                                if (temp_visited == 0)
		                                	L[j] = 1; 
		                                else
		                                	L[j] = temp_visited - 1; 
		                            }
		                            TempTimes[j][L[j]][next_size] = temp_time;
		                            // 选中转移节点后，跳出循环
			                        break;
								}
							}
						}
    				}
    				L[j] = L[j] + 1; // 选中了城市则往后推进一步
                    Step[j] = Step[j] + 1; //步长加1
        			if (L[j] <= mGridParameters.getGridSize())
        				if  ((Utils.isEqual(NextGrid_Selected, new int[]{0, 0, 0})) || (Step[j] > max_step))//表示停滞在原地 或者超过最长步长
        					Utils.fill(Route[j][L[j] - 1], new int[] {-1, -1, -1});
        				else {
        					//记录下一步路径
        					Utils.fill(Route[j][L[j] - 1], new int[] {x + NextGrid_Selected[0], y + NextGrid_Selected[1], z + NextGrid_Selected[2]});
                            
                            if (OUTPUT_ROUTE == 1)
                                System.out.printf("Route Step%f:(%f,%f,%f)\n", Step[j],Route[j][L[j] - 1][0] , Route[j][L[j] - 1][1] , Route[j][L[j] - 1][2]);
                            
        					is_moved = true; // 表示发生了移动，避免算法进入无效的停滞
        				}
        					
    			}
    		}
    		System.out.printf("%d,%d,==%d,(%d,%d,%d),step=%d, Time=%d\n", cycle_times, j, L[j],Route[j][L[j] - 1][0], Route[j][L[j] - 1][1], Route[j][L[j] - 1][2],Step[j], Time[j]);
    	}
    	
    	
    	//// ============== 第三步：记录本次迭代最佳路线 ============= ////
    	double[] Length = new double[ant_num];  // 用来统计每只蚂蚁的路径值(这里不仅仅是指长度)  
    	Arrays.fill(Length, Integer.MAX_VALUE);
    			//  disp(Eta);
    	for (int i = 0; i < ant_num; i++)	{// 统计每只蚂蚁的行走路径的权值和（这里不仅计算路径的距离，同时还包括其他等因素，使用Eta进行计算,这里Eta是时间导向，与时间呈倒数线性关系，故而这里找寻Eta^(-1)和最小的值即可）
    		int[][] AntRoute = Route[i];
    		int temp_max = Math.min(L[i], max_step) - 1;
    		for (int j = 0; j < temp_max; j++) {
    			// 处理遇到死胡同的情况
    			if ((Utils.isEqual(AntRoute[j + 1], new int[] {-1, -1, -1})) || (j == max_step -1)) {
    				Length[i] = Integer.MAX_VALUE;
    			} else {
    				if (Integer.MAX_VALUE == Length[i]) {
    					Length[i] = 0;
    				}
    				int[] Nextval = Utils.sub(AntRoute[j + 1], AntRoute[j]);
    				
    				int temp_index = isMember(mAcoParameters.mNextvals, Nextval);
    				Length[i] += 1/Eta[i][AntRoute[j][0]][AntRoute[j][1]][AntRoute[j][2]][temp_index];
    			}
    		}
    	}	 
    	
    	double min_value = Utils.min(Length);
    	outputDatas.mCycleLength[cycle_times] = min_value; //记录每次迭代中的最短路径（这里指用时最少路径）
    	int ant_pos = Arrays.binarySearch(Length, min_value); // 找到实现最短路径的蚂蚁
    	   
    	double min_time = Utils.min(Time);
    	outputDatas.mCycleTime[cycle_times] = min_time;
	    ant_pos = Arrays.binarySearch(Time, min_time); 
	    outputDatas.mCycleRoute[cycle_times] = Route[ant_pos]; //记录每次迭代的最佳路径
	    
	    
	    // 输出本次循环的最佳路径长度
	    System.out.printf("第%d次循环最佳长度:%d,最佳步长:%d，最佳时间:%d\n", cycle_times, outputDatas.mCycleLength[cycle_times], L[ant_pos], Time[ant_pos]);
	   
	    double[] tempLength = Length;
	    int temp_count = 0;
	    double temp_total = 0;
	    for (int k = 0; k < ant_num; k++) {
	    	if (tempLength[k] == Double.MAX_VALUE) {
	    		temp_total += tempLength[k];
	    	} else {
	    		temp_total += max_step;
	    	}
	    	temp_count++;
	    }
	    outputDatas.mCycleMean[cycle_times] = temp_total / temp_count;

	    cycle_times = cycle_times + 1; // 进行下一轮迭代
	    
	    //// ============== 第四步：更新信息素 =================== ////
		double[][][][] Delta_Tau = new double[x_max][y_max][z_max][nextval_size];        // 开始时信息素为n*n的0矩阵
		double Length_min = Utils.min(Length);     //找到最大最小值
		double Length_max = Utils.max(Length);
		double thita = 50.0;                  //信息素最佳增量影响因子(优化策略4)
	    
		for (int i = 0; i < ant_num; i++) {
			int j_max = Math.min(L[i], max_step) - 1;
			for (int j = 0; j < j_max; j++) {
				int[] pre = Route[i][j];
				int[] next = Route[i][j + 1];
				
				if ((Utils.isEqual(pre, new int[] {-1, -1, -1})) || (Utils.isEqual(next, new int[] {-1, -1, -1}))) {
					
				} else {
					int[] nextval = Utils.sub(next, pre);
					
					int temp_temp_size = isMember(mAcoParameters.mNextvals, nextval);
					
					// 此次循环在路径（i，j）上的信息素增量 (TODO:对于进入死胡同的蚂蚁有没有必要更新信息素，以及会对后面的蚂蚁产生怎样的影响，这里有待验证)
					double temp_deta = mAcoParameters.Q / Length[i];
					
					int x = pre[0];
					int y = pre[1];
					int z = pre[2];
					
					// ======= 优化策略4, 最大最小路径的信息素增量优化 ======== //
					if ((mAcoParameters.getIsOptimized(OPTIMIZE_4)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
						if (Length[i] == Length_min) 
							temp_deta = temp_deta * thita;
						else if (Length[i] == Length_max)
							temp_deta = temp_deta / thita;
					}
					Delta_Tau[x][y][z][temp_temp_size] += temp_deta;
				}
			}
		}
		
		// =========== 优化策略3， 自适应信息素浓度挥发因子 ================= //
		if ((mAcoParameters.getIsOptimized(OPTIMIZE_3)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
			// 自定义更新信息素挥发因子Rho值
			double Rho0 = 0.6;
			double Rho_min = 0.5;
			double fai = 0.99;
			double temp_rho = Rho0 * (Math.pow(fai, (cycle_times - 1)));
			if (temp_rho <= Rho_min)
				temp_rho = Rho_min;
			mAcoParameters.Rho = temp_rho;
		}
		
		//************************* 更新信息素 ********************* %
		Tau = Utils.plus(Utils.multi(Tau, (1 - mAcoParameters.Rho)), Delta_Tau) ; //考虑信息素挥发，更新后的信息素

		// =========== 优化策略2， 自适应最大最小蚁群算法阈值 ================= //
		if ((mAcoParameters.getIsOptimized(OPTIMIZE_2)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
			// 设定最大最小蚁群法的阈值
			double Rho_k = 0.5;
			double temp_Q = 500;   // 最大最小蚁群算法调整因子
			double L_min = Utils.min(Length);
			
			if (L_min != Double.MAX_VALUE) {
				double tau_max =( (1 + Rho_k) / (2 * (1 - Rho_k)* L_min) +  (2 * (1 - Rho_k) )/ L_min) * temp_Q;
                double tau_k = 200;
                double tau_min = tau_max / tau_k;
      
//                 tau_max = 4;
//                 tau_min = 0.01;
                System.out.printf("Tau max=%d, min=%d, tau=[%d, %d]\n", Utils.max(Tau), Utils.min(Tau), tau_max, tau_min);
                //对信息浓度限定阈值 Tau = ones(x_max, y_max, z_max, 1)
                
                
                for (int x = 0; x < Tau.length; x++) {
        			for (int y = 0; y < Tau[0].length; y++) {
        				for (int z = 0; z < Tau[0][0].length; z++) {
        					for (int temp_size = 0; temp_size < Tau[0][0][0].length; temp_size++) {
        						double data_tau =  Tau[x][y][z][temp_size];
  	                            if (data_tau > tau_max)
  	                                data_tau = tau_max;
  	                            else if (data_tau < tau_min)
  	                                data_tau =  tau_min;
  	                            Tau[x][y][z][temp_size] = data_tau;
        					}
        				}
        			}
        		}
     	                        
			}
		}
    }
    
    
    
    // 判断数组中是否存在
    private int isMember(int[][] toFind, int[] child) {
    	int index = -1;
    	for (int size = 0; size < toFind.length; size++) {
    		int[] data = toFind[size];
    		if (data.length != child.length)
    			return -1;
    		
    		boolean isSame = true;
    		for (int i = 0; i < data.length; i++) {
    			if (data[i] != child[i]) {
    				isSame = false;
    				break;
    			}
    		}
    		if (isSame) {
    			index = size;
        		return index;
    		}
    		
    	}
    	return index;
    }
    
    
    /*************************** Getter Setter函数***************************/

    public GridInfo[][][] getmGridInfos() {
        return mGridInfos;
    }

    public void setmGridInfos(GridInfo[][][] mGridInfos) {
        this.mGridInfos = mGridInfos;
    }

    public int[] getmEntranceGrid() {
        return mEntranceGrid;
    }

    public void setmEntranceGrid(int[] mEntranceGrid) {
        this.mEntranceGrid = mEntranceGrid;
    }

    public int[][] getmExitGrids() {
        return mExitGrids;
    }

    public void setmExitGrids(int[][] mExitGrids) {
        this.mExitGrids = mExitGrids;
    }

    public int[][] getmFireGrids() {
        return mFireGrids;
    }

    public void setmFireGrids(int[][] mFireGrids) {
        this.mFireGrids = mFireGrids;
    }

    public int[][] getmPreferedGrids() {
        return mPreferedGrids;
    }

    public void setmPreferedGrids(int[][] mPreferedGrids) {
        this.mPreferedGrids = mPreferedGrids;
    }

    public AcoParameters getmAcoParameters() {
        return mAcoParameters;
    }

    public void setmAcoParameters(AcoParameters mAcoParameters) {
        this.mAcoParameters = mAcoParameters;
    }

    public GridParameters getmGridParameters() {
        return mGridParameters;
    }

    public void setmGridParameters(GridParameters mGridParameters) {
        this.mGridParameters = mGridParameters;
    }

    public FireParameters getmFireParameters() {
        return mFireParameters;
    }

    public void setmFireParameters(FireParameters mFireParameters) {
        this.mFireParameters = mFireParameters;
    }
}

