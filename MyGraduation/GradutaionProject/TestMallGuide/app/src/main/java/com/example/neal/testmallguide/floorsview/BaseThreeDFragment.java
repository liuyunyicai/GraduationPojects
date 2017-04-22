package com.example.neal.testmallguide.floorsview;

import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import com.example.neal.testmallguide.floorsview.route.RouteInfo;
import com.example.neal.testmallguide.floorsview.zoom.ZoomListenter;
import com.example.neal.testmallguide.loaddata.DataInfo;
import com.example.neal.testmallguide.utils.SharedUtils;
import com.squareup.okhttp.Route;
import com.threed.jpct.Logger;

import java.lang.reflect.Field;
import java.util.List;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLDisplay;

/**
 * Created by neal on 2017/3/15.
 */
public class BaseThreeDFragment extends Fragment{
    public static final String FLOOR_NUM_BUNDLE = "floor_num_bundle"; // 用来楼层传递模型地址数据
    private int mFloorNum;

    // HelloWorld对象用来处理Activity的onPause和onResume方法
    private static MainFloorsActivity master;
    // GLSurfaceView对象
    private GLSurfaceView mGLView;
    // 类MyRenderer对象
    private BuildingRender renderer = null;

    private float xpos = -1;
    private float ypos = -1;

    private RenderZoomListener mZoomListener;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        // 如果本类对象不为NULL,将从Object中所有属性装入该类
        if (master != null) {
            copy(master);
        }
        super.onCreate(savedInstanceState);
        // 实例化GLSurfaceView
        mGLView = new GLSurfaceView(getActivity());
        // 使用自己实现的 EGLConfigChooser,该实现必须在setRenderer(renderer)之前
        // 如果没有setEGLConfigChooser方法被调用，则默认情况下，视图将选择一个与当前android.view.Surface兼容至少16位深度缓冲深度EGLConfig。
        mGLView.setEGLConfigChooser(new GLSurfaceView.EGLConfigChooser() {
            public EGLConfig chooseConfig(EGL10 egl, EGLDisplay display) {
                int[] attributes = new int[]{EGL10.EGL_DEPTH_SIZE, 16,
                        EGL10.EGL_NONE};
                EGLConfig[] configs = new EGLConfig[1];
                int[] result = new int[1];
                egl.eglChooseConfig(display, attributes, configs, 1, result);
                return configs[0];
            }
        });

        Bundle data = getArguments();
        mFloorNum = 1;
        if (null != data) {
            mFloorNum = data.getInt(FLOOR_NUM_BUNDLE);
            if (0 == mFloorNum) {
                mFloorNum = 1;
            }
        }

        // 实例化MyRenderer
        renderer = new BuildingRender(getActivity(), mFloorNum);
        // 设置View的渲染器，同时启动线程调用渲染，以至启动渲染
        mGLView.setRenderer(renderer);

        mZoomListener = new RenderZoomListener();

        return mGLView;
    }



    // 重写onPause()
    @Override
    public void onPause() {
        super.onPause();
        mGLView.onPause();
    }

    // 重写onResume()
    @Override
    public void onResume() {
        super.onResume();
        mGLView.onResume();
    }

    // 重写onStop()
    @Override
    public void onStop() {
        super.onStop();
    }

    private void copy(Object src) {
        try {
            // 打印日志
            Logger.log("Copying data from master Activity!");
            // 返回一个数组，其中包含目前这个类的的所有字段的Filed对象
            Field[] fs = src.getClass().getDeclaredFields();
            // 遍历fs数组
            for (Field f : fs) {
                // 尝试设置无障碍标志的值。标志设置为false将使访问检查，设置为true，将其禁用。
                f.setAccessible(true);
                // 将取到的值全部装入当前类中
                f.set(this, f.get(src));
            }
        } catch (Exception e) {
            // 抛出运行时异常
            throw new RuntimeException(e);
        }
    }

    public boolean onTouchEvent(MotionEvent me) {
//        // 按键开始
//        if (me.getAction() == MotionEvent.ACTION_DOWN) {
//            // 保存按下的初始x,y位置于xpos,ypos中
//            xpos = me.getX();
//            ypos = me.getY();
//            return true;
//        }
//        // 按键结束
//        if (me.getAction() == MotionEvent.ACTION_UP) {
//            // 设置x,y及旋转角度为初始值
//            xpos = -1;
//            ypos = -1;
//            renderer.touch_x = 0;
//            renderer.touch_y = 0;
//            return true;
//        }
//        if (me.getAction() == MotionEvent.ACTION_MOVE) {
//            // 计算x,y偏移位置及x,y轴上的旋转角度
//            float xd = me.getX() - xpos;
//            float yd = me.getY() - ypos;
//            xpos = me.getX();
//            ypos = me.getY();
//            // 以x轴为例，鼠标从左向右拉为正，从右向左拉为负
//            renderer.touch_x = xd / 3f;
//            renderer.touch_y = yd / 3f;
//            return true;
//        }
//        // 每Move一下休眠毫秒
//        try {
//            Thread.sleep(15);
//        } catch (Exception e) {
//            // No need for this...
//        }
//        return false;


        return mZoomListener.onTouch(mGLView, me);
    }

    /*
    * 划线
    **/
    public void drawLine(List<RouteInfo> routeInfos) {
        if (null != routeInfos) {
            renderer.drawRoute(routeInfos);
        }
    }

    /*
    * 划区域
    **/
    public void drawZone(List<RouteInfo> zoneInfos, int type) {
        if (null != zoneInfos) {
            renderer.drawZone(zoneInfos, type);
        }
    }

    /*
    * 用以缩放的类
    **/
    private class RenderZoomListener extends ZoomListenter {
        private static final float param = 3f;

        @Override
        public boolean onTouch(View v, MotionEvent event) {
            return super.onTouch(v, event);
        }

        @Override
        protected void zoom(float f) {
            super.zoom(f);
            renderer.setScale(f);
        }

        @Override
        protected void drag(float x, float y) {
            super.drag(x, y);
            renderer.setTranslate(x / param, y / param);
        }
    }

}
