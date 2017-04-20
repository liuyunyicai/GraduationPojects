package hust.mallguide.utils;

import android.os.Environment;

import java.io.File;

/**
 * Created by admin on 2016/4/5.
 */
public class FileUtils {

    public static final String PATH_NAME = "MallGuide";

    public static File getSdFile(String file_name) {
        File file = null;
        if (isSdMounted()) {
            file = new File(getDefSdPath(), file_name);
        }
        return file;
    }

    // 返回默认的SD卡的目录
    public static String getDefSdPath() {
        String default_path = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + PATH_NAME;
        File file = new File(default_path);
        if (!file.exists())
            file.mkdirs();
        return default_path;
    }

    // 判断SD卡是否可用
    public static boolean isSdMounted() {
        return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
    }

}
