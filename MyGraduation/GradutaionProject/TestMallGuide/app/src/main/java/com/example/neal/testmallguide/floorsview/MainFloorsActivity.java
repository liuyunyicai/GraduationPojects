package com.example.neal.testmallguide.floorsview;

import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

import com.example.neal.testmallguide.R;
import com.example.neal.testmallguide.floorsview.route.GetRouteServices;
import com.example.neal.testmallguide.floorsview.route.RouteInfo;
import com.example.neal.testmallguide.floorsview.zone.GetFireServices;
import com.example.neal.testmallguide.retrofit.OkHttpUtils;
import com.example.neal.testmallguide.utils.LogUtils;
import com.example.neal.testmallguide.utils.SharedUtils;
import com.igexin.sdk.PushManager;

import java.util.List;

import butterknife.BindView;
import butterknife.BindViews;
import butterknife.ButterKnife;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by neal on 2017/3/15.
 */
public class MainFloorsActivity extends AppCompatActivity {
    private BaseThreeDFragment curFragment;
    private int curFloor = 0;
    private OkHttpUtils okHttpUtils;

    @BindView(R.id.rgRight)
    RadioGroup rgRight;

    @BindViews({R.id.rbRight1, R.id.rbRight2, R.id.rbRight3, R.id.rbRight4, R.id.rbRight5, R.id.rbRight6, R.id.rbRight7, R.id.rbRight8, R.id.rbRight9})
    List<RadioButton> radioButtons;

    private BaseThreeDFragment[] floorFragments;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_floors);

        initView();
        okHttpUtils = OkHttpUtils.getInstance(this);

        if (SharedUtils.getSharedUtils(this).getBoolean(SharedUtils.ISFIRED)) { // 发生火灾时
//            getRouteInfo();// 画疏散路线
//            getFireInfo();
//            getCrowedInfo();
//            getDangerInfo();
        }
    }


    private void initView() {
        ButterKnife.bind(this);

        // 初始化每一个楼层
        floorFragments = new BaseThreeDFragment[radioButtons.size()];

        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        for (int i = 0; i < floorFragments.length; i++) {
            floorFragments[i] = new BaseThreeDFragment();
            int value = (i + 1);
            Bundle data = new Bundle();
            data.putInt(BaseThreeDFragment.FLOOR_NUM_BUNDLE, value);
            floorFragments[i].setArguments(data);// 将bundle数据加到Fragment中
            transaction.add(R.id.map_container, floorFragments[i]);
            transaction.hide(floorFragments[i]);
        }
        // 切换到当前层
        curFloor = 7;
        curFragment = floorFragments[curFloor];
        transaction.show(curFragment).commit();

        initExtras();
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
                            for (BaseThreeDFragment fragment : floorFragments)
                                fragment.drawLine(result);
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
                            for (BaseThreeDFragment fragment : floorFragments)
                                fragment.drawZone(zoneInfos, type);
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
    * 切换到对应楼层界面
    **/
    private void switchToFloor(int nextFloor) {
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.hide(curFragment);

        curFloor = nextFloor;
        curFragment = floorFragments[curFloor];

        transaction.show(curFragment).commit();
    }

    private void initExtras() {
        radioButtons.get(curFloor).setChecked(true);
        initRadioBts(radioButtons);

        radioButtons.get(0).setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
//                getRouteInfo();// 画疏散路线
//                getFireInfo();
//                getCrowedInfo();
//                getDangerInfo();
                getCid();
                return false;
            }
        });

        radioButtons.get(radioButtons.size() - 1).setVisibility(View.INVISIBLE);

        rgRight.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                int nextFloor = 0;
                switch (checkedId) {
                    case R.id.rbRight1:
                        nextFloor = 0;
                        break;
                    case R.id.rbRight2:
                        nextFloor = 1;
                        break;
                    case R.id.rbRight3:
                        nextFloor = 2;
                        break;
                    case R.id.rbRight4:
                        nextFloor = 3;
                        break;
                    case R.id.rbRight5:
                        nextFloor = 4;
                        break;
                    case R.id.rbRight6:
                        nextFloor = 5;
                        break;
                    case R.id.rbRight7:
                        nextFloor = 6;
                        break;
                    case R.id.rbRight8:
                        nextFloor = 7;
                        break;
                    case R.id.rbRight9:
//                        nextFloor = curFloor;

                        break;
                }
                switchToFloor(nextFloor);
                LogUtils.w("Switch To Floor" + nextFloor);
            }
        });


    }

    private void getCid() {
        String cid = PushManager.getInstance().getClientid(this);
        Toast.makeText(this, "当前应用的clientid = " + cid, Toast.LENGTH_LONG).show();
        Log.d("LOG_TAG", "当前应用的clientid = " + cid);
    }


    // 初始化RadioButton
    private void initRadioBts(List<RadioButton> radioButtons) {
        if (null != radioButtons) {
            int floor = 0;
            String floor_txt = getResources().getString(R.string.floor_name_base);
            for (RadioButton radioButton : radioButtons) {
                if (null != radioButton) {
                    radioButton.setText((++floor) + floor_txt);
                }
            }
        }


    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (curFragment != null)
            curFragment.onTouchEvent(event);
        return super.onTouchEvent(event);
    }
}
