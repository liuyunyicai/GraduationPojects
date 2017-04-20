/*************************************************************************
 * Copyright (c) 2015 Lemberg Solutions
 * <p/>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **************************************************************************/

package com.ls.widgets.map.utils;

import android.graphics.Point;
import android.location.Location;
import android.util.Pair;
/** 保存了Map配置文件中的topLeft和bottomRight信息 **/
public class MapCalibrationData {
    private Pair<Point, Location> topLeft;    // 定义的TopLeft位置节点信息
    private Pair<Point, Location> bottomRight;// 定义的bottomRight位置节点信息

    private float widthInMeters;
    private float heightInMeters;

    private float results[];

    public MapCalibrationData(Pair<Point, Location> topLeft, Pair<Point, Location> bottomRight) {
        this.topLeft = topLeft;
        this.bottomRight = bottomRight;
        results = new float[3];

        // 将经纬度转化为具体的距离长度
        recalculateDistanceInMeters();
    }


    /**
     * @return returns width of the calibration rectangle in pixels
     */
    public int widthInPixels() {
        return bottomRight.first.x - topLeft.first.x;
    }


    /**
     * @return returns height of the calibration rectangle in pixels
     */
    public int heightInPixels() {
        return bottomRight.first.y - topLeft.first.y;
    }


    /**
     * @return Returns width of the calibration rectangle in degrees;
     */
    public double widthInDegrees() {
        return bottomRight.second.getLongitude() - topLeft.second.getLongitude();
    }

    /**
     * @return Returns height of the calibration rectangle in degrees;
     */
    public double heightInDegrees() {
        return topLeft.second.getLatitude() - bottomRight.second.getLatitude();
    }


    /**
     * @return Returns width of the calibration rectangle in meters;
     */
    public float getWidthInMeters() {
        return widthInMeters;
    }


    /**
     * @return Returns height of the calibration rectangle in meters;
     */
    public float getHeightInMeters() {
        return heightInMeters;
    }


    /** 将具体的Location转化为图片中具体的像素点位置
     * Converts location to position on the map.
     * @param location instance of android.location.Location object.
     * @param position - out parameter. Can be null.
     * @return returns the same object that was passed as position, or if it is null - returns new Point object.
     */
    public Point translate(final Location location, /*out*/Point position) {
        double heightCoef = (topLeft.second.getLatitude() - location.getLatitude()) / heightInDegrees(); // 简单的运算
        double widthCoef = (location.getLongitude() - topLeft.second.getLongitude()) / widthInDegrees();

        if (position == null) {
            position = new Point();
        }

        position.x = (int) (widthInPixels() * widthCoef + topLeft.first.x);
        position.y = (int) (heightInPixels() * heightCoef + topLeft.first.y);

        return position;
    }


    /**
     * Converts position on the map to location coordinates.
     * @param point - position on the map in pixels. Instance of android.graphics.Point
     * @param location - out parameter. Will contain latitude and longitude of point on the map.
     */
    public void translate(Point point, Location location) {
        translate(point.x, point.y, location);
    }


    /**
     * Converts position on the map to location coordinates.
     * @param x - x coordinate in map coordinate system.
     * @param y - y coordinate in map coordinate system.
     * @param location - out parameter. Will contain latitude and longitude of point on the map.
     */
    public void translate(int x, int y, Location location) {
        double heightCoef = (float) (topLeft.first.y - y) / (float) heightInPixels();
        double widthCoef = (float) (x - topLeft.first.x) / (float) widthInPixels();

        location.setLatitude(heightInDegrees() * heightCoef + topLeft.second.getLatitude());
        location.setLongitude(widthInDegrees() * widthCoef + topLeft.second.getLongitude());
    }


    // 计算地图中宽高对应经纬度的实际距离
    private void recalculateDistanceInMeters() {
        // 计算两个位置经纬度转化为距离为具体多少米
        Location.distanceBetween(topLeft.second.getLatitude(), topLeft.second.getLongitude(), topLeft.second.getLatitude(), bottomRight.second.getLongitude(), results);
        widthInMeters = results[0];

        // height
        Location.distanceBetween(bottomRight.second.getLatitude(), topLeft.second.getLongitude(), topLeft.second.getLatitude(), topLeft.second.getLongitude(), results);
        heightInMeters = results[0];
    }

}
