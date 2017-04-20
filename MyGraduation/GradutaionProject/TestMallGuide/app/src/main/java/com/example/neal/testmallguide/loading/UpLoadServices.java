package com.example.neal.testmallguide.loading;

import retrofit.http.Body;
import retrofit.http.POST;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by nealkyliu on 2017/3/18.
 * 向服务器上传位置信息
 */
public interface UpLoadServices {
    String UPLOAD_URL = "Load.php";

    @POST("{path_name}")
    Observable<String> login(@Path("path_name") String path_name, @Body UserGirdInfo params);
}
