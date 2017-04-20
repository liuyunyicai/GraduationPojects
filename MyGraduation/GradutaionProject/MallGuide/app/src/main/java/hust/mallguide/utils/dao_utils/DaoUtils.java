package hust.mallguide.utils.dao_utils;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import mydb.DaoMaster;
import mydb.DaoSession;

/**
 * Created by admin on 2016/6/6.
 */
public class DaoUtils {
    private DaoMaster.OpenHelper openHelper;
    private DaoSession daoSession;

    private DaoUtils(Context context) {
        openHelper = new MyDaoOpenHelper(context, "mydb", null);
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
