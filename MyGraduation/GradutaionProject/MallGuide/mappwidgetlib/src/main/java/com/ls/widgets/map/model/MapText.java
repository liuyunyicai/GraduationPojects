package com.ls.widgets.map.model;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;

/**
 * Created by admin on 2016/6/18.
 */
// 用以在地图上绘制Text
public class MapText {
    private String Tag;
    private int textId;

    private Point index;
    private String text;
    private Paint mPaint;

    private MapLayer layer;

    public MapText(int textId, Point index, String text) {
        this(textId, index, text, getDefalutPaint());
    }

    public MapText(int textId, Point index, String text, Paint mPaint) {
        this.textId = textId;
        this.index = index;
        this.text = text;
        this.mPaint = mPaint;
    }

    public static Paint getDefalutPaint() {
        Paint mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mPaint.setColor(Color.BLUE);
        mPaint.setStyle(Paint.Style.STROKE);
        mPaint.setStrokeWidth(2);
        return mPaint;
    }

    // 绘制文本
    // 绘制图像
    public void draw(Canvas canvas, float scale) {
        if (index != null) {
            canvas.drawText(text, index.x * scale, index.y * scale, mPaint);
        }
    }

    public Point getIndex() {
        return index;
    }

    public void setIndex(Point index) {
        this.index = index;
    }

    public MapLayer getLayer() {
        return layer;
    }

    public void setLayer(MapLayer layer) {
        this.layer = layer;
    }

    public Paint getmPaint() {
        return mPaint;
    }

    public void setmPaint(Paint mPaint) {
        this.mPaint = mPaint;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getTag() {
        return Tag;
    }

    public void setTag(String tag) {
        Tag = tag;
    }

    public int getTextId() {
        return textId;
    }

    public void setTextId(int textId) {
        this.textId = textId;
    }
}
