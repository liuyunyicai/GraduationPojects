package hust.mallguide.guides;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import com.ls.widgets.map.MapWidget;
import com.ls.widgets.map.events.MapTouchedEvent;
import com.ls.widgets.map.interfaces.Layer;
import com.ls.widgets.map.interfaces.MapEventsListener;
import com.ls.widgets.map.interfaces.OnMapDoubleTapListener;
import com.ls.widgets.map.model.MapLayer;
import com.ls.widgets.map.model.MapLine;
import com.ls.widgets.map.model.MapObject;
import com.ls.widgets.map.utils.PivotFactory;

import java.util.ArrayList;
import java.util.List;

import hust.mallguide.MainActivity;
import hust.mallguide.R;
import hust.mallguide.utils.LogUtils;
import hust.mallguide.utils.ToastUtils;
import hust.mallguide.utils.dao_utils.DaoUtils;
import mydb.DaoSession;
import mydb.WifiRecord;
import mydb.WifiRecordDao;

/**
 * Created by admin on 2016/6/7.
 */
public class MapFragment extends Fragment {

    private View view;

    public static final String MAP_PATH = "MAP_PATH";
    private String map_path;

    public static final int MAP_ID = 1;
    private static final long LAYER_ID = 5;

    private MapLayer layer;
    private MapWidget mapWidget;

    private int curr_mapId = 0;
    private int curr_lineId = 0;

    private WifiManager wifiManager;

    private DaoUtils daoUtils;

    private boolean isDoubleClick = false;

    private boolean isLoaded = false;

    boolean isTest = false;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.map_layout, container, false);

        Bundle data = getArguments();
        map_path = data.getString(MAP_PATH);

        if (map_path.equals("map_1"))
            isTest = true;

        init(savedInstanceState);
        return view;
    }

    private void init(Bundle savedInstanceState) {
        daoUtils = DaoUtils.getInstance(getActivity());

        final int initialZoomLevel = 11;

        mapWidget = new MapWidget(savedInstanceState, getActivity(), map_path, initialZoomLevel);
        mapWidget.setId(MAP_ID);

        RelativeLayout layout = (RelativeLayout) view.findViewById(R.id.mainLayout);
        layout.addView(mapWidget);

        mapWidget.getConfig().setFlingEnabled(true);
        mapWidget.getConfig().setPinchZoomEnabled(true);
        mapWidget.getConfig().setMapCenteringEnabled(true);

        mapWidget.setMaxZoomLevel(12);
        mapWidget.setUseSoftwareZoom(true);
        mapWidget.setZoomButtonsVisible(true);
        mapWidget.setSaveEnabled(true);
//        mapWidget.setBackgroundColor(Color.GREEN);
        mapWidget.setBackgroundResource(R.color.color_bg);

        // 设置长按响应
        mapWidget.setOnLongClickListener(new View.OnLongClickListener() {

            @Override
            public boolean onLongClick(View v) {

                if (listener != null) {
                    listener.cancelDoubleClicked();
                }

                onLongClickHandle();
                return true;
            }
        });


        // 重写onTouch响应
        mapWidget.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View arg0, MotionEvent arg1) {
                return false;
            }
        });

        // 设置双击响应
        mapWidget.setOnDoubleTapListener(new OnMapDoubleTapListener() {
            @Override
            public boolean onDoubleTap(MapWidget v, MapTouchedEvent event) {
                onDoubleClick(v, event);
                return true;
            }
        });

        // 添加地图事件监听Listener
        mapWidget.addMapEventsListener(new MapEventsListener() {
            @Override
            public void onPreZoomOut() {

            }

            @Override
            public void onPreZoomIn() {

            }

            @Override
            public void onPostZoomOut() {
            }

            @Override
            public void onPostZoomIn() {

            }
        });

        // 初始化界面行的节点
//        initObjects();
        if (isTest)
            initFireControls();
