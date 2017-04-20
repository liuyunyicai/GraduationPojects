package hust.mallguide.retrofit.okhttp;

import android.content.Context;

import com.squareup.okhttp.OkHttpClient;

import java.net.CookieManager;
import java.net.CookiePolicy;
import java.net.CookieStore;

import hust.mallguide.retrofit.cookie.PersistentCookieStore;


/**
 * Created by admin on 2016/4/25.
 */
public class OkHttpClientUtils{

    private static volatile CookieManager COOKIE_MANAGER;

    public static CookieManager getCookieManager(Context context) {
        if (COOKIE_MANAGER == null) {
            synchronized (OkHttpClientUtils.class) {
                if (COOKIE_MANAGER == null) {
                    COOKIE_MANAGER = new CookieManager(new PersistentCookieStore(context.getApplicationContext()), CookiePolicy.ACCEPT_ALL);
                }
            }
        }
        return COOKIE_MANAGER;
    }

    public static CookieStore getCookieStore(Context context) {
        return getCookieManager(context).getCookieStore();
    }

    //
    public static OkHttpClient getDefault(Context context) {
        OkHttpClient client = new OkHttpClient();
        client.interceptors().add(new LoggingInterceptor());
        // 添加CookieHandler
        client.setCookieHandler(getCookieManager(context));

        return client;
    }

}
