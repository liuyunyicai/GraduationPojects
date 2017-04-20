package hust.mallguide.services;


import hust.mallguide.R;

/**
 * Created by admin on 2015/11/9.
 */

/* 相关服务的信息*/
public class MyServiceItem {
    private boolean isHead; // 是否是某一项的头部

    public static final int LIFE_SERVICE = 1;  // 生活服务
    public static final int SAFE_SERVICE = 2;  // 安全服务

    private String itemName; // 服务名
    private int itemIconRes; // 图标Icon资源
    private int itemType;    // 服务所代表的类型

    public static final int SERVICE_ONE = 0;
    public static final int SERVICE_TWO = 1;
    public static final int SERVICE_THR = 2;
    public static final int SERVICE_FOU = 3;
    public static final int SERVICE_FIV = 4;
    public static final int SERVICE_SIX = 5;
    public static final int SERVICE_SEV = 6;
    public static final int SERVICE_EIG = 7;
    public static final int SERVICE_NIN = 8;

    // 两个服务名数组
    private String[] mServices_name = {"订制购物路线", "收藏商品商店",
            "快寻车位导航", "公共WIFI共享",
            "在线提前预约", "事故安全提醒",
            "紧急疏散导航", "自助寻人寻物",
            "智能地理围栏", } ;
    private int[] icon_resIds = {R.mipmap.service1_icon ,
            R.mipmap.service2_icon ,
            R.mipmap.service3_icon ,
            R.mipmap.service4_icon ,
            R.mipmap.service5_icon ,
            R.mipmap.service6_icon ,
            R.mipmap.service7_icon ,
            R.mipmap.service8_icon ,
            R.mipmap.service9_icon ,
    };

    public MyServiceItem(int item_Numth, int itemType, boolean isHead) {
        String txt1 = mServices_name[item_Numth];
        int txt2 = icon_resIds[item_Numth];
        this.itemName = txt1;
        this.itemIconRes = txt2;
        this.itemType = itemType;
        this.isHead = isHead;
    }

    public MyServiceItem(String itemName, int itemIconRes, int itemType) {
        this(itemName, itemIconRes, itemType, false);
    }

    public MyServiceItem(String itemName, int itemIconRes, int itemType, boolean isHead) {
        this.itemName = itemName;
        this.itemIconRes = itemIconRes;
        this.itemType = itemType;
        this.isHead = isHead;

    }

    public boolean isHead() {
        return isHead;
    }

    public void setIsHead(boolean isHead) {
        this.isHead = isHead;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getItemIconRes() {
        return itemIconRes;
    }

    public void setItemIconRes(int itemIconRes) {
        this.itemIconRes = itemIconRes;
    }

    public int getItemType() {
        return itemType;
    }

    public void setItemType(int itemType) {
        this.itemType = itemType;
    }

}
