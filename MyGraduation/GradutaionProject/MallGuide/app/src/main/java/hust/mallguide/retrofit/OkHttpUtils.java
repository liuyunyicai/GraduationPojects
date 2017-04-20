package hust.mallguide.retrofit;

import android.content.Context;

import com.squareup.okhttp.OkHttpClient;

import hust.mallguide.retrofit.okhttp.OkHttpClientUtils;
import retrofit.GsonConverterFactory;
import retrofit.Retrofit;
import retrofit.RxJavaCallAdapterFactory;

/**
 * Created by admin on 2016/5/31.
 */
public class OkHttpUtils {

    private static volatile OkHttpUtils instance = null;
    private Retrofit retrofit;
    private OkHttpClient client;
    public static final String BASE_URL = "http://115.156.187.146/NavigationServer/";
    public static final String SERVER_PACKAGE = "NavigationServer";


    private OkHttpUtils(Context context) {
        // 添加拦截器
        client = OkHttpClientUtils.getDefault(context);

        retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .client(client)  // 添加okHttp
                .addConverterFactory(GsonConverterFactory.create()) // GSON进行转换
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .build();
    }

    public static OkHttpUtils getInstance(Context context) {
        if (instance == null) {
            synchronized (OkHttpUtils.class) {
                if (instance == null) {
                    instance = new OkHttpUtils(context);
                }
            }
        }
        return instance;
    }

    public Retrofit getRetrofit() {
        return retrofit;
    }

    public <T> T create(Class<? extends T> clazz) {
        return retrofit.create(clazz);
    }

    public OkHttpClient getClient() {
        return client;
    }
}