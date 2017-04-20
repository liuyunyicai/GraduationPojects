package hust.mallguide.guides.threeD;

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.Window;

import com.threed.jpct.Logger;

import java.lang.reflect.Field;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLDisplay;

/**
 * Created by admin on 2016/6/18.
 */
public class ThreeDViewActivity extends Activity {
    // HelloWorld对象用来处理Activity的onPause和onResume方法
    private static ThreeDViewActivity master;
    // GLSurfaceView对象
    private GLSurfaceView mGLView;
    // 类MyRenderer对象
    private MyRender2 renderer = null;

    private float xpos = -1;
    private float ypos = -1;
    protected void onCreate(Bundle savedInstanceState) {
        // Logger类中 jPCT中一个普通的用于打印和存储消息，错误和警告的日志类。 每一个JPCT生成的消息将被加入到这个类的队列中
        Logger.log("onCreate");
        requestWindowFeature(Window.FEATURE_NO_TITLE);

        // 如果本类对象不为NULL,将从Object中所有属性装入该类
        if (master != null) {
            copy(master);
        }
        super.onCreate(savedInstanceState);
        // 实例化GLSurfaceView
        mGLView = new GLSurfaceView(this);
        // 使用自己实现的 EGLConfigChooser,该实现必须在setRenderer(renderer)之前
        // 如果没有setEGLConfigChooser方法被调用，则默认情况下，视图将选择一个与当前android.view.Surface兼容至少16位深度缓冲深度EGLConfig。
        mGLView.setEGLConfigChooser(new GLSurfaceView.EGLConfigChooser() {
            public EGLConfig chooseConfig(EGL10 egl, EGLDisplay display) {
                // Ensure that we get a 16bit framebuffer. Otherwise, we'll fall
                // back to Pixelflinger on some device (read: Samsung I7500)
                int[] attributes = new int[] { EGL10.EGL_DEPTH_SIZE, 16,
                        EGL10.EGL_NONE };
                EGLConfig[] configs = new EGLConfig[1];
                int[] result = new int[1];
                egl.eglChooseConfig(display, attributes, configs, 1, result);
                return configs[0];
            }
        });
        // 实例化MyRenderer
        renderer = new MyRender2(this);
        // 设置View的渲染器，同时启动线程调用渲染，以至启动渲染
        mGLView.setRenderer(renderer);
        // 设置一个明确的视图
        setContentView(mGLView);
    }

    // 重写onPause()
    @Override
    protected void onPause() {
        super.onPause();
        mGLView.onPause();
    }

    // 重写onResume()
    @Override
    protected void onResume() {
        super.onResume();
        mGLView.onResume();
    }

    // 重写onStop()
    @Override
    protected void onStop() {
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
        // 按键开始
        if (me.getAction() == MotionEvent.ACTION_DOWN) {
            // 保存按下的初始x,y位置于xpos,ypos中
            xpos = me.getX();
            ypos = me.getY();
            return true;
        }
        // 按键结束
        if (me.getAction() == MotionEvent.ACTION_UP) {
            // 设置x,y及旋转角度为初始值
            xpos = -1;
            ypos = -1;
            renderer.touchTurn = 0;
            renderer.touchTurnUp = 0;
            return true;
        }
        if (me.getAction() == MotionEvent.ACTION_MOVE) {
            // 计算x,y偏移位置及x,y轴上的旋转角度
            float xd = me.getX() - xpos;
            float yd = me.getY() - ypos;
            xpos = me.getX();
            // 以x轴为例，鼠标从左向右拉为正，从右向左拉为负
            renderer.touchTurn = xd / -300f;
//            renderer.touchTurnUp = yd / -300f;
            return true;
        }
        // 每Move一下休眠毫秒
        try {
            Thread.sleep(15);
        } catch (Exception e) {
            // No need for this...
        }
        return super.onTouchEvent(me);
    }



}
