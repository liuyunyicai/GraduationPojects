package com.example;

/**
 * Created by nealkyliu on 2017/4/5.
 * Grid栅格建模相关参数
 */
public class GridParameters {
    private int interval_x;
    private int interval_y;
    private int interval_z;

    public GridParameters() {
    }

    public GridParameters(int interval_x, int interval_y, int interval_z) {
        this.interval_x = interval_x;
        this.interval_y = interval_y;
        this.interval_z = interval_z;
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
}
