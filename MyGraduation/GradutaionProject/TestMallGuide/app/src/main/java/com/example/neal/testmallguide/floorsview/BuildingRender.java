package com.example.neal.testmallguide.floorsview;

import android.content.Context;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;

import com.example.neal.testmallguide.R;
import com.example.neal.testmallguide.floorsview.route.RouteInfo;
import com.example.neal.testmallguide.loaddata.DataInfo;
import com.example.neal.testmallguide.utils.LogUtils;
import com.example.neal.testmallguide.utils.SharedUtils;
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
import com.threed.jpct.util.BitmapHelper;
import com.threed.jpct.util.MemoryHelper;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

/**
 * Created by neal on 2016/11/30.
 * <p>
 * 构建三维模型，JPCT-AE中的Render
 */
public class BuildingRender implements GLSurfaceView.Renderer {
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
    public float touch_x = 0;
    public float touch_y = 0;

    // 行走动画
    private int an = 2;
    private float ind = 0;

    public static final String DEFAULT_MODEL_PATH = "Floor";
    public static final String DEFAULT_MODEL_TYPE = ".3DS";

    private String mModelPath; // 楼层三维模型名称
    private int mFloorNum;     // 第几楼层

    // 加载静态资源
    public static final int TYPE_ROUTE  = 0;
    public static final int TYPE_FIRE   = 1;
    public static final int TYPE_DANGER = 2;
    public static final int TYPE_CROWED = 3;

    private String red_texture= "red";
    private String blue_texture= "blue";
    private String crowded_texture = "crowded";
    private String yellow_texture = "yellow";

    private TextureManager mTextureManager;

    private SimpleVector mOriginVector; // 中心位置
    private float mScale = 0.0115f; // 缩放比例
    private float mTranslateScale = mScale * 40; // 缩放比例
    private float mRotateX = -75; // 旋转角度
    // 用以存储当前world中的所有Objects
    private List<Object3D> objects = new ArrayList<>();

    private static final int X_BASE = -123;
    private static final int Y_BASE = -39;

    SimpleVector worldCenter;


    public BuildingRender(Context c) {
        this(c, 1);
    }

    public BuildingRender(Context c, int mFloorNum) {
        mContext = c;
        this.mFloorNum = mFloorNum;

        this.mModelPath = DEFAULT_MODEL_PATH + mFloorNum + DEFAULT_MODEL_TYPE;

        // 添加纹理
        mTextureManager = TextureManager.getInstance();

        addTexture(red_texture, R.drawable.red_txu);
        addTexture(blue_texture, R.drawable.blue_txu);
        addTexture(crowded_texture, R.drawable.crowed_txu);
        addTexture(yellow_texture, R.drawable.yellow_txu);
    }
    /*
    * 添加texture纹理
    **/
    private void addTexture(String texture, int txu_id) {
        if ((null != mTextureManager) && (-1 == mTextureManager.getTextureID(texture))) {
            mTextureManager.addTexture(texture, new Texture(BitmapHelper.rescale(BitmapHelper.convert(mContext.getResources().getDrawable(txu_id)), 64, 64)));
        }
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
        init();

        // 测试添加文本
//        testAddText();
    }

    /*
     * 初始化设置
     **/
    public void init() {
        world = new World();
        world.setAmbientLight(150, 150, 150);

        mRotateX = (float)((mRotateX / 180) * Math.PI);
        LogUtils.i("mRotateX = " + mRotateX);

        rockModel = loadModel(mModelPath, mScale);
        rockModel.strip(); // 清除多余内存
        rockModel.build(); // 进行初始化构建
        rockModel.rotateX(mRotateX);
        mOriginVector = rockModel.getOrigin();
        world.addObject(rockModel);
//        addObject(rockModel);

//        worldCenter = rockModel.getCenter();
//        LogUtils.i("center(" + worldCenter.x + "," + worldCenter.y + "," + worldCenter.z + ")");

        // 设置灯光
        sun = new Light(world);
        sun.setIntensity(250, 250, 250);
        // 设置视图显示位置
        Camera cam = world.getCamera();
        cam.moveCamera(Camera.CAMERA_MOVEOUT, 100);
        SimpleVector pos = rockModel.getOrigin();
        cam.lookAt(pos);

        // 设置光源位置
        SimpleVector sv = new SimpleVector();
        sv.set(rockModel.getOrigin()); // getTransformedCenter获取当前Object3D的中心
        sun.setPosition(sv);
        MemoryHelper.compact(); // 用以管理内存

        drawFiredLines();
    }

