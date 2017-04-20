package hust.mallguide.logreg;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import hust.mallguide.R;

/**
 * Created by admin on 2016/3/23.
 */
public class LogActivity extends AppCompatActivity implements View.OnClickListener{

    private Fragment logFragment, regFragment;
    private FragmentManager fManager;
    private LogFragment.LogInfoListener logListener = new LogFragment.LogInfoListener() {
        @Override
        public void onJumpToRegFrag() {
            changeTo(regFragment);
        }
    };
    private RegFragment.RegInfoListener regListener = new RegFragment.RegInfoListener() {
        @Override
        public void onJumpToLogFrag() {
            changeTo(logFragment);
        }
    };

    private TextView goto_bt, visitor_bt;
    private boolean isCurLog = true; // 当前是否是Log界面
    private ImageView setting_bt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.log_layout);

        goto_bt = $(R.id.goto_bt);
        goto_bt.setOnClickListener(this);
        visitor_bt = $(R.id.visitor_bt);
        visitor_bt.setOnClickListener(this);
        setting_bt = $(R.id.setting_bt);
        setting_bt.setOnClickListener(this);

        goto_bt.setText(R.string.no_reg);
        visitor_bt.setText(R.string.visitor_txt);

        initFragment();
    }

    private void initFragment() {
        if (logFragment == null) {
            logFragment = new LogFragment();
            ((LogFragment)logFragment).setListener(logListener);
        }
        if (regFragment == null) {
            regFragment = new RegFragment();
            ((RegFragment)regFragment).setListener(regListener);
        }

        fManager = getSupportFragmentManager();
        changeTo(logFragment);
    }

    private void changeTo(Fragment fragment) {
        if (fragment != null) {
            FragmentTransaction transaction = fManager.beginTransaction();
            transaction.replace(R.id.container, fragment);
            transaction.commit();
        }
    }

    private <T> T $(int resId) {
        return (T) findViewById(resId);
    }

    // 切换到注册界面
    private void switchToReg() {
        changeTo(regFragment);
        goto_bt.setText(R.string.already_reg);
        isCurLog = false;
    }

    // 切换到登录界面
    private void switchToLog() {
        changeTo(logFragment);
        goto_bt.setText(R.string.no_reg);
        isCurLog = true;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.goto_bt:
                if (isCurLog) {
                    switchToReg();
                } else {
                    switchToLog();
                }
                break;
            case R.id.visitor_bt:
                break;

            case R.id.setting_bt:
                break;
        }
    }
}
