package com.example.neal.testmallguide.floorsview.route;

import java.util.List;

import retrofit.http.POST;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by nealkyliu on 2017/3/19.
 * 从服务器获取安全疏散路径
 */
public interface GetRouteServices {
    String GET_ROUTE_URL = "main.php";

    @POST("{path_name}")
    Observable<List<RouteInfo>> getRoute(@Path("path_name") String path_name);

}
