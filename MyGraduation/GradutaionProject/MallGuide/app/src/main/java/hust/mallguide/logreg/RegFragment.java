package hust.mallguide.logreg;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.InputType;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import hust.mallguide.R;

/**
 * Created by admin on 2016/3/23.
 */
public class RegFragment extends Fragment implements View.OnClickListener{
    private View view;
    private LinearLayout main_view;

    private RelativeLayout reg_name_layout, reg_random_layout;
    private TextView name_title, random_title;
    private EditText name_txt, random_txt;

    private Button reg_bt;
    private TextView goto_log_bt;
    private ImageView load_img;

    private RegInfoListener listener;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.login_layout, container, false);

        initView();
        init();
        measureView();

        return view;
    }

    private void initView() {
        reg_name_layout = $(view, R.id.reg_name_layout);
        name_title = $(reg_name_layout, R.id.item_title);
        name_txt = $(reg_name_layout, R.id.item_txt);

        reg_random_layout = $(view, R.id.reg_passwrd_layout);
        random_title = $(reg_random_layout, R.id.item_title);
        random_txt = $(reg_random_layout, R.id.item_txt);

        reg_bt = $(view, R.id.load_bt);
        goto_log_bt = $(view, R.id.more_bt);

        load_img = $(view, R.id.load_img);
        main_view = $(view, R.id.main_view);

        name_txt.setInputType(InputType.TYPE_CLASS_TEXT);
        random_txt.setInputType(InputType.TYPE_CLASS_TEXT);

        name_title.setText(R.string.name_str);
        name_txt.setHint(R.string.name_hint);
        random_title.setText(R.string.random_str);
        random_txt.setHint(R.string.random_hint);

        reg_bt.setText(R.string.reg_txt);
        goto_log_bt.setText(R.string.reg_more_txt);

        reg_bt.setOnClickListener(this);
        goto_log_bt.setOnClickListener(this);


    }

    private boolean isRandomed = false;
    private int oldX, preX;
    private int rawTransactionX;
    private void init() {
        random_title.setOnClickListener(this);
        random_title.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                int x = (int) event.getX();
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        oldX = (int) event.getX();
                        preX = (int) event.getX();
                        rawTransactionX = (int)random_title.getTranslationX();
                        break;
                    case MotionEvent.ACTION_MOVE:
                        if (x > oldX) {
                            int deltaX = x - preX;
                            random_title.setTranslationX(random_title.getTranslationX() + deltaX);
                        }
                        break;
                    case MotionEvent.ACTION_UP:
                        if (x > (random_txt_width) / 2) {
                            randomGot();
                        } else {
                            random_title.setTranslationX(rawTransactionX);
                        }
                        break;
                }
                preX = x;
                return false;
            }
        });
    }

    // 获取验证码前状态
    private void randomRaw() {
        random_title.setTranslationX(0);
        random_txt.setHint(R.string.random_hint);
        random_txt.setPadding(random_title_width + 10, 0, 0, 0);
        isRandomed = false;
    }

    // 获取验证码后状态
    private void randomGot() {
        random_title.setTranslationX(rawTransactionX + random_txt_width - random_title_width);
        random_txt.setPadding(20, 0, 0, 0);
        random_txt.setHint(R.string.input_random);
        isRandomed = true;
    }


    private boolean hasMeasured = false;
    private int random_title_width, random_txt_width;
    private void measureView() {
        ViewTreeObserver observer = random_txt.getViewTreeObserver();
        observer.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            public boolean onPreDraw() {
                if (hasMeasured == false) {
                    random_title_width = random_title.getMeasuredWidth();
                    random_txt_width   = random_txt.getMeasuredWidth();
                    //获取到宽度和高度后，可用于计算
                    hasMeasured = true;
                }
                return true;
            }
        });
    }

    private <T> T $(View view, int resId) {
        return (T) view.findViewById(resId);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.load_bt:

                break;
            case R.id.more_bt:
                jumpToRegView();
                break;

            case R.id.item_title:
                if (isRandomed) {
                    randomRaw();
                }
                break;

        }
    }

    // 跳转到登录界面
    private void jumpToRegView() {
//        offAnimator.start();
        if (listener != null) {
            listener.onJumpToLogFrag();
        }
    }

    public interface RegInfoListener {
        void onJumpToLogFrag();
    }

    public void setListener(RegInfoListener listener) {
        this.listener = listener;
    }
}
