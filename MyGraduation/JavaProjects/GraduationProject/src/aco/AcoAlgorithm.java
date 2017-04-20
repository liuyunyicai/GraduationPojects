package aco;

import java.util.Arrays;
import java.util.Random;

public class AcoAlgorithm implements ConstantValues{
    private GridInfo[][][] mGridInfos;
    private int[] mEntranceGrid; // ��ڵ�
    private int[][] mExitGrids;  // ���ڵ�
    private int[][] mFireGrids;
    private int[][] mPreferedGrids;
    private AcoParameters mAcoParameters;
    private GridParameters mGridParameters;
    private FireParameters mFireParameters;

    /**
     * ���캯�� 
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
     * ��Ҫ��ִ�к��� 
     **/
    public OutputDatas doACO() {
    	OutputDatas outputDatas = OutputDatas.getInstance(mAcoParameters.getCycle_max(), mAcoParameters.getMaxStep());
    	// ��Ϣ��Ũ�Ⱦ���
    	double[][][][] Tau = new double[mGridParameters.x_max][mGridParameters.y_max][mGridParameters.z_max][mAcoParameters.mNextvals.length];
    	
    	int cycle_times = 1;
    	
    	while (cycle_times <= mAcoParameters.cycle_max) {
    		acoRecycle(cycle_times, outputDatas, Tau);
    	}
    	
    	return outputDatas;
    	
    }
    
