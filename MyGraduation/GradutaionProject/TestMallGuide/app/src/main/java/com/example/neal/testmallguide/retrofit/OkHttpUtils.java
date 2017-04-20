package com.example.neal.testmallguide.retrofit;

import android.content.Context;

import com.example.neal.testmallguide.retrofit.okhttp.OkHttpClientUtils;
import com.squareup.okhttp.OkHttpClient;

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
    public static final String BASE_URL = "http://115.156.162.156/BuildingGuideServer/";
//    public static final String BASE_URL = "http://172.28.126.10/BuildingGuideServer/";
//    public static final String BASE_URL = "http://222.20.60.222/BuildingGuideServer/";
//    public static final String BASE_URL = "http://192.168.191.1/BuildingGuideServer/";
    public static final String SERVER_PACKAGE = "BuildingGuideServer";


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