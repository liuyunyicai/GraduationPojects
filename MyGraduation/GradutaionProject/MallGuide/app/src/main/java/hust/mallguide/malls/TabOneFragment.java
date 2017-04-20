package hust.mallguide.malls;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.orhanobut.logger.Logger;

import java.util.ArrayList;
import java.util.List;

import hust.mallguide.R;
import hust.mallguide.utils.ToastUtils;
import hust.mallguide.retrofit.OkHttpUtils;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by admin on 2016/3/24.
 */
public class TabOneFragment extends Fragment implements StoreStylesAdapter.OnItemClickLitener{

    private static final String MALL_STORETYPES_PATH = "MallStoreTypes.php";

    private View view;
    private RecyclerView guidesRecylerView;
    private StoreStylesAdapter adapter;
    private List<StoreStylesAdapter.UnitData> mDatas;

    private OkHttpUtils okHttpUtils;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.tabone_layout, container, false);

        okHttpUtils = OkHttpUtils.getInstance(getActivity());

        initView();
        return view;
    }

    private void initView() {
        guidesRecylerView = $(view, R.id.guidesRecylerView);
        initData();
    }

    // 初始化列表
    private void initStyles() {
        adapter = new StoreStylesAdapter(getActivity(), mDatas);
        guidesRecylerView.setLayoutManager(new StaggeredGridLayoutManager(2,
                StaggeredGridLayoutManager.VERTICAL));
        guidesRecylerView.setAdapter(adapter);
        // 设置item动画
        guidesRecylerView.setItemAnimator(new DefaultItemAnimator());

        initEvent();
    }

    private void initEvent() {
        adapter.setOnItemClickLitener(this);
    }

    @Override
    public void onItemClick(View view, int position) {
        ToastUtils.show(getActivity(), position + " click");
    }

    @Override
    public void onItemLongClick(View view, int position) {
        ToastUtils.show(getActivity(), position + "long click");
    }

    protected void initData() {
        mDatas = new ArrayList<>();
        // 请求数据
        MallServices services = okHttpUtils.create(MallServices.class);
        Observable<StoreTypes[]> obs= services.getStoreTypes(MALL_STORETYPES_PATH);

        obs.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<StoreTypes[]>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        Logger.e("initData Failed %s", e.toString());
                    }

                    @Override
                    public void onNext(StoreTypes[] storeTypes) {
                        Logger.w("types == " + storeTypes.length);

                        for (int i = 0; i < storeTypes.length; i++) {
                            mDatas.add(new StoreStylesAdapter.UnitData(storeTypes[i]));
                        }
                        initStyles();
                    }
                });
    }

    private <T> T $(View view, int resId) {
        return (T) view.findViewById(resId);
    }
}
