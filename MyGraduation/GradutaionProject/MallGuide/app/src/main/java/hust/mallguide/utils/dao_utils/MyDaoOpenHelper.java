package hust.mallguide.utils.dao_utils;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import mydb.DaoMaster;

/**
 * Created by admin on 2016/6/6.
 */
public class MyDaoOpenHelper extends DaoMaster.OpenHelper {
    public MyDaoOpenHelper(Context context, String name, SQLiteDatabase.CursorFactory factory) {
        super(context, name, factory);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
