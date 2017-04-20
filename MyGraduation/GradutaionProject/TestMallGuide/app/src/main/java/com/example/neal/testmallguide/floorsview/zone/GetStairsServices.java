package com.example.neal.testmallguide.floorsview.zone;

import com.example.neal.testmallguide.floorsview.route.RouteInfo;

import java.util.List;

import retrofit.http.POST;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by nealkyliu on 2017/4/13.
 */
public interface GetStairsServices {
    String GET_STAIRS_URL = "stairs.php";
    @POST("{path_name}")
    Observable<List<StairsInfo>> getStairsZone(@Path("path_name") String path_name);
}
