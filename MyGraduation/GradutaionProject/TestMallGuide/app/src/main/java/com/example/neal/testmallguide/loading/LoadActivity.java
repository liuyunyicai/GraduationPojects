package com.example.neal.testmallguide.loading;

import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.animation.PropertyValuesHolder;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.ActivityCompat;
import android.view.Window;
import android.widget.ImageView;

import com.example.neal.testmallguide.R;
import com.example.neal.testmallguide.floorsview.MainFloorsActivity;
import com.example.neal.testmallguide.loaddata.LoadingDataActivity;
import com.example.neal.testmallguide.push.DemoIntentService;
import com.example.neal.testmallguide.push.DemoPushService;
import com.example.neal.testmallguide.retrofit.OkHttpUtils;
import com.example.neal.testmallguide.utils.LogUtils;
import com.example.neal.testmallguide.utils.SharedUtils;
import com.igexin.sdk.PushManager;

import java.io.File;
import java.lang.ref.WeakReference;

import butterknife.BindView;
import butterknife.ButterKnife;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;


public class LoadActivity extends Activity implements LoadingProgressBar.LoadingListener {

    private static final int TYPE_STOP = 1;
    @BindView(R.id.loadingBar)
    LoadingProgressBar loadingBar;
    @BindView(R.id.imageView1)
    ImageView mImageView;

    private MyHandler mHandler;

    private OkHttpUtils okHttpUtils;

    private String appkey;
    private String appsecret;
    private String appid;
    private static final int REQUEST_PERMISSION = 0;

    private static final int DURATION_TIME = 2000;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.loading_layout);

        initPushService();

        if (!SharedUtils.getSharedUtils(this).getBoolean(SharedUtils.ISFIRED)) { // 平常情况
            initView();
        } else {  // 发生火灾时直接跳转
            startActivity(new Intent(this, LoadingDataActivity.class));
            finish();
        }

    }

    /*
    * 初始化推送相关信息
    **/
    private void initPushService() {
        parseManifests();

        PackageManager pkgManager = getPackageManager();

        // 读写 sd card 权限非常重要, android6.0默认禁止的, 建议初始化之前就弹窗让用户赋予该权限
        boolean sdCardWritePermission =
                pkgManager.checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, getPackageName()) == PackageManager.PERMISSION_GRANTED;

        // read phone state用于获取 imei 设备信息
        boolean phoneSatePermission =
                pkgManager.checkPermission(Manifest.permission.READ_PHONE_STATE, getPackageName()) == PackageManager.PERMISSION_GRANTED;

        if (Build.VERSION.SDK_INT >= 23 && !sdCardWritePermission || !phoneSatePermission) {
            requestPermission();
        } else {
            PushManager.getInstance().initialize(this.getApplicationContext(), DemoPushService.class);
        }
        PushManager.getInstance().registerPushIntentService(this.getApplicationContext(), DemoIntentService.class);

        // 检查 so 是否存在
        File file = new File(this.getApplicationInfo().nativeLibraryDir + File.separator + "libgetuiext2.so");
    }

    private void requestPermission() {
        ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE},
                REQUEST_PERMISSION);
    }

    private void parseManifests() {
        String packageName = getApplicationContext().getPackageName();
        try {
            ApplicationInfo appInfo = getPackageManager().getApplicationInfo(packageName, PackageManager.GET_META_DATA);
            if (appInfo.metaData != null) {
                appid = appInfo.metaData.getString("PUSH_APPID");
                appsecret = appInfo.metaData.getString("PUSH_APPSECRET");
                appkey = appInfo.metaData.getString("PUSH_APPKEY");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    /*
    * 初始化界面控件
    **/
    private void initView() {
        ButterKnife.bind(this);

        // 添加监听器
        loadingBar.setLoadingListener(this);

        // 组合形式使用动画
        PropertyValuesHolder pvhX = PropertyValuesHolder.ofFloat("scaleX", 1f, 1.3f);
        PropertyValuesHolder pvhY = PropertyValuesHolder.ofFloat("scaleY", 1f, 1.3f);
        ObjectAnimator animator = ObjectAnimator.ofPropertyValuesHolder(mImageView, pvhX, pvhY);
        animator.setDuration(DURATION_TIME);
        // 添加动画监听器
        animator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
            }
        });
        animator.start();

        mHandler = new MyHandler(this);

        okHttpUtils = OkHttpUtils.getInstance(this);
        uploadIndexInfo();
    }

    // 上传位置信息
    private void uploadIndexInfo() {
        UserGirdInfo dataInfo = new UserGirdInfo();
        dataInfo.setGrid_x(203);
        dataInfo.setGrid_y(73);
        dataInfo.setGrid_z(5);


        UpLoadServices upLoadServices = okHttpUtils.create(UpLoadServices.class);
        Observable<String> obs = upLoadServices.login(UpLoadServices.UPLOAD_URL, dataInfo);

        obs.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<String>() {
                    @Override
                    public void onCompleted() {
                        LogUtils.w("onCompleted");
                    }

                    @Override
                    public void onError(Throwable e) {
                        LogUtils.e("Error:" + e.toString());
                    }

                    @Override
                    public void onNext(String result) {
                        LogUtils.w("Result:" + result);
                    }
                });
    }

    @Override
    public void onAnimationStart() {
    }

    @Override
    public void onAnimationEnd() {
        mHandler.sendEmptyMessage(TYPE_STOP);
    }

    private static class MyHandler extends Handler {
        WeakReference<LoadActivity> act;

        public MyHandler(LoadActivity activity) {
            act = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            LoadActivity activity = act.get();
            if (activity != null) {
                activity.handleMessage(msg);
            }
        }
    }

    // 处理消息事件
    public void handleMessage(Message msg) {
        switch (msg.what) {
            case TYPE_STOP:

                try {
                    startActivity(new Intent(this, MainFloorsActivity.class));
                    finish();
                } catch (Exception e) {

                }
                break;
        }
    }
}
