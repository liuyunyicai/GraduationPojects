package com.example.neal.testmallguide.floorsview.zoom;

import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.widget.TextView;

/*
* 供双指缩放，单指拖动的ZoomListener
**/
public class ZoomListenter implements OnTouchListener {

    private static final int DEFAULT_MODE = 0; // 初始化状态
    private static final int DRAG_MODE = 1; // 平移模式
    private static final int SCALE_MODE = 2; // 缩放模式


    private int mMode = DEFAULT_MODE;
    private int mFigureNum = 0;
    float oldDist;


    private int mLastX;
    private int mLastY;



    @Override
    public boolean onTouch(View v, MotionEvent event) {
        int x = (int) event.getRawX();
        int y = (int) event.getRawY();

        switch (event.getAction() & MotionEvent.ACTION_MASK) {
            case MotionEvent.ACTION_DOWN:
                mMode = DRAG_MODE;
                mFigureNum = 1;
                break;
            case MotionEvent.ACTION_UP:
                mMode = DEFAULT_MODE;
                mFigureNum = 0;
                break;
            case MotionEvent.ACTION_POINTER_UP:
                mMode = SCALE_MODE;
                mFigureNum -= 1;
                break;
            case MotionEvent.ACTION_POINTER_DOWN:
                oldDist = spacing(event);
                mMode = SCALE_MODE;
                mFigureNum += 1;
                break;

            case MotionEvent.ACTION_MOVE:
                if ((mMode == SCALE_MODE) && (mFigureNum >= 2)) {
                    float newDist = spacing(event);
                    if (newDist > oldDist + 1) {
                        zoom(newDist / oldDist);
                        oldDist = newDist;
                    }
                    if (newDist < oldDist - 1) {
                        zoom(newDist / oldDist);
                        oldDist = newDist;
                    }
                }

                if ((mMode == DRAG_MODE) && (mFigureNum == 1)){
                    int deltaX = x - mLastX;
                    int deltaY = y - mLastY;

                    drag(deltaX, deltaY);
                }
                break;
        }

        mLastX = x;
        mLastY = y;
        return true;
    }

    /*
    * 进行缩放操作
    * 可Override
    **/
    protected void zoom(float f) {
    }

    /*
    * 拖动操作
    * 可Override
    **/
    protected void drag(float x, float y) {
    }



    /*
    * 计算两指之间的距离
    **/
    private float spacing(MotionEvent event) {
        float x = event.getX(0) - event.getX(1);
        float y = event.getY(0) - event.getY(1);
        return (float) Math.sqrt(x * x + y * y);
    }

}
