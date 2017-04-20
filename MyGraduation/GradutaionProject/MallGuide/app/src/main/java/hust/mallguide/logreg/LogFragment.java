package hust.mallguide.logreg;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.InputType;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.orhanobut.logger.Logger;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import hust.mallguide.MainActivity;
import hust.mallguide.R;
import hust.mallguide.utils.LogUtils;
import hust.mallguide.utils.ToastUtils;
import hust.mallguide.utils.ViewUtils;
import hust.mallguide.retrofit.OkHttpUtils;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by admin on 2016/3/23.
 */
public class LogFragment extends Fragment implements View.OnClickListener{

    private View view;

    private RelativeLayout reg_bt_layout;

    @BindView(R.id.main_view)
    LinearLayout main_view;
    @BindView(R.id.load_bt)
    Button log_bt;
    @BindView(R.id.more_bt)
    TextView goto_reg_bt;
    @BindView(R.id.load_img)
    ImageView load_img;

    private LogInfoListener listener;

    @BindView(R.id.reg_name_layout)
    RelativeLayout reg_name_layout;
    @BindView(R.id.reg_passwrd_layout)
    RelativeLayout reg_passwrd_layout;

    TextView name_title;
    EditText name_txt;

    TextView passwd_title;
    EditText passwd_txt;

    private OkHttpUtils okHttpUtils;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.login_layout, container, false);

        okHttpUtils = OkHttpUtils.getInstance(getActivity());
        Logger.init();

        ButterKnife.bind(this, view);

        initView();
        init();

        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    private void initView () {
        name_title = $(reg_name_layout, R.id.item_title);
        name_txt = $(reg_name_layout, R.id.item_txt);

        passwd_txt = $(reg_passwrd_layout, R.id.item_txt);
        passwd_title = $(reg_passwrd_layout, R.id.item_title);

        name_title.setText(R.string.name_str);
        passwd_title.setText(R.string.passed_str);
        name_txt.setHint(R.string.name_hint);
        name_txt.setInputType(InputType.TYPE_CLASS_TEXT);

        name_txt.setText("13349888356");
        passwd_txt.setText("111111");

        log_bt.setText(R.string.load_txt);
    }

    // 登录按钮
    @OnClick(R.id.load_bt)
    void loadOnClick() {
        // 先进行登录操作
        if (ViewUtils.isEditTxEmpty(name_txt) || ViewUtils.isEditTxEmpty(passwd_txt)) {
            ToastUtils.show(getActivity(), "账号或密码不能为空");
            return;
        }

//        logIn();
        jumpToMain();
    }

    private void jumpToMain() {
        // 跳转到主界面
        Activity act = getActivity();
        act.startActivity(new Intent(act, MainActivity.class));
        act.finish();
    }

    private void logIn() {
        LogServices logServices = okHttpUtils.create(LogServices.class);
        Observable<UserInfoDetails> obs = logServices.login(LogServices.LOGIN_URL, new UserInfo(name_txt, passwd_txt));

        obs.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<UserInfoDetails>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        Logger.e("logIn Error: %s", e.toString());
                        ToastUtils.show(getActivity(), "账号或密码有误！");
                    }

                    @Override
                    public void onNext(UserInfoDetails userInfoDetails) {
                        Logger.i("LogIn Success!");
                        // 跳转到主界面
                        jumpToMain();
                    }
                });
    }

    // 切换到注册界面按钮
    @OnClick(R.id.more_bt)
    void goToRegOnClick() {
        jumpTpRegView();
    }


    private boolean isNameHasFocus, isPasswdHasFocus;

    private void init() {

        name_txt.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                doHideLogo(hasFocus);
            }
        });
        passwd_txt.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                doHideLogo(hasFocus);
            }
        });
    }

    // 隐藏logo
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private void doHideLogo(boolean hasFocus) {
        isNameHasFocus = name_txt.getShowSoftInputOnFocus();
        isPasswdHasFocus = passwd_txt.getShowSoftInputOnFocus();
        if (hasFocus) {
            hideLogo(true);
        } else {
            if ((!isPasswdHasFocus) && (!isNameHasFocus)) {
                hideLogo(false);
            }
        }
    }

    private boolean isHide;
    private void hideLogo(boolean toHide) {
        LogUtils.i("isPasswdHasFocus == " + isPasswdHasFocus);
        LogUtils.i("isNameHasFocus == " + isNameHasFocus);

        if (toHide) {
            if (!isHide) {
                isHide = true;
                LogUtils.i("Hide");
            }
        } else {
            if (isHide) {
                isHide = false;
                LogUtils.w("Open");
            }
        }
    }


    // 跳转到注册界面
    private void jumpTpRegView() {
        if (listener != null) {
            listener.onJumpToRegFrag();
        }
    }

    @Override
    public void onClick(View v) {
    }

    public interface LogInfoListener {
        void onJumpToRegFrag();
    }

    public void setListener(LogInfoListener listener) {
        this.listener = listener;
    }


    private <T> T $(View view, int resId) {
        return (T) view.findViewById(resId);
    }
}
