package hust.mallguide.utils;

import android.util.Log;

/**
 * Created by admin on 2016/3/23.
 */
public class LogUtils {
    private static final String LOG_TAG = "LOG_TAG";

    public static void i(String msg) {
        Log.i(LOG_TAG, msg);
    }

    public static void w(String msg) {
        Log.w(LOG_TAG, msg);
    }

    public static void e(String msg) {
        Log.e(LOG_TAG, msg);
    }

    public static void v(String msg) {
        Log.v(LOG_TAG, msg);
    }

    public static void d(String msg) {
        Log.d(LOG_TAG, msg);
    }

}
