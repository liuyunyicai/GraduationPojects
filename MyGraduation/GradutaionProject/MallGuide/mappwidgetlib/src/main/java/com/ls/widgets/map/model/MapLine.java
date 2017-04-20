package com.ls.widgets.map.model;

/**
 * Created by admin on 2016/6/5.
 */

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;

import java.util.ArrayList;
import java.util.List;

/** 地图上的连线 */
public class MapLine {
    private String Tag; // Line的标记
    private int lineId; // Line标记
    // 记录线段路径
    private Paint mPaint; // 用来记录绘制该线段的Paint
    private MapLayer layer;

    private List<Point> nodes;

    public MapLine(int lineId, float startX, float startY, float endX, float endY) {
        this.lineId = lineId;
        nodes = new ArrayList<>();
        nodes.add(new Point((int)startX, (int) startY));
        nodes.add(new Point((int)endX, (int) endY));
        this.mPaint = getDefalutPaint();
    }

    public MapLine(int lineId, List<Point> nodes) {
        this(lineId, nodes, getDefalutPaint());
    }

    public MapLine(int lineId, List<Point> nodes, Paint mPaint) {
        this.lineId = lineId;
        this.nodes = nodes;
        this.mPaint = mPaint;
    }

    public static Paint getDefalutPaint() {
        Paint mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mPaint.setColor(Color.RED);
        mPaint.setStyle(Paint.Style.STROKE);
        mPaint.setStrokeWidth(4);
        return mPaint;
    }

    // 绘制图像
    public void draw(Canvas canvas, float scale) {
        if ((nodes != null) && (nodes.size() >= 2)) {
            Path path = new Path();

            int count = 0;
            for (Point node : nodes) {
                if (count == 0) {
                    path.moveTo(node.x * scale, node.y * scale);
                } else {
                    path.lineTo(node.x * scale, node.y * scale);
                }
                count++;
            }
            canvas.drawPath(path, mPaint);
        }
    }

    public int getLineId() {
        return lineId;
    }

    public void setLineId(int lineId) {
        this.lineId = lineId;
    }

    public Paint getmPaint() {
        return mPaint;
    }

    public void setmPaint(Paint mPaint) {
        this.mPaint = mPaint;
    }

    public List<Point> getNodes() {
        return nodes;
    }

    public void setNodes(List<Point> nodes) {
        this.nodes = nodes;
    }

    public String getTag() {
        return Tag;
    }

    public void setTag(String tag) {
        Tag = tag;
    }

    public MapLayer getLayer() {
        return layer;
    }

    public void setLayer(MapLayer layer) {
        this.layer = layer;
    }
}
