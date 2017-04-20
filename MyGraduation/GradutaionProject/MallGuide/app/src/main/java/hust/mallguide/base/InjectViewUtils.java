package hust.mallguide.base;

import android.app.Activity;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import hust.mallguide.utils.LogUtils;

/**
 * Created by admin on 2016/3/29.
 */
public class InjectViewUtils {
    private static final String METHOD_SET_CONTENTVIEW = "setContentView";
    private static final String METHOD_FINDVIEWBYID = "findViewById";

    public static void injectAllView(Activity activity) {
        InjectViewUtils.injectContentView(activity);
        InjectViewUtils.injectView(activity);
    }

    // SetContentView
    public static void injectContentView(Activity activity) {
        Class<?> clazz = activity.getClass();
        while (clazz != null) {
            // 查询类上是否存在ContentView注解
            ContentView contentView = clazz.getAnnotation(ContentView.class);
            if (contentView != null) {// 存在
                // 获得注解中的值
                int contentViewLayoutId = contentView.value();
                try {
                    // 调用setContentView
                    Method method = clazz.getMethod(METHOD_SET_CONTENTVIEW, int.class);
                    method.setAccessible(true);
                    method.invoke(activity, contentViewLayoutId);
                } catch (Exception e) {
                    LogUtils.e(e.toString());
                }
            }
            clazz = clazz.getSuperclass();
        }
    }

    // findViewById
    public static void injectView(Activity activity) {
        Class<?> clazz = activity.getClass();
        while (clazz != null) {
            Field[] fields = clazz.getDeclaredFields();
            for (Field field : fields) {
                ViewInject viewInject = field.getAnnotation(ViewInject.class);
                if (viewInject != null) {
                    int viewId = viewInject.value();
                    try {
                        // 调用findViewById
                        Method method = clazz.getMethod(METHOD_FINDVIEWBYID, int.class);
                        method.setAccessible(true);
                        Object resView = method.invoke(activity, viewId);

                        // 根据返回值设置Field
                        field.setAccessible(true);
                        field.set(activity, resView);
                    } catch (Exception e) {
                        LogUtils.e(e.toString());
                    }
                }
            }
            clazz = clazz.getSuperclass();
        }
    }

    // View.findViewById
    public static void injectViewUseView(Activity activity) {
        Class<? extends Activity> clazz = activity.getClass();
        Field[] fields = clazz.getDeclaredFields();

        for (Field field : fields) {
            ViewInjectUseView viewInject = clazz.getAnnotation(ViewInjectUseView.class);
            if (viewInject != null) {
                int viewId = viewInject.value();
                String parentView = viewInject.parent();
                try {
                    Field parent = clazz.getDeclaredField(parentView);
                    LogUtils.v("injectViewUseView parent Field get");
                    // 调用findViewById
                    Method method = parent.getClass().getMethod(METHOD_FINDVIEWBYID, int.class);
                    method.setAccessible(true);
                    Object resView = method.invoke(parent, viewId);
                    // 根据返回值设置Field
                    field.setAccessible(true);
                    field.set(activity, resView);
                } catch (Exception e) {
                    LogUtils.e(e.toString());
                }
            }
        }
    }

}