//        addLine();
    }

    // 长按响应函数
    private void onLongClickHandle() {
        showNotification();
    }

    // 显示通知
    private void showNotification() {
        Context context = getActivity();
        // 获取NotificationManager
        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        Notification.Builder builder = new Notification.Builder(context);

        Intent notiIntent = new Intent(context, MainActivity.class);
        notiIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        fireNotification();
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, notiIntent, 0);
        builder.setSmallIcon(R.mipmap.fire)
                .setWhen(System.currentTimeMillis())
                .setContentTitle("火灾紧急通知")
                .setContentText(notiIntent.getAction())
                .setContentIntent(pendingIntent)
                .setAutoCancel(true) // 设置点击自动清除
                .setLights(Color.RED, 0 , 1) // 设置提示灯的颜色
                .setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_VIBRATE); // 设置震动

        manager.notify(0, builder.build());
    }

    // 火灾提醒
    private void fireNotification() {
        drawRegion();
        addLines();
    }

    // 双击相应函数
    private void onDoubleClick(MapWidget v, MapTouchedEvent event) {
        int pic_x = event.getMapX();
        int pic_y = event.getMapY();
//        addIndex(curr_mapId++, pic_x, pic_y);

        if (listener != null) {
            listener.doubleClicked();
        }
//        addWifiInfos(pic_x, pic_y);

    }

    // 获取当前位置的所有WIFI信息
    private void addWifiInfos(int pic_x, int pic_y) {
        // 获取每个位置的所有WIFI信息
        wifiManager = (WifiManager) getActivity().getSystemService(Context.WIFI_SERVICE);

        wifiManager.startScan();
        List<ScanResult> list = wifiManager.getScanResults();

        List<WifiRecord> records = new ArrayList<>();

        if (list != null) {
            LogUtils.i("list size : " + list.size());
            if (list != null) {
                for (ScanResult scanResult : list) {
                    // 计算信号强度
                    int nSigLevel = WifiManager.calculateSignalLevel(scanResult.level, 100);

                    // 存储成WifiRecord对象
                    records.add(new WifiRecord(WifiRecord._ID++, scanResult.SSID, scanResult.BSSID,
                            scanResult.level, nSigLevel, pic_x, pic_y, 7));

                    LogUtils.d("SSID:" + scanResult.SSID + "   BSSID:" + scanResult.BSSID + "    强度:"
                            + scanResult.level + "----" + nSigLevel);
                }
            }

        } else {
            LogUtils.d("list is null");
        }

        // 添加到数据库中存储
        DaoSession daoSession = daoUtils.getDaoSession();
        WifiRecordDao dao = daoSession.getWifiRecordDao();
        dao.insertInTx(records);

//        // 已连接信息
//        WifiInfo wifiInfo = wifiManager.getConnectionInfo();
//        int nWSig = WifiManager.calculateSignalLevel(wifiInfo.getRssi(), 100);
//        LogUtils.w("new SSID : " + wifiInfo.getSSID() + "   signal strength : " + wifiInfo.getRssi() + "   强度:" + nWSig);
    }

    // 测试消防图
    private void initFireControls() {
        addControls();

        addDoors();

        addElev();
//        addCurIndex();
//
//        addLines();

//        addTestPoints();
    }

    private void drawRegion() {
        if (layer != null)
            layer.setTestDrawRegion(true);
    }

    private void addTestPoints() {
        List<Point> datas1 = new ArrayList<>();
        datas1.add(new Point(2258 ,1420));
        datas1.add(new Point(431 ,791));
        datas1.add(new Point(1091 ,291));
        datas1.add(new Point(1978, 1100));
        datas1.add(new Point(1978 ,1100));
        datas1.add(new Point(1954 ,1124));
        datas1.add(new Point(1660 ,934));
        datas1.add(new Point(1779 ,745));
        datas1.add(new Point(1721 ,716));
        datas1.add(new Point(1820 ,579));
        datas1.add(new Point(1803 ,553));
        datas1.add(new Point(1858 ,460));

        for (Point data : datas1) {
            addIndex(curr_mapId++, data, R.mipmap.index);
        }
    }

    // 添加区域
    private void addLines() {
        List<Point> line_data = new ArrayList<>();
        line_data.add(new Point(1978, 1100));
        line_data.add(new Point(1978 ,1100));
        line_data.add(new Point(1954 ,1124));
        line_data.add(new Point(1660 ,934));
        line_data.add(new Point(1779 ,745));
        line_data.add(new Point(1721 ,716));
        line_data.add(new Point(1820 ,579));
        line_data.add(new Point(1803 ,553));
        line_data.add(new Point(1858 ,460));

        addLine(new MapLine(curr_lineId++, line_data));
    }

    // 显示用户当前位置
    public void setSelfLocation() {
        if (TabTwoFragment.selfLocPoint != null) {
            try {
                removeIndex(TabTwoFragment.SELF_LOC_OBJID);
            }catch (Exception e) {
            }
            // 添加用户当前位置
            addIndex(TabTwoFragment.SELF_LOC_OBJID, TabTwoFragment.selfLocPoint, R.mipmap.self_index);
        }
    }

    // 添加用户当前位置
    private void addCurIndex() {
        // 添加用户当前位置
        addIndex(curr_mapId++, new Point(1978 ,1100), R.mipmap.self_index);
    }

    // 添加电梯节点
    private void addElev() {
        List<Point> datas2 = new ArrayList<>();
        datas2.add(new Point(1858 ,460));
        datas2.add(new Point(1345 ,867));

        for (Point data : datas2) {
            addIndex(curr_mapId++, data, R.mipmap.elevator);
        }
    }

    // 添加出口节点
    private void addDoors() {
        List<Point> datas1 = new ArrayList<>();
        datas1.add(new Point(2258 ,1420));
        datas1.add(new Point(431 ,791));
        datas1.add(new Point(1091 ,291));

        for (Point data : datas1) {
            addIndex(curr_mapId++, data, R.mipmap.exit_icon);
        }
    }

    // 添加消防节点
    private void addControls() {
        List<Point> datas = new ArrayList<>();
        datas.add(new Point(1137 ,634));
        datas.add(new Point(901 ,879));
        datas.add(new Point(799 ,1100));
        datas.add(new Point(1876 ,856));
        datas.add(new Point(2503 ,1089));
        datas.add(new Point(2042 ,1246));
        datas.add(new Point(1607 ,946));

        for (Point data : datas) {
            addIndex(curr_mapId++, data, R.mipmap.protect_icon);
        }
    }


    private void initObjects() {
        List<Point> datas = new ArrayList<>();
        datas.add(new Point(1348, 794));
        datas.add(new Point(742 , 678));
//        datas.add(new int[] {1044, 420});
//        datas.add(new int[] {1352, 240});
//        datas.add(new int[] {2184, 1090});
//        datas.add(new int[] {2260, 660});
//        datas.add(new int[] {2510, 1061});
//        datas.add(new int[] {1764, 893});

        for (Point data : datas) {
            addIndex(curr_mapId++, data);
        }
    }

    // 添加Line连线
    private void addLine(MapLine line) {
        if (layer == null)
            // 创建图层
            layer = mapWidget.createLayer(LAYER_ID);
        layer.addMapLine(line);
    }

    private void addLine() {
        List<Point> datas = new ArrayList<>();
        datas.add(new Point(1348, 794));
        datas.add(new Point(742 , 678));

        addLine(new MapLine(curr_lineId++, datas));
    }

    // 添加位置节点
    private void addIndex(int mapId, int x, int y) {
        Drawable icon = getResources().getDrawable(R.mipmap.index);
        addIndex(mapId, x, y, icon);
    }

    private void addIndex(int mapId, Point point, int icon_res) {
        Drawable icon = getResources().getDrawable(icon_res);
        addIndex(mapId, point, icon);
    }

    private void addIndex (int mapId, int x, int y, Drawable icon) {
        addIndex(mapId, new Point(x, y), icon);
    }

    private void addIndex (int mapId, Point point) {
        Drawable icon = getResources().getDrawable(R.mipmap.index);
        addIndex(mapId, point, icon);
    }

    private void addIndex (int mapId, Point point, Drawable icon) {
        if (layer == null)
            // 创建图层
            layer = mapWidget.createLayer(LAYER_ID);
        // adding object to layer
        layer.addMapObject(new MapObject(mapId, icon, point,
                PivotFactory.createPivotPoint(icon, PivotFactory.PivotPosition.PIVOT_BOTTOM_CENTER), true, true));
    }

    private void removeIndex(int mapId) {
       if (layer != null) {
           layer.removeMapObject(mapId);
       }
    }


    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);

        MapWidget map = (MapWidget) getActivity().findViewById(MAP_ID);
        map.saveState(outState);
    }

    public boolean isDoubleClick() {
        return isDoubleClick;
    }

    public void setDoubleClick(boolean doubleClick) {
        isDoubleClick = doubleClick;
    }

    public interface MapEventListener {
        void doubleClicked();
        void cancelDoubleClicked();
    }

    private MapEventListener listener;

    public MapEventListener getListener() {
        return listener;
    }

    public void setListener(MapEventListener listener) {
        this.listener = listener;
    }

    public boolean isLoaded() {
        return isLoaded;
    }

    public void setLoaded(boolean loaded) {
        isLoaded = loaded;
    }
}
