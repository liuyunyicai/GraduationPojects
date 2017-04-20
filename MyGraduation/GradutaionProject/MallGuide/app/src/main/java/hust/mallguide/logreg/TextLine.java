package hust.mallguide.logreg;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import hust.mallguide.R;

/**
 * Created by admin on 2016/3/24.
 */
public class TextLine extends View {
    private float line_height; // 线的高度
    private float mid_width;   // 中间折现的宽度
    private float mid_height;  // 中间折线的高度
    private String mid_text;   // 中间的文本
    private int line_color;    // 线的颜色
    private int text_color;    // 文本的颜色
    private float text_size;   // 文本的size

    // 默认值
    private static final float  DEFAUT_LINE_HEIGHT = 5.0f;
    private static final float  DEFAUT_MID_WIDTH  = 5.0f;
    private static final float  DEFAUT_MID_HEIGHT = 50.0f;
    private static final float  DEFAUT_TEXT_SIZE = 10.0f;
    private static final String DEFAUT_MID_TEXT   = "";
    private static final int    DEFAUT_LINE_COLOR = Color.BLUE;
    private static final int    DEFAUT_TEXT_COLOR = Color.BLUE;

    private static final float DEFAULT_TEXT_EXTRA = 30.0f;

    private Paint mPaint;
    private Rect textRect;

    public TextLine(Context context) {
        super(context);
    }

    public TextLine(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public TextLine(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        TypedArray tp = context.obtainStyledAttributes(attrs, R.styleable.TextLine);
        line_height = tp.getDimension(R.styleable.TextLine_line_height, DEFAUT_LINE_HEIGHT);
        mid_width   = tp.getDimension(R.styleable.TextLine_mid_width, DEFAUT_MID_WIDTH);
        mid_height  = tp.getDimension(R.styleable.TextLine_mid_height, DEFAUT_MID_HEIGHT);
        text_size  = tp.getDimension(R.styleable.TextLine_text_size, DEFAUT_TEXT_SIZE);
        mid_text    = tp.getString(R.styleable.TextLine_mid_text);
        line_color  = tp.getColor(R.styleable.TextLine_line_color, DEFAUT_LINE_COLOR);
        text_color  = tp.getColor(R.styleable.TextLine_text_color, DEFAUT_TEXT_COLOR);
        tp.recycle();

        mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mPaint.setColor(line_color);
        mPaint.setStrokeWidth(line_height); // 设置线宽

        // 获取文本的宽高
        mPaint.setTextSize(text_size);
        textRect = new Rect();
        mPaint.getTextBounds(mid_text, 0, mid_text.length(), textRect);

        mid_width = Math.max(mid_width, textRect.width() + DEFAULT_TEXT_EXTRA);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

        mid_height = Math.max(mid_height, textRect.height());
        setMeasuredDimension(widthMeasureSpec, (int) mid_height);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        int width = getWidth();
        mPaint.setColor(line_color);
        mPaint.setStrokeWidth(line_height);

        float line_y = mid_height / 2;
        canvas.drawLine(0, line_y, (width - mid_width) / 2, line_y, mPaint);
        canvas.drawLine((width + mid_width) / 2, line_y, width, line_y, mPaint);

        mPaint.setColor(text_color);
        mPaint.setTextSize(text_size);

        canvas.drawText(mid_text, (width - textRect.width()) / 2, line_y + textRect.height() / 2, mPaint);
    }
}
