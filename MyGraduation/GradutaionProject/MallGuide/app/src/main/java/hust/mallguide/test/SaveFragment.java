package hust.mallguide.test;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.widget.LinearLayout;

import java.util.WeakHashMap;

/**
 * Created by admin on 2016/4/7.
 */
public class SaveFragment extends Fragment {
    private WeakHashMap<String, Bitmap> cache = new WeakHashMap<>();

    private String savedString;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRetainInstance(true);
    }

    public void addBitmapCache(String url, Bitmap bitmap) {
        cache.put(url, bitmap);
    }

    public Bitmap getCachedBitmap(String url) {
        return cache.get(url);
    }

    public void saveString(String savedString) {
        this.savedString = savedString;
    }

    public String getSavedString() {
        return savedString;
    }
}
