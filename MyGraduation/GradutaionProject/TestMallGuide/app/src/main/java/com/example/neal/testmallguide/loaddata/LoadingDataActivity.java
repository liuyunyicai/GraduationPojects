package com.example.neal.testmallguide.loaddata;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.view.Window;

import com.example.neal.testmallguide.R;
import com.example.neal.testmallguide.floorsview.BaseThreeDFragment;
import com.example.neal.testmallguide.floorsview.BuildingRender;
import com.example.neal.testmallguide.floorsview.MainFloorsActivity;
import com.example.neal.testmallguide.floorsview.route.GetRouteServices;
import com.example.neal.testmallguide.floorsview.route.RouteInfo;
import com.example.neal.testmallguide.floorsview.zone.GetFireServices;
import com.example.neal.testmallguide.floorsview.zone.GetStairsServices;
import com.example.neal.testmallguide.floorsview.zone.StairsInfo;
import com.example.neal.testmallguide.retrofit.OkHttpUtils;
import com.example.neal.testmallguide.utils.LogUtils;

import java.lang.ref.WeakReference;
import java.util.List;

import butterknife.BindView;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by neal on 2016/4/7.
 */
public class LoadingDataActivity extends AppCompatActivity  {

    PrecentProgressBar mProgressBar;

    public static final int EVENT_INCREASE = 0;
    public static final int LOADED_DATA = 1;

    private int mTotalDuration = 2000; // 200ms
    private int mValueMax = 100;
    private int mCurValue = 0;

    private MyHandler mHandler;
    private OkHttpUtils okHttpUtils;
    private DataInfo mDataInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_loading_data);

        okHttpUtils = OkHttpUtils.getInstance(this);
        initData();

        initProgress();
    }

    /**
     * 从服务器中获取数据
     **/
    private void initData() {
        mDataInfo = DataInfo.getInstance();

        getStairsInfo();
    }

    /*
    * 获取楼梯区域
    **/
    private void getStairsInfo() {
        GetStairsServices getStairsServices = okHttpUtils.create(GetStairsServices.class);
        Observable<List<StairsInfo>> observable = getStairsServices.getStairsZone(GetStairsServices.GET_STAIRS_URL);
        observable.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<List<StairsInfo>>() {
                    @Override
                    public void onCompleted() {
                        LogUtils.w("getStairsInfo onCompleted");
                    }

                    @Override
                    public void onError(Throwable e) {
                        LogUtils.e("getStairsInfo Error:" + e.toString());
                    }

                    @Override
                    public void onNext(List<StairsInfo> stairsInfos) {
                        // 在这里对所有楼层进行路径划分
                        if (null != stairsInfos) {
                            mDataInfo.setStairsInfos(stairsInfos);
                            // 然后再继续获取路径
                            getRouteInfo();
                            getDangerInfo();
                            getCrowedInfo();
                            getFireInfo();

                            LogUtils.w("getStairsInfo Result:" + stairsInfos.get(0).getGrid_x());
                        }

                    }
                });
    }

    /*
    * 获取安全疏散路径
    **/
    private void getRouteInfo() {
        GetRouteServices getRouteServices = okHttpUtils.create(GetRouteServices.class);
        Observable<List<RouteInfo>> observable = getRouteServices.getRoute(GetRouteServices.GET_ROUTE_URL);

        observable.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<List<RouteInfo>>() {
                    @Override
                    public void onCompleted() {
                        LogUtils.w("getRouteInfo onCompleted");
                    }

                    @Override
                    public void onError(Throwable e) {
                        LogUtils.e("getRouteInfo Error:" + e.toString());
                    }

                    @Override
                    public void onNext(List<RouteInfo> result) {
                        // 在这里对所有楼层进行路径划分
                        if (null != result) {
                            mDataInfo.setRouteInfos(result);
                        }
                        LogUtils.w("Result:" + result.get(0).getGrid_x());

                    }
                });
    }

    /*
    * 获取火灾区域
    **/
    private void getZoneInfo(String path, final int type) {
        GetFireServices getFireServices = okHttpUtils.create(GetFireServices.class);
        Observable<List<RouteInfo>> observable = getFireServices.getZone(path);
        observable.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<List<RouteInfo>>() {
                    @Override
                    public void onCompleted() {
                        LogUtils.w("GetFireServices onCompleted");
                    }

                    @Override
                    public void onError(Throwable e) {
                        LogUtils.e("GetFireServices Error:" + e.toString());
                    }

                    @Override
                    public void onNext(List<RouteInfo> zoneInfos) {
                        // 在这里对所有楼层进行路径划分
                        if (null != zoneInfos) {
                            switch (type) {
                                case BuildingRender.TYPE_FIRE:
                                    mDataInfo.setFireInfos(zoneInfos);
                                    break;
                                case BuildingRender.TYPE_DANGER:
                                    mDataInfo.setDangerInfos(zoneInfos);
                                    break;
                                case BuildingRender.TYPE_CROWED:
                                    mDataInfo.setCrowdedInfos(zoneInfos);
                                    break;
                            }
                        }
                        LogUtils.w("GetFireServices Result:" + zoneInfos.get(0).getGrid_x());
                    }
                });

    }

    /*
    * 获取火险区域
    **/
    private void getFireInfo() {
        getZoneInfo(GetFireServices.GET_ZONE_URL, BuildingRender.TYPE_FIRE);
    }

    /*
    * 获取危险区域
    **/
    private void getDangerInfo() {
        getZoneInfo(GetFireServices.GET_DANGER_URL, BuildingRender.TYPE_DANGER);
    }

    /*
   * 获取拥挤区域
   **/
    private void getCrowedInfo() {
        getZoneInfo(GetFireServices.GET_CROWED_URL, BuildingRender.TYPE_CROWED);
    }





    /*
    * 初始化进度条相关信息
    **/
    private void initProgress() {
        mProgressBar = (PrecentProgressBar) findViewById(R.id.mProgressBar);
        mHandler = new MyHandler(this);

        new Thread(new Runnable() {
            @Override
            public void run() {

                while (mCurValue < mValueMax) {
                    try {
                        Thread.sleep(mTotalDuration / mValueMax);
                        mHandler.sendEmptyMessage(EVENT_INCREASE);
                    } catch (Exception e) {

                    }
                }

            }
        }).start();
    }

    private static class MyHandler extends Handler {
        WeakReference<LoadingDataActivity> act;

        public MyHandler(LoadingDataActivity activity) {
            act = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);

            LoadingDataActivity activity = act.get();
            if (activity != null) {
                activity.handleMessage(msg);
            }
        }
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case EVENT_INCREASE:
                mCurValue++;
                if (mCurValue < mValueMax) {
                    mProgressBar.setProgress(mCurValue);
                } else {
                    startActivity(new Intent(this, MainFloorsActivity.class));
                    finish();
                }
                break;
        }
    }
}
