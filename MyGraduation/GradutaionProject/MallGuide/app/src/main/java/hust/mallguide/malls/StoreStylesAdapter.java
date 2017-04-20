package hust.mallguide.malls;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.RecyclerView.ViewHolder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import hust.mallguide.R;
import hust.mallguide.retrofit.image.PicassoUtils;

class StoreStylesAdapter extends
        RecyclerView.Adapter<StoreStylesAdapter.MyViewHolder> {
    private static final String STORE_TYPES_PATH = "store_types"; // 商店类型icon存储的服务器地址

    // 用来存储数据
    private List<UnitData> mDatas;
    private LayoutInflater mInflater;

    // 每一个List高度
    private List<Integer> mHeights;

    private PicassoUtils picassoUtils;

    // 定义================= 事件监听 =============== //
    public interface OnItemClickLitener {
        void onItemClick(View view, int position);

        void onItemLongClick(View view, int position);
    }

    private OnItemClickLitener mOnItemClickLitener;

    public void setOnItemClickLitener(OnItemClickLitener mOnItemClickLitener) {
        this.mOnItemClickLitener = mOnItemClickLitener;
    }

    // 定义每个分类元数据
    public static class UnitData {
        private int type_id;
        private String type_icon;      // 对应图标的ID
        private String type_name;// 分类名称
        private String type_detail;
        private boolean isChecked = false; // 记录是否被选中
        static int checkedNum = 0; // 记录选中的数目

        public UnitData(int type_id, String type_icon, String type_name, String type_detail) {
            this.type_id = type_id;
            this.type_icon = type_icon;
            this.type_name = type_name;
            this.type_detail = type_detail;
        }

        public UnitData(StoreTypes storeTypes) {
            type_id = storeTypes.getType_id();
            type_icon = storeTypes.getType_icon();
            type_name = storeTypes.getType_name();
            type_detail = storeTypes.getType_detail();
        }
    }

    // 用以重定义空间
    class MyViewHolder extends ViewHolder {
        FrameLayout llayout;
        ImageView img;
        TextView tv;

        public MyViewHolder(View view) {
            super(view);
            tv = $(view, R.id.id_num);
            img = $(view, R.id.item_icon);
            llayout = $(view, R.id.view_continer);
        }
    }

    private <T> T $(View view, int resId) {
        return (T) view.findViewById(resId);
    }

    public StoreStylesAdapter(Context context, List<UnitData> datas) {
        mInflater = LayoutInflater.from(context);
        mDatas = datas;

        picassoUtils = PicassoUtils.getInstance(context);

        mHeights = new ArrayList<>();
        for (int i = 0; i < mDatas.size(); i++) {
            mHeights.add((int) (250 + Math.random() * 400));
        }
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        MyViewHolder holder = new MyViewHolder(mInflater.inflate(
                R.layout.item_staggered_home, parent, false));
        return holder;
    }

    @Override
    public void onBindViewHolder(final MyViewHolder holder, final int position) {
        final UnitData data = mDatas.get(position);

        LayoutParams lp = holder.llayout.getLayoutParams();
        lp.height = mHeights.get(position);

        holder.llayout.setLayoutParams(lp);
        holder.llayout.setBackgroundResource(data.isChecked ? R.color.color_item_press : R.drawable.item_bg);
        holder.tv.setText(data.type_name);

        // 加载图片
        picassoUtils.loadImage(data.type_icon, STORE_TYPES_PATH, holder.img);

        // 如果设置了回调，则设置点击事件
        if (mOnItemClickLitener != null) {
            holder.itemView.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = holder.getLayoutPosition();

                    if (data.isChecked) { // 如果已经选中，再次点击则会取消
                        cancelCheck(data, holder.llayout, pos);
                    } else if (data.checkedNum > 0){ // 如果当前系统已处于选中状态，则单击也会产生选中效果
                        doCheck(data, holder.llayout, pos);
                    } else { // 进行常规响应
                        mOnItemClickLitener.onItemClick(holder.itemView, pos);
                    }
                }
            });

            holder.itemView.setOnLongClickListener(new OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    int pos = holder.getLayoutPosition();
                    mOnItemClickLitener.onItemLongClick(holder.itemView, pos);

                    // 无论什么情况长按都是显示选中效果
                    if (!data.isChecked)
                        doCheck(data, holder.llayout, pos);
//                    removeData(pos);
                    return false;
                }
            });
        }
    }

    // 取消选中的item
    private void cancelCheck(final UnitData data, final View view, int pos) {
        data.isChecked = false;
        data.checkedNum--;
        view.setBackgroundResource(R.color.color_item_normal);
        notifyItemChanged(pos);
    }

    // 选中item
    private void doCheck(final UnitData data, final View view, int pos) {
        data.isChecked = true;
        data.checkedNum++;
        view.setBackgroundResource(R.color.color_item_press);
        notifyItemChanged(pos);
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    public void addData(int position, UnitData data) {
        mDatas.add(position, data);
        mHeights.add((int) (150 + Math.random() * 300));
        notifyItemInserted(position);
    }
    public void removeData(int position) {
        mDatas.remove(position);
        notifyItemRemoved(position);
    }

}