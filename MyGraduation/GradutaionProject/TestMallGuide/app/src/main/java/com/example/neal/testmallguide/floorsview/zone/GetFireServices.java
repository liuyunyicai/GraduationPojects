package com.example.neal.testmallguide.floorsview.zone;

import com.example.neal.testmallguide.floorsview.route.RouteInfo;

import java.util.List;

import retrofit.http.POST;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by neal on 2017/3/24.
 * 获取火灾区域
 */
public interface GetFireServices {
    String GET_ZONE_URL = "fire.php";
    String GET_CROWED_URL = "crowded.php";
    String GET_DANGER_URL = "danger.php";

    @POST("{path_name}")
    Observable<List<RouteInfo>> getZone(@Path("path_name") String path_name);
}
