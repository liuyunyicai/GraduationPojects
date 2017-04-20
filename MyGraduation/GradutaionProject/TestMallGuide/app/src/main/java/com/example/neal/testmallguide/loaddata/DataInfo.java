package com.example.neal.testmallguide.loaddata;

import com.example.neal.testmallguide.floorsview.route.RouteInfo;
import com.squareup.okhttp.Route;

import java.util.List;

/**
 * Created by nealkyliu on 2017/4/7.
 */
public class DataInfo {
    private List<RouteInfo> routeInfos;
    private List<RouteInfo> fireInfos;
    private List<RouteInfo> crowdedInfos;
    private List<RouteInfo> dangerInfos;

    private static volatile DataInfo instance = null;

    private DataInfo() {}

    public static DataInfo getInstance() {
        if (null == instance) {
            synchronized (DataInfo.class) {
                if (null == instance) {
                    instance = new DataInfo();
                }
            }
        }
        return instance;
    }

    public List<RouteInfo> getRouteInfos() {
        return routeInfos;
    }

    public void setRouteInfos(List<RouteInfo> routeInfos) {
        this.routeInfos = routeInfos;
    }

    public List<RouteInfo> getFireInfos() {
        return fireInfos;
    }

    public void setFireInfos(List<RouteInfo> fireInfos) {
        this.fireInfos = fireInfos;
    }

    public List<RouteInfo> getCrowdedInfos() {
        return crowdedInfos;
    }

    public void setCrowdedInfos(List<RouteInfo> crowdedInfos) {
        this.crowdedInfos = crowdedInfos;
    }

    public List<RouteInfo> getDangerInfos() {
        return dangerInfos;
    }

    public void setDangerInfos(List<RouteInfo> dangerInfos) {
        this.dangerInfos = dangerInfos;
    }
}