    /*
    * 绘制火灾相关曲线
    * */
    private void drawFiredLines() {
        if (SharedUtils.getSharedUtils(mContext).getBoolean(SharedUtils.ISFIRED)) { // 发生火灾时
            DataInfo dataInfo = DataInfo.getInstance();

            List<RouteInfo> routeInfos = dataInfo.getRouteInfos();
            List<RouteInfo> crowdedInfos = dataInfo.getCrowdedInfos();
            List<RouteInfo> dangerInfos = dataInfo.getDangerInfos();
            List<RouteInfo> fireInfos = dataInfo.getFireInfos();


            if (null != routeInfos) {
                drawRoute(routeInfos);
            }

            if (null != crowdedInfos) {
                drawZone(crowdedInfos, BuildingRender.TYPE_CROWED);
            }

            if (null != dangerInfos) {
                drawZone(dangerInfos, BuildingRender.TYPE_DANGER);
            }

            if (null != fireInfos) {
                drawZone(fireInfos, BuildingRender.TYPE_FIRE);
            }
        }
    }

    /*
    * 添加Objects
    * */
    private void addObject(Object3D object) {
        if ((null != object) && (null != objects)) {
            objects.add(object);
            world.addObject(object);
        }
    }

    /*
    * 获取偏离中心位置的点坐标
    **/
    private SimpleVector getPoint(float detaX, float detaY, float detaZ) {
        SimpleVector vector = new SimpleVector(mOriginVector);
        vector.x += ((detaX + X_BASE - 1) * mTranslateScale);
        vector.y += ((detaZ + Y_BASE + 0.5) * mTranslateScale * Math.sin(mRotateX));
        vector.z += ((detaZ + Y_BASE + 0.5) * mTranslateScale * Math.cos(mRotateX));
        return vector;
    }

    /*
    * 设置文本
    **/
    private void testAddText() {
//        Texture text1 = ThreeDMapText.getTextTexture("网络计算中心");
//        TextureManager.getInstance().addTexture("text1", text1);
        Object3D cube = Primitives.getCube(10);
        cube.calcTextureWrapSpherical();
        cube.setTexture("text1");
        cube.strip();
        cube.build();
        world.addObject(cube);
    }


    /*
    * 重绘每一帧
    **/
    public void onDrawFrame(GL10 gl) {
        // Clears the screen and depth buffer.
        gl.glClear(GL10.GL_COLOR_BUFFER_BIT | // OpenGL docs.
                GL10.GL_DEPTH_BUFFER_BIT);
//        doAnim();
        fb.clear(RGBColor.BLACK);
        world.renderScene(fb);
        world.draw(fb);
        fb.display();

        // 对滑动的响应
        if ((touch_x != 0)||(touch_y != 0)) {
            rockModel.translate(touch_x, touch_y, 0);

            for (Object3D object : objects) {
                object.translate(touch_x, touch_y, 0);
            }
            touch_x = 0;
            touch_y = 0;
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


    /*
    * 划出疏散路径
    **/
    public void drawRoute(List<RouteInfo> routeInfos) {
        drawLine(routeInfos, blue_texture);
    }

    /*
    * 画出火灾危险区域
    **/
    public void drawZone(List<RouteInfo> zoneInfos, int type) {
        String texture = red_texture;
        switch (type) {
            case TYPE_FIRE:
                texture = red_texture;
                break;
            case TYPE_CROWED:
                texture = crowded_texture;
                break;
            case TYPE_DANGER:
                texture = yellow_texture;
                break;
        }
        drawLine(zoneInfos, texture);
    }

    /*
    * 划线基本： drawLine
    **/
    public void drawLine(List<RouteInfo> routeInfos, String texture) {
        for (RouteInfo routeInfo : routeInfos) {
            if (routeInfo.getGrid_z() == (mFloorNum * 2 -1)) {
                Object3D cube = loadModel("route.3DS", mScale);
                cube.strip();
                cube.build();
                cube.calcTextureWrapSpherical();
                cube.setTexture(texture);
//            cube.setCenter(mOriginVector);
                SimpleVector cubeCenter = getPoint(routeInfo.getGrid_x(), 0, (float)(routeInfo.getGrid_y()));
                cube.setCenter(cubeCenter);
                cube.setOrigin(cubeCenter);
                

//                LogUtils.i("Floor" +mFloorNum + ":(" + cubeCenter.x + ", " + cubeCenter.y + ", " + cubeCenter.z + ")");
                cube.rotateX(mRotateX);

                addObject(cube);
            }
        }
    }


}