package com.example.neal.testmallguide.floorsview.route;

/**
 * Created by nealkyliu on 2017/3/19.
 * 安全疏散路径基本信息
 */
public class RouteInfo {
    private int route_step;
    private int grid_x;
    private int grid_y;
    private int grid_z;

    public RouteInfo() {
        this(0, 0, 0, 0);
    }

    public RouteInfo(int grid_x, int grid_y, int grid_z) {
        this(0, grid_x, grid_y, grid_z);
    }

    public RouteInfo(int route_step, int grid_x, int grid_y, int grid_z) {
        this.route_step = route_step;
        this.grid_x = grid_x;
        this.grid_y = grid_y;
        this.grid_z = grid_z;
    }

    public int getRoute_step() {
        return route_step;
    }

    public void setRoute_step(int route_step) {
        this.route_step = route_step;
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

    public int getGrid_z() {
        return grid_z;
    }

    public void setGrid_z(int grid_z) {
        this.grid_z = grid_z;
    }
}
