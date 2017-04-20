package hust.mallguide.guides.threeD;

import android.annotation.SuppressLint;
import android.content.Context;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;

import com.threed.jpct.Camera;
import com.threed.jpct.FrameBuffer;
import com.threed.jpct.Light;
import com.threed.jpct.Loader;
import com.threed.jpct.Matrix;
import com.threed.jpct.Object3D;
import com.threed.jpct.Primitives;
import com.threed.jpct.RGBColor;
import com.threed.jpct.SimpleVector;
import com.threed.jpct.Texture;
import com.threed.jpct.TextureManager;
import com.threed.jpct.World;
import com.threed.jpct.util.MemoryHelper;

import java.io.IOException;
import java.io.InputStream;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

@SuppressLint("NewApi")
public class MyRender2 implements GLSurfaceView.Renderer {
    private long time = System.nanoTime();
    private FrameBuffer fb = null;
    private Light sun = null;
    private Object3D cube = null;
    private World world = null;
    private int fps = 0;
    private Object3D rockModel;
    private Object3D chongLou;
    private Object3D mdModel;
    private Context mContext;
    public float touchTurn = 0;
    public float touchTurnUp = 0;
    // 行走动画
    private int an = 2;
    private float ind = 0;

    public MyRender2(Context c) {
        mContext = c;
    }

    public void onSurfaceChanged(GL10 gl, int w, int h) {
        if (fb != null) {
            fb.dispose();
        }
        fb = new FrameBuffer(gl, w, h);
        GLES20.glViewport(0, 0, w, h);
    }

    public void onSurfaceCreated(GL10 gl, EGLConfig config) {
        gl.glClearColor(0.0f, 0.0f, 0.0f, 0.5f); //
        world = new World();
        world.setAmbientLight(150, 150, 150);
//        Texture texture = new
//                Texture(BitmapHelper.rescale(BitmapHelper.convert(mContext.getResources().getDrawable(R.drawable.rock)),
//                64, 64));
//        TextureManager.getInstance().addTexture("texture", texture);
        cube = Primitives.getCube(10);
        cube.calcTextureWrapSpherical();
//        cube.setTexture("texture");
        cube.strip();
        cube.build();
//        rockModel = loadModel("indoor1.3DS", 0.01f);
        rockModel = loadModel("test.3ds", 1f);
//        rockModel.setTexture("texture");
        rockModel.strip(); // 清除多余内存
        rockModel.build(); // 进行初始化构建
        rockModel.translate(0, 5, 0);

        world.addObject(rockModel);
        sun = new Light(world);
        sun.setIntensity(250, 250, 250);
        // 设置视图显示位置
        Camera cam = world.getCamera();
        cam.moveCamera(Camera.CAMERA_MOVEOUT, 10);
        SimpleVector pos = cube.getTransformedCenter();
        pos.x += 10;
        pos.y -= 5;
        cam.lookAt(pos);

        // 设置光源位置
        SimpleVector sv = new SimpleVector();
        sv.set(cube.getTransformedCenter()); // getTransformedCenter获取当前Object3D的中心
        sv.y -= 100;
        sv.z -= 100;
        sun.setPosition(sv);
        MemoryHelper.compact(); // 用以管理内存

        // 测试添加文本
//        testAddText();
    }

    private void testAddText() {
        Texture text1 = ThreeDMapText.getTextTexture("网络计算中心");
        TextureManager.getInstance().addTexture("text1", text1);
        Object3D cube = Primitives.getCube(10);
        cube.calcTextureWrapSpherical();
        cube.setTexture("text1");
        cube.strip();
        cube.build();
        world.addObject(cube);
    }


    public void onDrawFrame(GL10 gl) {
        // Clears the screen and depth buffer.
        gl.glClear(GL10.GL_COLOR_BUFFER_BIT | // OpenGL docs.
                GL10.GL_DEPTH_BUFFER_BIT);
//        doAnim();
        fb.clear(RGBColor.BLACK);
        world.renderScene(fb);
        world.draw(fb);
        fb.display();
        if (touchTurn != 0) {
            rockModel.rotateY(touchTurn);
            touchTurn = 0;
        }
        if (touchTurnUp != 0) {
            rockModel.rotateX(touchTurnUp);
            touchTurnUp = 0;
        }
        if (System.nanoTime() - time >= 1000000000) {
            fps = 0;
            time = System.nanoTime();
        }
        //
        fps++;
    }

    public static int loadShader(int type, String shaderCode) {
        int shader = GLES20.glCreateShader(type);
        GLES20.glShaderSource(shader, shaderCode);
        GLES20.glCompileShader(shader);
        return shader;
    }

    public Object3D loadModel(String filename, float scale) {
        InputStream is = null;
        try {
            is = mContext.getAssets().open(filename);
        } catch (IOException e) {
            e.printStackTrace();
        }
        Object3D[] model = Loader.load3DS(is, scale);
        Object3D o3d = new Object3D(0);
        Object3D temp;
        for (int i = 0; i < model.length; i++) {
            temp = model[i];
            temp.setCenter(SimpleVector.ORIGIN);
            temp.rotateX((float) (-.5 * Math.PI));
            temp.rotateMesh();
            temp.setRotationMatrix(new Matrix());
            o3d = Object3D.mergeObjects(o3d, temp);
            o3d.build();
        }
        return o3d;
    }

    public Object3D loadMdModel(String filename, float scale) {
        InputStream is = null;
        try {
            is = mContext.getAssets().open(filename);
        } catch (IOException e) {
            e.printStackTrace();
        }
        Object3D model = Loader.loadMD2(is, scale);
        return model;
    }

    public void doAnim() {
        ind += 0.018f;
        if (ind > 1f) {
            ind -= 1f;
        }
        mdModel.animate(ind, an);
    }

    public void setTouchTurn(float count) {
        touchTurn = count;
    }

    public void setTouchTurnUp(float count) {
        touchTurnUp = count;
    }
}