    /**
     * ��Ⱥ�������� 
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

    	
    	// ��ʼ����һ��
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
    			// ��������յ�
    			if (isMember(mExitGrids, CurGrid_pos) >= 0) {
    				outputDatas.mAntArriveTimes[cycle_times] += 1; 
    				System.out.printf("ant%d arrive,total %d arrived \n", j, outputDatas.mAntArriveTimes[cycle_times]);
    			}
    			
    			// ������±�ʾ�����ϲ��ü�������������ѭ��
    			if ((CurGrid_pos[0] == -1) || (isMember(mExitGrids, CurGrid_pos) >= 0)) 
    				break;
    			
    		    // ��ʾ����δ���ڣ���Ҫ����ִ������ѭ��
    			// ======= ���㵽��һ���ڵ��ת�Ƹ��� ======= % ������Route���൱�ڽ��ɱ���                                          
    			int x = CurGrid_pos[1];
    			int y = CurGrid_pos[2];
    			int z = CurGrid_pos[3]; 
    			
    			// �����ýڵ����ڵ���ص�                               
    			double[] P = new double[nextval_size];       // ��Զ�㵽n�����е�ת�ƾ�������ȫ����ʼ��Ϊ0��ע�����ﱣ���˵�ǰ�㣬��ͳ��ʱ��Ӧע��ȥ����
    			double[] Fijs = new double[nextval_size];    // �����ݴ��˹��Ƴ���
    			double[][][] TempTimes = new double[ant_num][max_step + 1][nextval_size]; // �����ݴ�ͨ����ת��·������Ҫ����ɢʱ��
    			
    			double[] Temp_Inspires = new double[nextval_size];
    			double[] Temp_Eta = new double[nextval_size];
    			double[] Temp_T = new double[nextval_size];
    			
    			// �������ڽڵ�
    			for (int temp_size = 0; temp_size < nextval_size; temp_size ++) {
    				int nextval_x = mAcoParameters.mNextvals[temp_size][0];
    				int nextval_y = mAcoParameters.mNextvals[temp_size][1];
    				int nextval_z = mAcoParameters.mNextvals[temp_size][2];
    				
    				int next_x = x + nextval_x;
    				int next_y = y + nextval_y;
    				int next_z = z + nextval_z;
    				
    				// �жϸö�Ӧ���Ƿ����
    				if (((next_x >= 1) && (next_x <= x_max)) && ((next_y >= 1) && (next_y <= y_max)) && ((next_z >= 1) && (next_z <= z_max))) {
    					// ==================== ����ת�Ƹ��� ==============
    					GridInfo NextGridInfo = mGridInfos[next_x - 1][next_y - 1][next_z - 1]; // ��һդ��������Ϣ
    					// ���ȼ���ÿ��ת��·��������ʽ���ش�С(��������ʱ�Ǿ���ĵ���)
   					 	double dis = Math.pow((nextval_x * mGridParameters.interval_x), 2) + 
   					 				 Math.pow((nextval_y * mGridParameters.interval_y), 2) + 
   					 				 Math.pow((nextval_z * mGridParameters.interval_z), 2);
   					 	dis = Math.pow(dis, 0.5);   
    					double eta = 1 / dis;  // ��������
    					Eta[j][x - 1][y - 1][z - 1][temp_size] = eta; // ��¼����
    					Temp_Eta[temp_size] = eta;
    					
    					// ȡ���õ��Ӧ����Ϣ��
   					 	double tau = Tau[x - 1][y - 1][z - 1][temp_size];
   					 	
   					 	// *************  �ټ���ת�Ƹ��� ************
   					 	boolean is_visited = false; // ��־�ýڵ��Ƿ��Ѿ����ʹ�
   					 	int[] ToSearch = {next_x, next_y, next_z};
   					 	if (isMember(Route[j], ToSearch) >= 0)
   					 		is_visited = true;
   					 	
   					 	double p_value = 0;
   					 	double p_coeff = 1; // ϵ��
   					 	
   					 	if (is_visited) { // ��ʾ�Ѿ����ʹ�����ת�Ƹ���Ϊ0 ��������һ���Ż���Ϊ�˱������Ͻ�������ͬ�����������Ͽ��Է����Ѿ����ʹ��Ľڵ㣩 
   					 		if ((mAcoParameters.getIsOptimized(OPTIMIZE_8)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
   					 			p_coeff = 0.000001;
   					 		} else {
                                p_coeff = 0;
   					 		}
   					 	}
   					 	
   					 	if (NextGridInfo.getIsFree() != ISACCESSED_ZONE)   //	 ������ϰ�����߻�������ת�Ƹ���Ϊ0
   							 p_coeff = 0;
   					 	else {
   					 		// =============== ���������Ӱ������ ============= %
   	                         double Easy_total = 1; // ���Լ�¼ͨ������ϵ���ĳ˻�
	   	                     if ((mAcoParameters.getIsOptimized(OPTIMIZE_10)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	   	                    	  // �����һ���ڵ�ΪPreferGids�еĽڵ㣬��
	   	                    	  if (isMember(mPreferedGrids, ToSearch) >= 0)
	   	                    		p_coeff = 10;
	   	                     }
	   	                     
	   	                     double v_base = v0;
	   	                     if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	   	                    	 double thita = 0.5; // Σ���Գͷ�ϵ��
	                             // ������Ӧ���ֳ�������Ⱥ�㷨��������
	                             double inpsire = Math.pow((dis / v0), (thita - 1));
	                             Inspires[j][x - 1][y - 1][z - 1][temp_size] = inpsire; 							 
	                             double R_total = 1;    // ���Լ�¼Σ����ϵ��R�ĳ˻�
	                             Easy_total = 1; // ���Լ�¼ͨ������ϵ���ĳ˻�
	                             double[] R_totals = new double[3]; // �ݴ�ÿһ���е�����
	                             double[] Easy_totals = new double[3];
	                             double v_cur = v0; // ����ͨ�е��ٶ�
	                             double cur_time = Time[j] + mFireParameters.warning_time; // ��ȡ��ǰ·���ϵ�Timeʱ��
	                             
	                             if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE1)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            	 double T = NextGridInfo.temperature;// �𳡵��¶�
	                            	 
	                            	 if (T >= DEATH_TEMPERATURE)  { // ��ʾ�������򣬲�ͬͨ��
	                            		 Easy_totals[0] = 0;
	                            		 System.out.println("DEATH_TEMPERATURE");
	                            	 } else {
                                         double t_beta = 0.03;  // ����ϵ��
                                         double t_eta = 0.5;   // �¶�������˥��ϵ��
                                         double t_miu = 0.4;
                                         double T_deta = 0;
                                         
                                         if (0 == FIRE_LOCKED) {
                                        	 for (int[] fireGrid : mFireGrids) {
                                        		 // ��ȡ��Դλ��
	                                             int fire_x = fireGrid[0];
	                                             int fire_y = fireGrid[1];
	                                             int fire_z = fireGrid[2];
	                                             
	                                             if (fire_z == next_z ) {// ��������ͬһ¥��Ļ�ԴӰ��
	                                            	// �����Դ���û���ǰλ�õľ���
	                                            	 double Tfire = mGridInfos[fire_x - 1][fire_y - 1][fire_z - 1].temperature;
	                                            	 double Tz = 345 * Math.log10(8 * cur_time / 60 + 1);// ��������Ƹ��»�Դ���¶�ֵ
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
	                                     double Tc = 30;  // �����¶�Ϊ30��
	                                     
	                                     double r_fai1 = 0.2;            // ����Σ��ϵ��Ӱ������
	                                     double R1 = Math.pow((T / Tc), 3.61); // �¶�Σ��ϵ��
	                                     
	                                     double Tc1 = 30;
	                                     double Tc2 = 60; // ���������Σ���¶�
	                                     double Td = DEATH_TEMPERATURE * SEARCH_DEATH_PARAM; // ���������¶�
	                                     double  vmax = 3.0; // ��������µ������ɢ�ٶ�
	                                     double  Easy1 = 1;// ���¶��µ�ͨ������ϵ��															 
	                                     double  easy_gama1 = 1; // �¶�ͨ������ϵ��Ӱ������
	                                     
	                                     if ((T >= Tc1) && (T < Tc2)) {
	                                    	 Easy1 = v0 / ((vmax - 1.2) * ((T - Tc1) / (Math.pow((Tc2 - Tc1), 2))) + v0);
	                                     } else if ((T >= Tc2) && (T < Td)) {
	                                    	 Easy1 = (1.2 / vmax) * (1 - (Math.pow((T - Tc2) / (Td - Tc2), 2)));
	                                     } else if(T >= Td) {
	                                    	 Easy1 = 0;
	                                     }
	                                     
	                                     //==== �õ����ս�� =====// 
	                                     // ����Σ����Ӱ��������ͨ�����׶�Ӱ������
	                                     R_totals[0] = Math.pow(R1, r_fai1) ;
	                                     Easy_totals[0] = Math.pow(Easy1, easy_gama1);
	                            	 }
	                            	 
	                            	// =========== ��������Ũ�ȵ�Ӱ�� ========= //
	                            	 if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE2)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            		 if (Easy_totals[0] != 0)  {// ���Ϊ����������ֱ������ʣ�µļ���	
	                            			 double C = NextGridInfo.smokeCon * 100;   // ����Ũ��
	                            			 double C_O2 = NextGridInfo.O2Con * 100;   // ����Ũ��
	                            			 double C_CO = NextGridInfo.CO2Con * 100 * 1000;   // һ����̼Ũ��(ppm)
	                            			 double C_CO2 = NextGridInfo.CO2Con * 100; // ������̼Ũ��
	                            			 
	                            			 if (((C_O2 > 0) &&(C_O2 <= DEATH_O2)) || (C_CO >= DEATH_CO) || (C_CO2 >= DEATH_CO2)) // ����Σ��Ũ�ȣ�����ΪΣ������
	                                         	Easy_totals[1] = 0;
	                            			 else {
	                            				// ������������ɢ��ʽ
		                                        double k_somke = 0.09;
		                                        double C_deta = 0;
		                                        if (0 == FIRE_LOCKED) {
		                                        	for (int[] fireGrid : mFireGrids) {
		                                        		 // ��ȡ��Դλ��
			                                             int fire_x = fireGrid[0];
			                                             int fire_y = fireGrid[1];
			                                             int fire_z = fireGrid[2];
			                                             double Q = mGridInfos[fire_x - 1][fire_y - 1][fire_z - 1].smokeCon * 100; 
			                                             if (fire_z == next_z) {// ��������ͬһ¥��Ļ�ԴӰ��
			                                            	// �����Դ���û���ǰλ�õľ���
		                                                    double slength = Math.pow(((next_x - fire_x) * mGridParameters.interval_x), 2) + 
		                                                    		Math.pow(((next_y - fire_y) * mGridParameters.interval_y), 2) +
		                                                    		Math.pow(((next_z - fire_z) * mGridParameters.interval_z), 2);
		                                                    C_deta =  (Q * 1)  * Math.exp((Math.pow(-slength, 1.5)) / (4 * k_somke * cur_time));
			                                             }
		                                        	}
		                                        }
		                                        
		                                        if (C_deta != 0)
		                                        	C = C_deta; // ������ɢ������Ũ����ʱ��仯ֵ
		                                        
		                                        // ��ȫ�����µĸ�������Ũ��
		                                        double Csafe_O2 = 21;
		                                        double Csafe_CO = 0.01 * 10000;
		                                        double Csafe_CO2 = 5; // �ٷֱ�
		                                        
		                                        // �ȼ�����ɢ�ٶ�
		                                        double vk = 0.706 + (-0.057) * 0.248 * C; // ����ϵ���������ٶȹ�ʽ(CΪ�ٷֱ�)
		                                        double Easy2 = vk / v0;  // ����Ũ��Ӱ���µ�ͨ������ϵ��
		                                        double tk = dis / vk;    // �ڸ�����Ũ���µ�ͨ��ʱ��
		                                        
		                                        // ����Σ����
		                                        double FEDco = 4.607 * Math.pow(10, -7) * Math.pow(C_CO, 036) * tk;
		                                        double FEDo2 = tk / (60 * Math.exp(8.13- 0.54 * (20.9 - C_O2))) ;
		                                        double HVco2 = Math.exp(0.1930 * C_CO2 + 2.004) / 7.1; 
		                                        double FED = FEDco * HVco2 + FEDo2; 
		                                        
		                                        // ��Σ������µ���Ϣ��ʽֵ
		                                        double FEDc_co = 4.607 * (10 ^ (-7)) * Math.pow(Csafe_CO, 1.036) * tk;
		                                        double FEDc_o2 = tk / (60 * Math.exp(8.13- 0.54 * (20.9 - Csafe_O2))) ;
		                                        double HVcc_o2 = Math.exp(0.1930 * Csafe_CO2 + 2.004) / 7.1; 
		                                        double FEDc = FEDc_co * HVcc_o2 + FEDc_o2; 
		                                        
		                                        // ����Ũ���µ�Σ�ճ̶�ϵ�� 
		                                        double R2 = FED / FEDc;

		                                        double r_fai2 = 1;
		                                        double easy_gama2 = 1;

		                                        // ===== �õ����ս�� ===== //
		                                        R_totals[1] = Math.pow(R2, r_fai2);
		                                        Easy_totals[1] = Math.pow(Easy2, easy_gama2);	
	                            			 }
	                            		 }
	                            	 }
	                            	// ============ ���������ܶȵ�Ӱ�� ============ //
	                            	 if ((mAcoParameters.getIsOptimized(OPTIMIZE_FIRE3)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            		 if ((Easy_totals[0] != 0) && (Easy_totals[1] != 0)) {
	                            			 int peoplenum = NextGridInfo.peopleNum;// �����ܶ�
	                            			 double p = peoplenum * 0.12 / (mGridParameters.interval_x * mGridParameters.interval_y);
	                            			 
	                            			 double pc = 0.92; // ���谭ʱ�������ܶ�
	                            			 if (p >= DEATH_PEOPLE_NUM) { // ��ʾ��Ⱥ����ӵ������˲�����ͨ��
	                            				 Easy_totals[2] = 0; 
	                            			 } else {
	                            				 int grid_type = NextGridInfo.gridType; // ��ȡ��ͨ��������
	                            				 if (p >= 0)  {// ��ʾͨ��������
	                            					// ����ͨ���ٶ�
                                                     double v3 = (112 * Math.pow(p, 4) - 380 * Math.pow(p, 3) + 434 * Math.pow(p, 2) - 217 * p + 57) / 60;
                                                     v3 = (1.49 - 0.36 * p) * v3 * v0;
                                                     v_base = v3;
                                                     if (grid_type == DOOR_POINT) // ͨ���ſ�ͨ��
                                                        v3 = (1.17 + 0.13 * Math.sin(6.03 * p - 0.12)) * v3;
                                                     else if (grid_type ==  STAIRCASE_POINT) { // ����¥��ͨ���ٶ�
                                                    	 if (nextval_z == 1) // ��ʾ��¥
                                                    		 v3 = 0.4887 * v3;
                                                         else if (nextval_z == -1)
                                                             v3 = 0.6466 * v3;
                                                     }
                                                     
                                                     if (p == 0)
                                                         p = 0.01;
                                                     double R3 = p / pc;      // �����ܶ��µ�Σ��ϵ��
                                                     double Easy3 = v3 / v0;  // �����ܶ��µ�ͨ������ϵ��

                                                     double r_fai3 = 1;
                                                     double easy_gama3 = 1;

                                                     R_totals[2] = Math.pow(R3, r_fai3);
                                                     Easy_totals[2] = Math.pow(Easy3, easy_gama3);
	                            				 }
	                            			 }
	                            		 }
	                            	 }
	                            	 
	                            	 
	                            	 // �������ĳ˻�
	                                 double easy_min = Easy_totals[0];
	                                 for (int index = 0; index <= R_totals.length; index ++) {
	                                	 R_total = R_total * R_totals[index];
	                                	 Easy_total = Easy_total * Easy_totals[index];
		                                 // ѡȡ��С�ٶ�
		                                 easy_min = Math.min(easy_min, Easy_totals[index]);
	                                 }
	                                 
	                                 // ���ݻ��ֳ�������Ⱥ�㷨�����������������յ��������ӵ�ֵ
	                                 if ((R_total == 0) || (Easy_total == 0))
	                                    eta = 0;
	                                 else
	                                    eta = Math.pow(R_total, (-thita)) * Math.pow(Easy_total, (1 - thita))* inpsire;						 
	                                 Inspires[j][x - 1][y - 1][z - 1][temp_size] = eta;
	                                                 
	                                 // �����ݴ�ͨ����ͨ��ת������Ҫ��ʱ��
	                                 v_cur = v_base * easy_min;
	                                 if (v_cur == 0)
	                                     TempTimes[j][L[j] - 1][temp_size] = Integer.MAX_VALUE;
	                                 else
	                                	 TempTimes[j][L[j] - 1][temp_size] = dis / v_cur;
	                                 
	                                 Temp_Inspires[temp_size] = eta;
	                             }
	                             //=============== �����˹��Ƴ�Ӱ������ ============= //
	                             if ((mAcoParameters.getIsOptimized(OPTIMIZE_1)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
	                            	// �����Ƚ��м��㣬�洢������Ȼ��������
                                    int exit_nums = mExitGrids.length; // ���ڶ�������������
                                    
                                    double f_x = 0;   // �˹��Ƴ�����ʸ������
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
                                    
                                    int fire_nums = mFireGrids.length; // ��Դ������ϵĳ�������
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
                                    
                                    int prefer_sizes = mPreferedGrids.length; // ¥���ȳ��ڵ���������
                                    double prefer_z_param = 1000;
                                    for (int k = 0; k < prefer_sizes; k++) {
                                    	if ((next_z == mPreferedGrids[k][2]) && (next_z != 1))  {// ֻ����ͬһ¥��ĳ���λ��
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
                                    
                                    // z�᷽���Ӱ��ϵ��
                                    double z_param = 1000;

                                    // ǰ������ĵ�λ����nij
                                    double n_x = nextval_x;
                                    double n_y = nextval_y;
                                    double n_z = nextval_z * z_param;

                                    //�˹��Ƴ������ô�С�Ǻ���Fij����ǰ��λ�÷�������ʸ�����
                                    Fijs[temp_size] = f_x * n_x + f_y * n_y + f_z * n_z; 
	                             }
	   	                     }
   	                         
	   	                  // ԭʼ��ת�Ƹ���
	 					 p_value =  Math.pow(tau, mAcoParameters.Alpha) * Math.pow(eta, mAcoParameters.Beta);
	 					 p_value = p_coeff * p_value;
	 					 
	 					 P[temp_size] = p_value;     

	//                   fprintf('next= (%d, %d, %d)�� P= %d\n',nextval_x, nextval_y, nextval_z, p_value);
   					 	}
    				}
    				
    				//========== �����˹��Ƴ�Ӱ������ ========== //
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
    						// �����д�����
    						Fijs = Utils.division(Fijs, sumValue);
		                    Fijs = Utils.exps(Fijs);  
		                    Fijs = Utils.pows(Fijs, f_cigma);
		                    // ���˹��Ƴ�����ת�Ƹ��ʵļ�����
		                    P = Utils.dot(P, Fijs);
    					}
    				}
    				// ��P������Ԫ����ͣ�Ȼ����ȡƽ��ֵ  
    				P = Utils.division(P, Utils.sum(P)); 
    				
    				// *************** ���̶ķ�ʽѡ����һ������ ******************
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
								if (mGridInfos[x + nextval_x - 1][y + nextval_y - 1][z + nextval_z - 1].isFree == ISACCESSED_ZONE) {// �޳����ϰ������
									NextGrid_Selected[0] = nextval_x; 
									NextGrid_Selected[1] = nextval_y;
									NextGrid_Selected[2] = nextval_z;//ѡ����һ����ŵ�
									int[] B = {nextval_x, nextval_y, nextval_z};
									int next_size = isMember(mAcoParameters.mNextvals, B);
									
									// �жϸýڵ��Ƿ��Ѿ����ʹ�					 
								    int[] tempToSearch = {x + nextval_x, y + nextval_y, z + nextval_z};
									int temp_visited = isMember(Route[j], tempToSearch);
									
									// ����ʱ��
		                            Time[j] += TempTimes[j][L[j] - 1][next_size];
		                            double temp_time = TempTimes[j][L[j] - 1][next_size];
		                            
		                            if (temp_visited >= 0) {
		                            	for (int index = temp_visited; index >= L[j] - 1; index ++) {
		                            		for (int i_index = 0; i_index < 3; i_index++)// ���ظ�ֵ�����·��ȫ�����
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
		                            // ѡ��ת�ƽڵ������ѭ��
			                        break;
								}
							}
						}
    				}
    				L[j] = L[j] + 1; // ѡ���˳����������ƽ�һ��
                    Step[j] = Step[j] + 1; //������1
        			if (L[j] <= mGridParameters.getGridSize())
        				if  ((Utils.isEqual(NextGrid_Selected, new int[]{0, 0, 0})) || (Step[j] > max_step))//��ʾͣ����ԭ�� ���߳��������
        					Utils.fill(Route[j][L[j] - 1], new int[] {-1, -1, -1});
        				else {
        					//��¼��һ��·��
        					Utils.fill(Route[j][L[j] - 1], new int[] {x + NextGrid_Selected[0], y + NextGrid_Selected[1], z + NextGrid_Selected[2]});
                            
                            if (OUTPUT_ROUTE == 1)
                                System.out.printf("Route Step%f:(%f,%f,%f)\n", Step[j],Route[j][L[j] - 1][0] , Route[j][L[j] - 1][1] , Route[j][L[j] - 1][2]);
                            
        					is_moved = true; // ��ʾ�������ƶ��������㷨������Ч��ͣ��
        				}
        					
    			}
    		}
    		System.out.printf("%d,%d,==%d,(%d,%d,%d),step=%d, Time=%d\n", cycle_times, j, L[j],Route[j][L[j] - 1][0], Route[j][L[j] - 1][1], Route[j][L[j] - 1][2],Step[j], Time[j]);
    	}
    	
    	
    	//// ============== ����������¼���ε������·�� ============= ////
    	double[] Length = new double[ant_num];  // ����ͳ��ÿֻ���ϵ�·��ֵ(���ﲻ������ָ����)  
    	Arrays.fill(Length, Integer.MAX_VALUE);
    			//  disp(Eta);
    	for (int i = 0; i < ant_num; i++)	{// ͳ��ÿֻ���ϵ�����·����Ȩֵ�ͣ����ﲻ������·���ľ��룬ͬʱ���������������أ�ʹ��Eta���м���,����Eta��ʱ�䵼����ʱ��ʵ������Թ�ϵ���ʶ�������ѰEta^(-1)����С��ֵ���ɣ�
    		int[][] AntRoute = Route[i];
    		int temp_max = Math.min(L[i], max_step) - 1;
    		for (int j = 0; j < temp_max; j++) {
    			// ������������ͬ�����
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
    	outputDatas.mCycleLength[cycle_times] = min_value; //��¼ÿ�ε����е����·��������ָ��ʱ����·����
    	int ant_pos = Arrays.binarySearch(Length, min_value); // �ҵ�ʵ�����·��������
    	   
    	double min_time = Utils.min(Time);
    	outputDatas.mCycleTime[cycle_times] = min_time;
	    ant_pos = Arrays.binarySearch(Time, min_time); 
	    outputDatas.mCycleRoute[cycle_times] = Route[ant_pos]; //��¼ÿ�ε��������·��
	    
	    
	    // �������ѭ�������·������
	    System.out.printf("��%d��ѭ����ѳ���:%d,��Ѳ���:%d�����ʱ��:%d\n", cycle_times, outputDatas.mCycleLength[cycle_times], L[ant_pos], Time[ant_pos]);
	   
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

	    cycle_times = cycle_times + 1; // ������һ�ֵ���
	    
	    //// ============== ���Ĳ���������Ϣ�� =================== ////
		double[][][][] Delta_Tau = new double[x_max][y_max][z_max][nextval_size];        // ��ʼʱ��Ϣ��Ϊn*n��0����
		double Length_min = Utils.min(Length);     //�ҵ������Сֵ
		double Length_max = Utils.max(Length);
		double thita = 50.0;                  //��Ϣ���������Ӱ������(�Ż�����4)
	    
		for (int i = 0; i < ant_num; i++) {
			int j_max = Math.min(L[i], max_step) - 1;
			for (int j = 0; j < j_max; j++) {
				int[] pre = Route[i][j];
				int[] next = Route[i][j + 1];
				
				if ((Utils.isEqual(pre, new int[] {-1, -1, -1})) || (Utils.isEqual(next, new int[] {-1, -1, -1}))) {
					
				} else {
					int[] nextval = Utils.sub(next, pre);
					
					int temp_temp_size = isMember(mAcoParameters.mNextvals, nextval);
					
					// �˴�ѭ����·����i��j���ϵ���Ϣ������ (TODO:���ڽ�������ͬ��������û�б�Ҫ������Ϣ�أ��Լ���Ժ�������ϲ���������Ӱ�죬�����д���֤)
					double temp_deta = mAcoParameters.Q / Length[i];
					
					int x = pre[0];
					int y = pre[1];
					int z = pre[2];
					
					// ======= �Ż�����4, �����С·������Ϣ�������Ż� ======== //
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
		
		// =========== �Ż�����3�� ����Ӧ��Ϣ��Ũ�Ȼӷ����� ================= //
		if ((mAcoParameters.getIsOptimized(OPTIMIZE_3)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
			// �Զ��������Ϣ�ػӷ�����Rhoֵ
			double Rho0 = 0.6;
			double Rho_min = 0.5;
			double fai = 0.99;
			double temp_rho = Rho0 * (Math.pow(fai, (cycle_times - 1)));
			if (temp_rho <= Rho_min)
				temp_rho = Rho_min;
			mAcoParameters.Rho = temp_rho;
		}
		
		//************************* ������Ϣ�� ********************* %
		Tau = Utils.plus(Utils.multi(Tau, (1 - mAcoParameters.Rho)), Delta_Tau) ; //������Ϣ�ػӷ������º����Ϣ��

		// =========== �Ż�����2�� ����Ӧ�����С��Ⱥ�㷨��ֵ ================= //
		if ((mAcoParameters.getIsOptimized(OPTIMIZE_2)) || (mAcoParameters.getIsOptimized(OPTIMIZE_ALL))) {
			// �趨�����С��Ⱥ������ֵ
			double Rho_k = 0.5;
			double temp_Q = 500;   // �����С��Ⱥ�㷨��������
			double L_min = Utils.min(Length);
			
			if (L_min != Double.MAX_VALUE) {
				double tau_max =( (1 + Rho_k) / (2 * (1 - Rho_k)* L_min) +  (2 * (1 - Rho_k) )/ L_min) * temp_Q;
                double tau_k = 200;
                double tau_min = tau_max / tau_k;
      
//                 tau_max = 4;
//                 tau_min = 0.01;
                System.out.printf("Tau max=%d, min=%d, tau=[%d, %d]\n", Utils.max(Tau), Utils.min(Tau), tau_max, tau_min);
                //����ϢŨ���޶���ֵ Tau = ones(x_max, y_max, z_max, 1)
                
                
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
    
    
    
    // �ж��������Ƿ����
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
    
    
    /*************************** Getter Setter����***************************/

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
