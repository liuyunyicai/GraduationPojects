package hust.mallguide.guides;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Point;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import butterknife.BindView;
import butterknife.ButterKnife;
import hust.mallguide.R;
import hust.mallguide.guides.allView.AllViewActivity;
import hust.mallguide.guides.threeD.ThreeDActivity;
import hust.mallguide.location.ScanActivity;

/**
 * Created by admin on 2016/3/24.
 */
public class TabTwoFragment extends Fragment {
    private View view;
    private MapFragment mapOneFragment, mapTwoFragment, mapThreeFragment;

    private MapFragment mapAllFragment;
    private String map_all_path = "map_all";
    private FragmentManager fragmentManager;
    private String[] map_paths = {"map_1", "map_2", "map_3"};

    @BindView(R.id.rgRight)
    RadioGroup rgRight;
    @BindView(R.id.rgTest)
    RadioGroup rgTest;

    @BindView(R.id.rbRight1)
    RadioButton rbRight1;
    @BindView(R.id.rbRight2)
    RadioButton rbRight2;

    @BindView(R.id.rbRight3)
    RadioButton rbRight3;
    @BindView(R.id.rbRight4)
    RadioButton rbRight4;

    @BindView(R.id.rbRight5)
    RadioButton rbRight5;

    @BindView(R.id.rbTest1)
    RadioButton rbTest1;
    @BindView(R.id.rbTest2)
    RadioButton rbTest2;
    @BindView(R.id.rbTest3)
    RadioButton rbTest3;

    private MapFragment currFragment;
    private MapFragment lastFragment;



    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.tabtwo_layout, container, false);
        fragmentManager = getActivity().getSupportFragmentManager();

        ButterKnife.bind(this, view);

        mapOneFragment = new MapFragment();
        mapTwoFragment = new MapFragment();
        mapThreeFragment = new MapFragment();
        mapAllFragment = new MapFragment();

        initMapFragment(mapOneFragment, map_paths[0]);
        initMapFragment(mapTwoFragment, map_paths[1]);
        initMapFragment(mapThreeFragment, map_paths[2]);
        initMapFragment(mapAllFragment, map_all_path);

        mapOneFragment.setListener(listener);
        mapTwoFragment.setListener(listener);
        mapThreeFragment.setListener(listener);
        mapAllFragment.setListener(listener);

        fragmentManager.beginTransaction()
                .add(R.id.mapContent, mapOneFragment)
                .commit();
        currFragment = mapOneFragment;
        lastFragment = mapOneFragment;
        rbRight1.setChecked(true);
        mapOneFragment.setLoaded(true);

        initView();

        return view;
    }

    private void initMapFragment(MapFragment mapFragment, String map_path) {
        Bundle data = new Bundle();
        data.putString(MapFragment.MAP_PATH, map_path);
        mapFragment.setArguments(data);
    }

    private void initView() {
        rbRight1.setText(R.string.rbright1);
        rbRight2.setText(R.string.rbright2);

        rbTest1.setText(R.string.rbtest1);
        rbTest2.setText(R.string.rbtest2);
        rbTest3.setText(R.string.rbtest3);

        rbRight3.setText(R.string.rbright3);
        rbRight4.setText(R.string.rbright4);
        rbRight5.setText(R.string.rbright5);
        hide3DButton();

        rgTest.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.rbTest1:
                        switchToFragment(mapOneFragment);
                        break;
                    case R.id.rbTest2:
                        switchToFragment(mapTwoFragment);
                        break;
                    case R.id.rbTest3:
                        switchToFragment(mapThreeFragment);
                        break;
                }
            }
        });

        rgRight.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.rbRight1:
                        switchToFragment(lastFragment);
                        break;
                    case R.id.rbRight2:
                        switchToFragment(mapAllFragment, true);
                        break;

                    case R.id.rbRight3:
                        rbRight3.setChecked(false);
                        showAllView();
                        break;

                    case R.id.rbRight4:
                        rbRight4.setChecked(false);
                        show3DView();
                        break;

                    case R.id.rbRight5:
                        rbRight5.setChecked(false);
                        showScanIndex();
                        break;
                }
            }
        });
    }

    // 显示定位效果
    private final static int SCANNIN_GREQUEST_CODE = 1;
    private void showScanIndex() {
        Intent intent = new Intent(getActivity(), ScanActivity.class);
        startActivityForResult(intent, SCANNIN_GREQUEST_CODE);
    }


    //
    public static final int SELF_LOC_OBJID = 0;
    public static Point selfLocPoint;
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case SCANNIN_GREQUEST_CODE:
                if(resultCode == Activity.RESULT_OK){
                    Bundle bundle = data.getExtras();
                    // 处理扫描得到的结果
                    String result = bundle.getString("result");

                    if (result != null) {
                        try {
                            String[] datas = result.split("#");
                            if (selfLocPoint == null) {
                                selfLocPoint = new Point();
                            }
                            selfLocPoint.set(Integer.valueOf(datas[0]), Integer.valueOf(datas[1]));
                            currFragment.setSelfLocation();
                        } catch (Exception e) {
                        }
                    }
                }
                break;
        }
    }



    // 显示全景
    private void showAllView() {
        startActivity(new Intent(getActivity(), AllViewActivity.class));
    }

    // 显示3D效果
    private void show3DView() {
        startActivity(new Intent(getActivity(), ThreeDActivity.class));
    }

    private void switchToFragment(MapFragment to) {
        switchToFragment(to, false);
    }

    private void switchToFragment(MapFragment to, boolean isAll) {
        FragmentTransaction transaction = fragmentManager.beginTransaction().hide(currFragment);

        if (to.isLoaded())
            transaction.show(to).commit();
        else
            transaction.add(R.id.mapContent, to).commit();
        to.setLoaded(true);
        currFragment = to;
        if (!isAll)
            lastFragment = currFragment;
    }

    public MapFragment.MapEventListener listener = new MapFragment.MapEventListener() {
        @Override
        public void doubleClicked() {
            show3DButton();
        }

        @Override
        public void cancelDoubleClicked() {
            hide3DButton();
        }
    };

    // 显示全景按钮
    private void show3DButton() {
        rbRight3.setVisibility(View.VISIBLE);
        rbRight4.setVisibility(View.VISIBLE);

        rbRight3.setChecked(false);
        rbRight4.setChecked(false);
    }

    // 隐藏全景按钮
    private void hide3DButton() {
        rbRight3.setVisibility(View.GONE);
        rbRight4.setVisibility(View.GONE);
    }


}
