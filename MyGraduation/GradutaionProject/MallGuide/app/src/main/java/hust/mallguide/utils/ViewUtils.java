package hust.mallguide.utils;

import android.widget.EditText;

/**
 * Created by admin on 2016/5/31.
 */
public class ViewUtils {

    // 判断EditText的内容是否为空
    public static boolean isEditTxEmpty(EditText editText) {
        if ((editText != null) && (!getEditTxContent(editText).equals("")))
            return false;
        return true;
    }

    // 获取EditText的文本内容
    public static String getEditTxContent(EditText editText) {
        if (editText != null)
            return editText.getText().toString().trim();
        return null;
    }
}
