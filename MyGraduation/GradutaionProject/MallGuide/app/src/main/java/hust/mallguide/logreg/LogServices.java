package hust.mallguide.logreg;

import retrofit.http.Body;
import retrofit.http.POST;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by admin on 2016/5/30.
 */
public interface LogServices {
    String LOGIN_URL = "Login.php";

    @POST("{path_name}")
    Observable<UserInfoDetails> login(@Path("path_name") String path_name, @Body UserInfo params);
}
