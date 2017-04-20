package hust.mallguide.utils;

import android.content.Context;
import android.widget.Toast;

/**
 * Created by admin on 2016/3/24.
 */
public class ToastUtils {
    public static void show(Context context, String str) {
        if (str != null)
            Toast.makeText(context, str, Toast.LENGTH_SHORT).show();
    }

    public static void show(Context context, int str) {
        Toast.makeText(context, str, Toast.LENGTH_SHORT).show();
    }
}
