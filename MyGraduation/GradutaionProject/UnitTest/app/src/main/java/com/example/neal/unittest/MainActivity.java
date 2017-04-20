package com.example.neal.unittest;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.widget.RelativeLayout;

public class MainActivity extends AppCompatActivity implements View.OnTouchListener{
    public static final String LOG_TAG = "LOG_TAG";
    private final static int ZOOM = 2;            // 双指缩放
    private final static int TRANSLATE = 1;       // 平移
    int type = 0;
    float oldSpace = 0.0f;
    private static final float TOUCH_SLOP = 1;
    RelativeLayout mainView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mainView = (RelativeLayout) findViewById(R.id.mainLayout);
        mainView.setOnTouchListener(this);
    }


    @Override
    public boolean onTouch(View v, MotionEvent event) {

        switch (event.getAction() & MotionEvent.ACTION_MASK) {
            case MotionEvent.ACTION_DOWN:
                type = TRANSLATE;
                Log.i(LOG_TAG, "ACTION_DOWN");
                break;
            case MotionEvent.ACTION_UP:
                Log.i(LOG_TAG, "ACTION_UP");
                type = 0;
                break;
            case MotionEvent.ACTION_POINTER_DOWN: // 多点触控
                type = ZOOM;
                // 记录初始按下时两点之间的距离
                oldSpace = spacing(event);
                Log.i(LOG_TAG, "ACTION_POINTER_DOWN");
                break;
            case MotionEvent.ACTION_MOVE:
                Log.i(LOG_TAG, "ACTION_MOVE");
                if (type == ZOOM) {
                    float newSpace = spacing(event);
                    if (Math.abs(newSpace - oldSpace) > TOUCH_SLOP) {
                        zoom(newSpace / oldSpace);
                    }
                }
                break;
        }

        return false;
    }

    private void zoom(float f) {
        Log.i(MainActivity.LOG_TAG, "缩放比例：" + f);
    }

    private float spacing(MotionEvent event) {
        float x = event.getX(0) - event.getX(1);
        float y = event.getY(0) - event.getY(1);
        return (float) Math.sqrt(x * x + y * y);
    }
}
