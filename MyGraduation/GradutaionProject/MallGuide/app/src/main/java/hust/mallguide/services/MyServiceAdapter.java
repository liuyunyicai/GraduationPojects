package hust.mallguide.services;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import hust.mallguide.R;


/**
 * Created by admin on 2015/11/9.
 */
public class MyServiceAdapter extends BaseAdapter {

    private LayoutInflater inflater;

    private String[] types_name = {"生活服务:", "安全服务:"};

    private List<MyServiceItem> dataLists;

    private ViewHolder holder;

    public MyServiceAdapter(Context context, List<MyServiceItem> dataLists) {
        inflater = LayoutInflater.from(context);
        this.dataLists = dataLists;
    }

    @Override
    public int getCount() {
        if (dataLists != null)
            return dataLists.size();
        return 0;
    }

    @Override
    public Object getItem(int position) {
        if (dataLists != null)
            return dataLists.get(position);
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.myservice_item_layout, parent, false);
            holder = new ViewHolder();
            holder.myservice_head = (TextView) convertView.findViewById(R.id.myservice_head);
            holder.myservice_icon = (ImageView) convertView.findViewById(R.id.myservice_icon);
            holder.myservice_name = (TextView) convertView.findViewById(R.id.myservice_name);

            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        if (position < dataLists.size()) {
            MyServiceItem item = dataLists.get(position);
            holder.myservice_head.setText(types_name[item.getItemType() - 1]);
            holder.myservice_head.setVisibility(item.isHead() ? View.VISIBLE : View.GONE);

            holder.myservice_name.setText(item.getItemName());
            holder.myservice_icon.setImageResource(item.getItemIconRes());


        }
        return convertView;
    }

    static class ViewHolder {
        TextView myservice_head;
        ImageView myservice_icon;
        TextView myservice_name;
    }
}
