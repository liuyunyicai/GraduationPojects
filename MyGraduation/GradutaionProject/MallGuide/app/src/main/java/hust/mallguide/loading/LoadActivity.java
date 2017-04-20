package hust.mallguide.loading;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Window;

import java.lang.ref.WeakReference;

import hust.mallguide.MainActivity;
import hust.mallguide.R;
import hust.mallguide.utils.SharedUtils;
import hust.mallguide.logreg.LogActivity;

public class LoadActivity extends Activity implements LoadingProgressBar.LoadingListener{

    private static final int TYPE_STOP = 1;
    private LoadingProgressBar loadingBar;
    private SharedUtils sharedUtils;
    private MyHandler mHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.loading_layout);

        loadingBar = (LoadingProgressBar) findViewById(R.id.loadingBar);
        // 添加监听器
        loadingBar.setLoadingListener(this);

        sharedUtils = SharedUtils.getSharedHelper(this);
        mHandler = new MyHandler(this);
    }

    @Override
    public void onAnimationStart() {
    }

    @Override
    public void onAnimationEnd() {
        mHandler.sendEmptyMessage(TYPE_STOP);
    }

    private class MyHandler extends Handler {
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
                boolean isLoged = sharedUtils.getBoolean(SharedUtils.ISLOGED);
                if (!isLoged) { // 首次登录
                    Intent intent = new Intent(LoadActivity.this, LogActivity.class);
                    LoadActivity.this.startActivity(intent);
                } else {
                    // 转换到主界面
                    Intent intent_two = new Intent(LoadActivity.this, MainActivity.class);
                    LoadActivity.this.startActivity(intent_two);
                }

                finish();
                break;
        }
    }
}
