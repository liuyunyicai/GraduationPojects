package hust.mallguide.malls;

import retrofit.http.GET;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by admin on 2016/5/30.
 */
public interface MallServices {
    // 获取Styles
    @GET("{path}")
    Observable<StoreTypes[]> getStoreTypes(@Path("path")String path);
}
