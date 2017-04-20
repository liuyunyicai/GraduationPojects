package hust.mallguide.httputils.image;

import android.content.Context;
import android.graphics.Bitmap;
import android.support.v4.util.LruCache;
import android.widget.ImageView;

import com.android.volley.toolbox.ImageLoader;

import hust.mallguide.R;
import hust.mallguide.httputils.HttpUtils;


/**
 * Created by admin on 2016/2/29.
 */
public class ImageUtils {
    private LruCache<String, Bitmap> mImageLruCache;
    private ImageLoader.ImageCache imageCache;
    private ImageLoader imageLoader;
    private ImageLoader.ImageListener imageListener;
    private int MAX_CACHE_SIZE; // 最大内存缓存大小(KB)
    private static ImageUtils instance;
    private HttpUtils httpUtils;

    public static ImageUtils build(Context context) {
        if (instance == null) {
            instance = new ImageUtils(context);
        }
        return instance;
    }


    private ImageUtils(Context context) {
        httpUtils = HttpUtils.build(context);
        // 获取最大内存缓存大小
        int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);
        MAX_CACHE_SIZE = maxMemory / 8; // 定义为应用最大缓存的1/8

        mImageLruCache = new LruCache<String, Bitmap>(MAX_CACHE_SIZE){
            @Override
            protected int sizeOf(String url, Bitmap bitmap){
                return bitmap.getRowBytes() * bitmap.getHeight() / 1024;
            }
        };

        // 创建ImageCache
        imageCache = new ImageLoader.ImageCache() {
            @Override
            public void putBitmap(String url, Bitmap bitmap) {
                mImageLruCache.put(url, bitmap);
            }

            @Override
            public Bitmap getBitmap(String url) {
                return mImageLruCache.get(url);
            }
        };

        //创建ImageLoader
        imageLoader = new ImageLoader(httpUtils.getRequestQueue(), imageCache);

    }

    // 图片加载方法
    // 不设置压缩
    public void loadImage(final String imageUrl, final ImageView myImageView) {
        loadImage(imageUrl, myImageView, R.mipmap.error_default, R.mipmap.error_default);
    }

    public void loadImage(final String imageUrl, final ImageView myImageView, int default_pg, int failed_pg) {
        imageListener = ImageLoader.getImageListener(myImageView, default_pg, failed_pg);
        imageLoader.get(imageUrl, imageListener);
    }

    // 对下面的图片进行压缩
    public void loadImageInSize(final String imageUrl, final ImageView myImageView, int req_height, int req_width) {
        loadImageInSize(imageUrl, myImageView, req_height, req_width, R.mipmap.error_default, R.mipmap.error_default);
    }

    public void loadImageInSize(final String imageUrl, final ImageView myImageView, int req_height, int req_width,
                                int default_pg, int failed_pg) {
        imageListener = ImageLoader.getImageListener(myImageView, default_pg, failed_pg);
        //如果想对加载图片大小进行限定，使用get()的另一个重载方式
        imageLoader.get(imageUrl, imageListener, req_height, req_width);
    }
}
