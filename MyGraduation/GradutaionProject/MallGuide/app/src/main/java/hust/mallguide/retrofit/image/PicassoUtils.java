package hust.mallguide.retrofit.image;

import android.content.Context;
import android.widget.ImageView;

import com.squareup.picasso.Picasso;

import hust.mallguide.utils.LogUtils;
import hust.mallguide.retrofit.OkHttpUtils;

/**
 * Created by admin on 2016/4/26.
 */
public class PicassoUtils {
    private static final String IMAGE_PATH_PREX = "pictures/";

    private volatile static PicassoUtils picassoUtils;
    private Picasso picasso;

    private PicassoUtils(Context context) {
        picasso = Picasso.with(context);
    }

    public static PicassoUtils getInstance(Context context) {
        if (picassoUtils == null) {
            synchronized (PicassoUtils.class) {
                if (picassoUtils == null) {
                    picassoUtils = new PicassoUtils(context);
                }
            }
        }
        return picassoUtils;
    }

    public void loadImage(String url, final ImageView imageView) {
        picasso.load(getAbsolutePath(url)).into(imageView);

        LogUtils.w(getAbsolutePath(url));
    }

    public void loadImage(String url, String uniquePath, final ImageView imageView) {
        picasso.load(getUniqueAbsPath(url, uniquePath)).into(imageView);

        LogUtils.w(getUniqueAbsPath(url, uniquePath));
    }

    public Picasso picasso() {
        return picasso;
    }

    // 获取图片路径
    public String getAbsolutePath(String url) {
        return OkHttpUtils.BASE_URL + IMAGE_PATH_PREX + url;
    }

    // 获取指定目录下的图片路径
    public String getUniqueAbsPath(String url, String uniquePath) {
        return getAbsolutePath(uniquePath + "/" + url);
    }
}
