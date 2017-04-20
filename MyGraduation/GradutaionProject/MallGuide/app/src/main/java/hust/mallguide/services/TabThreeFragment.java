package hust.mallguide.services;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.LruCache;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.android.volley.toolbox.Volley;

import java.util.ArrayList;
import java.util.List;

import hust.mallguide.R;

/**
 * Created by admin on 2016/3/24.
 */
public class TabThreeFragment extends Fragment implements View.OnClickListener{
    private View view;

    private ListView myServiceListView;
    private List<MyServiceItem> dataLists = new ArrayList<>();

    private MyServiceAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.tabthree_layout, container, false);

        myServiceListView = (ListView) view.findViewById(R.id.myService_list);

        for (int i = MyServiceItem.SERVICE_ONE; i <= MyServiceItem.SERVICE_NIN; i++)
            dataLists.add(new MyServiceItem(i, i < MyServiceItem.SERVICE_SIX ? MyServiceItem.LIFE_SERVICE : MyServiceItem.SAFE_SERVICE,
                    (i == MyServiceItem.SERVICE_ONE) || (i == MyServiceItem.SERVICE_SIX)));

        adapter = new MyServiceAdapter(this.getActivity(), dataLists);
        myServiceListView.setDivider(null);
        myServiceListView.setAdapter(adapter);

        return view;
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }


    @Override
    public void onClick(View v) {

    }

}
