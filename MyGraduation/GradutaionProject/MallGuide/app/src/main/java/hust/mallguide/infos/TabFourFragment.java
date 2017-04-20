package hust.mallguide.infos;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import hust.mallguide.R;

/**
 * Created by admin on 2016/3/24.
 */
public class TabFourFragment extends Fragment implements View.OnClickListener{
    private String FileUrl = "http://localhost/TransferServer/files/";

    private View view;
    private Button testBt;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.tabfour_layout, container, false);

        initView();

        return view;
    }

    private void initView() {
        testBt = $(R.id.testBt);
        testBt.setOnClickListener(this);
    }

    private <T> T $(View view, int resId) {
        return (T) view.findViewById(resId);
    }

    private <T> T $(int resId) {
        return (T) view.findViewById(resId);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.testBt:


                break;
        }
    }
}
