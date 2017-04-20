package hust.mallguide;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.orhanobut.logger.Logger;

import java.lang.ref.WeakReference;
import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;
import hust.mallguide.base.NoScrollViewPager;
import hust.mallguide.guides.TabTwoFragment;
import hust.mallguide.utils.ToastUtils;
import hust.mallguide.infos.TabFourFragment;
import hust.mallguide.malls.TabOneFragment;
import hust.mallguide.services.TabThreeFragment;

public class MainActivity extends AppCompatActivity {
    private static final String LOG_TAG = "LOG_TAG";
    // 标签配置
    // 通信接受的字符串

    /* 自定义Tab */
    @BindView(R.id.radio1)
    RadioButton radio1;
    @BindView(R.id.radio2)
    RadioButton radio2;
    @BindView(R.id.radio3)
    RadioButton radio3;
    @BindView(R.id.radio4)
    RadioButton radio4;

    @BindView(R.id.barTxt)
    TextView barTxt;
    @BindView(R.id.bottomRg)
    RadioGroup bottomRg;
    @BindView(R.id.myViewPager)
    NoScrollViewPager myViewPager;


    /* Fragment管理 */
    private FragmentManager fragmentManager;
    private MyHandler mHandler;

    /* 四个界面组 */
    private TabOneFragment taboneFragemnt;
    private TabTwoFragment tabTwoFragment;
    private TabThreeFragment tabThreeFragemnt;
    private TabFourFragment tabFourFragment;

    private ArrayList<Fragment> fragmentList;
    private MyViewAdapter mAdapter;

    private int curIndex = 0;

    private int[] headTitles = {R.string.tab_title_txt1, R.string.tab_title_txt2, R.string.tab_title_txt3, R.string.tab_title_txt4};


    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_load);
        mHandler = new MyHandler(this);
        ButterKnife.bind(this);

        initView();

        Logger.init(LOG_TAG);
        Logger.i("Logger Print", radio1);


    }

    /* 界面初始化 */
    private void initView() {
        // 初始化底部的导航
        initTabs();
        // 初始化RecyclerView
    }

    private void initTabs() {
        fragmentManager = super.getSupportFragmentManager();
        taboneFragemnt = new TabOneFragment();
        tabTwoFragment = new TabTwoFragment();
        tabThreeFragemnt = new TabThreeFragment();
        tabFourFragment = new TabFourFragment();

        fragmentList = new ArrayList<>();
        fragmentList.add(taboneFragemnt);
        fragmentList.add(tabTwoFragment);
        fragmentList.add(tabThreeFragemnt);
        fragmentList.add(tabFourFragment);
        mAdapter = new MyViewAdapter(fragmentManager, fragmentList);
        setCurFragment(0);
        myViewPager.setAdapter(mAdapter);
        myViewPager.setOffscreenPageLimit(4);
        myViewPager.addOnPageChangeListener(new MyOnPageChangeListener());

        bottomRg.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {

            public void onCheckedChanged(RadioGroup group, int checkedId) {
                int index = 0;
                switch (checkedId) {
                    case R.id.radio1:
                        index = 0;
                        break;
                    case R.id.radio2:
                        index = 1;
                        break;
                    case R.id.radio3:
                        index = 2;
                        break;
                    case R.id.radio4:
                        index = 3;
                        break;
                    default:
                        break;
                }
                setCurFragment(index);
            }
        });
    }

    private <T> T $(int resId) {
        return (T) findViewById(resId);
    }

    // 设置当前界面
    private void setCurFragment(int newIndex) {
        SetRadioTextColor(newIndex);

        myViewPager.setCurrentItem(newIndex, true);
        curIndex = newIndex;
    }


    // 构建ViewPager的Adapter
    private class MyViewAdapter extends FragmentPagerAdapter {

        private ArrayList<Fragment> fragmentList;

        public MyViewAdapter(FragmentManager fm, ArrayList<Fragment> fragmentList) {
            super(fm);
            this.fragmentList = fragmentList;
        }

        @Override
        public Fragment getItem(int position) {
            if (fragmentList != null)
                return fragmentList.get(position);
            return null;
        }

        @Override
        public int getCount() {
            return fragmentList.size();
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            super.destroyItem(container, position, object);
        }
    }

    // 监听Viewpager滑动
    private class MyOnPageChangeListener implements ViewPager.OnPageChangeListener {

        @Override
        public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        }

        @Override
        public void onPageSelected(int position) {
            setCurFragment(position);
        }

        @Override
        public void onPageScrollStateChanged(int state) {
            Log.w(LOG_TAG, "state == " + state);
        }
    }


    /*转换店中TAb后的文字颜色变化*/
    private void SetRadioTextColor(int index) {
        RadioButton[] radioButtons = {radio1, radio2, radio3, radio4};
        barTxt.setText(headTitles[index]);
        if (index < radioButtons.length) {
            for (int i = 0; i < radioButtons.length; i++) {
                if (index == i) {
                    radioButtons[i].setChecked(true);
                }
            }
        }
    }

    private static class MyHandler extends Handler {
        public static final int EXIT_APP = 1;

        /* 建立弱引用 */
        private WeakReference<MainActivity> mOuter;

        /* 构造函数 */
        public MyHandler(MainActivity activity) {
            mOuter = new WeakReference<>(activity);
        }

        public void handleMessage(Message msg) {
            // 防止内存泄露
            MainActivity outer = mOuter.get();
            if (outer != null) {
                outer.handleservice(msg);
            }
        }
    }

    /**
     * 消息处理函数
     */
    private void handleservice(Message msg) {
        switch (msg.what) {
            case MyHandler.EXIT_APP:
                this.finish();
                break;
        }
    }

    private volatile int pressedTime = 0;

    // 对返回键进行控制
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getKeyCode() == KeyEvent.KEYCODE_BACK
                && event.getAction() == KeyEvent.ACTION_DOWN) {
            if (pressedTime == 0) {
                pressedTime++;
                ToastUtils.show(this, R.string.exit_tag);
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            Thread.sleep(1500);
                        } catch (InterruptedException e) {

                        }
                        pressedTime = 0;
                    }
                });
            } else if (pressedTime == 1) {
                // 退出应用
                mHandler.sendEmptyMessage(MyHandler.EXIT_APP);
            }
        }
        return true;
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
