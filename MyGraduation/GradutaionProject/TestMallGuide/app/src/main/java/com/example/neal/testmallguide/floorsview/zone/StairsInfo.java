package com.example.neal.testmallguide.floorsview.zone;

/**
 * Created by nealkyliu on 2017/4/13.
 * 楼梯相关数据信息
 */
public class StairsInfo {
    private int grid_id;
    private int grid_x;
    private int grid_y;
    private int x_min;
    private int x_max;
    private int y_min;
    private int y_max;
    private int z_min;
    private int z_max;

    public StairsInfo() {
    }

    public StairsInfo(int grid_id, int grid_x, int grid_y, int x_min, int x_max, int y_min, int y_max, int z_min, int z_max) {
        this.grid_id = grid_id;
        this.grid_x = grid_x;
        this.grid_y = grid_y;
        this.x_min = x_min;
        this.x_max = x_max;
        this.y_min = y_min;
        this.y_max = y_max;
        this.z_min = z_min;
        this.z_max = z_max;
    }

    public int getGrid_id() {
        return grid_id;
    }

    public void setGrid_id(int grid_id) {
        this.grid_id = grid_id;
    }

    public int getGrid_x() {
        return grid_x;
    }

    public void setGrid_x(int grid_x) {
        this.grid_x = grid_x;
    }

    public int getGrid_y() {
        return grid_y;
    }

    public void setGrid_y(int grid_y) {
        this.grid_y = grid_y;
    }

    public int getX_min() {
        return x_min;
    }

    public void setX_min(int x_min) {
        this.x_min = x_min;
    }

    public int getX_max() {
        return x_max;
    }

    public void setX_max(int x_max) {
        this.x_max = x_max;
    }

    public int getY_min() {
        return y_min;
    }

    public void setY_min(int y_min) {
        this.y_min = y_min;
    }

    public int getY_max() {
        return y_max;
    }

    public void setY_max(int y_max) {
        this.y_max = y_max;
    }

    public int getZ_min() {
        return z_min;
    }

    public void setZ_min(int z_min) {
        this.z_min = z_min;
    }

    public int getZ_max() {
        return z_max;
    }

    public void setZ_max(int z_max) {
        this.z_max = z_max;
    }
}
