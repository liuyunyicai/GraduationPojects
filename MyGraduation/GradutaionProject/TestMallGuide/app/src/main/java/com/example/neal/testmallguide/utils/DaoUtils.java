package com.example.neal.testmallguide.utils;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import fire_db.DaoMaster;
import fire_db.DaoSession;


/**
 * Created by admin on 2016/4/8.
 */
public class DaoUtils {
    private DaoMaster.OpenHelper openHelper;
    private DaoSession daoSession;
    private static final String DB_NAME = "fire_db";


    private DaoUtils(Context context) {
        openHelper = new MyDaoOpenHelper(context, DB_NAME, null);
        SQLiteDatabase db = openHelper.getWritableDatabase();
        DaoMaster daoMaster = new DaoMaster(db);
        daoSession = daoMaster.newSession();
    }

    private static volatile DaoUtils instance = null;

    public static DaoUtils getInstance(Context context) {
        if (instance == null) {
            synchronized (DaoUtils.class) {
                if (instance == null) {
                    instance = new DaoUtils(context.getApplicationContext());
                }
            }
        }
        return instance;
    }

    public DaoMaster.OpenHelper getOpenHelper() {
        return openHelper;
    }

    public DaoSession getDaoSession() {
        return daoSession;
    }

}
