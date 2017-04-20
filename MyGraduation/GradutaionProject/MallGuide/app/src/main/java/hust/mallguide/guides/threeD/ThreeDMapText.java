package hust.mallguide.guides.threeD;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;

import com.orhanobut.logger.Logger;
import com.threed.jpct.Texture;
import com.threed.jpct.util.BitmapHelper;

/**
 * Created by admin on 2016/6/21.
 */
public class ThreeDMapText {

    public static Bitmap textToBitmap(String text, Paint mPaint) {
        int width, height;
        try {
            Rect textBounds = new Rect();
            mPaint.getTextBounds(text, 0, text.length() - 1, textBounds);
            width = textBounds.width();
            height = textBounds.height();

            int x = 1;
            int y = height / 2 + 6;

            Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);

            canvas.drawText(text, x, y, mPaint);
            canvas.save(Canvas.ALL_SAVE_FLAG);
            canvas.restore();
            return bitmap;
        } catch (Exception e) {
            Logger.i("textToBitmap Error %s", e.toString());
            return null;
        }
    }

    public static Texture getTextTexture(String text) {
        return getTextTexture(text, defaultPaint());
    }

    public static Texture getTextTexture(String text, Paint mPaint) {
        return new Texture(BitmapHelper.rescale(textToBitmap(text, mPaint),
                64, 64), true);
    }

    public static Paint defaultPaint() {
        Paint mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mPaint.setColor(Color.BLUE);
        mPaint.setStyle(Paint.Style.STROKE);
        mPaint.setStrokeWidth(2);
        return mPaint;
    }
}
