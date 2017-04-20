package aco;

/**
 * Grid栅格建模相关参数
 */
public class GridParameters {
    public int interval_x;
    public int interval_y;
    public int interval_z;
    
    public int x_max;
    public int y_max;
    public int z_max;
    
    

    public GridParameters() {
    }

    public GridParameters(int interval_x, int interval_y, int interval_z, int x_max, int y_max, int z_max) {
        this.interval_x = interval_x;
        this.interval_y = interval_y;
        this.interval_z = interval_z;
        this.y_max = y_max;
        this.z_max = z_max;
        this.x_max = x_max;
    }
    
    
    

    public int getInterval_x() {
        return interval_x;
    }

    public void setInterval_x(int interval_x) {
        this.interval_x = interval_x;
    }

    public int getInterval_y() {
        return interval_y;
    }

    public void setInterval_y(int interval_y) {
        this.interval_y = interval_y;
    }

    public int getInterval_z() {
        return interval_z;
    }

    public void setInterval_z(int interval_z) {
        this.interval_z = interval_z;
    }
    
    public int getGridSize() {
    	return x_max * y_max * z_max;
    }
}

