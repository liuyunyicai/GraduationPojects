package com.example.neal.testmallguide.loaddata;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.widget.ProgressBar;

import com.example.neal.testmallguide.utils.LogUtils;

/**
 * Created by admin on 2015/11/22.
 */
public class PrecentProgressBar extends ProgressBar {
    private String str = "0%";
    private float mProgress = 0;
    private Paint mPaint;

    public PrecentProgressBar(Context context) {
        super(context);
        initText();
    }

    public PrecentProgressBar(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initText();
    }

    public PrecentProgressBar(Context context, AttributeSet attrs) {
        super(context, attrs);
        initText();
    }

    @Override
    public void setProgress(int progress) {
        setText(progress);
        super.setProgress(progress);
        mProgress = progress;
        postInvalidate();
    }

    @Override
    protected synchronized void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        Rect rect = new Rect();
        mPaint.getTextBounds(str, 0, str.length(), rect);
        int x = (int)((getWidth() / this.getMax()) * mProgress + rect.centerY());// 让现实的字体处于中心位置;
        int y = (getHeight() / 2) - rect.centerY();// 让显示的字体处于中心位置;
        canvas.drawText(str, x, y, mPaint);
    }

    // 初始化，画笔
    private void initText() {
        mPaint = new Paint();
        mPaint.setAntiAlias(true);// 设置抗锯齿;
        mPaint.setColor(Color.YELLOW);
        mPaint.setTextSize(25);

        setWillNotDraw(false);
    }

    // 设置文字内容
    private void setText(int progress) {
        int i = (int) ((progress * 1.0f / this.getMax()) * 100);
        str = String.valueOf(i) + "%";


    }
}
