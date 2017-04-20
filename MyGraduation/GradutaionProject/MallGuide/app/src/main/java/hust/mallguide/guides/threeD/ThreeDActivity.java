package hust.mallguide.guides.threeD;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.Window;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import butterknife.BindView;
import butterknife.ButterKnife;
import hust.mallguide.R;
import hust.mallguide.guides.MapFragment;

public class ThreeDActivity extends AppCompatActivity {

    private ThreeDViewFragment mapFragment;

    @BindView(R.id.rgRight)
    RadioGroup rgRight;
    @BindView(R.id.rbRight1)
    RadioButton rbRight1;
    @BindView(R.id.rbRight2)
    RadioButton rbRight2;
    @BindView(R.id.rbRight3)
    RadioButton rbRight3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_three_d);

        initView();
    }

    private void initView() {
        ButterKnife.bind(this);

        mapFragment = new ThreeDViewFragment();
        getSupportFragmentManager().beginTransaction().replace(R.id.map_container, mapFragment).commit();

        initExtras();
    }

    private void initExtras() {
        rbRight1.setChecked(true);
        rbRight1.setText(R.string.threed_txt1);
        rbRight2.setText(R.string.threed_txt2);
        rbRight3.setText(R.string.threed_txt3);
        setMapDirection(true, false);

        rgRight.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.rbRight1:
                        setMapDirection(true, false);
                        break;
                    case R.id.rbRight2:
                        setMapDirection(false, true);
                        break;
                    case R.id.rbRight3:
                        setMapDirection(true, true);
                        break;
                }
            }
        });
    }

    private void setMapDirection(boolean isHorizontal, boolean isVertical) {
        if (mapFragment != null) {
            mapFragment.setHorizontal(isHorizontal);
            mapFragment.setVertical(isVertical);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (mapFragment != null)
            mapFragment.onTouchEvent(event);
        return super.onTouchEvent(event);
    }
}
