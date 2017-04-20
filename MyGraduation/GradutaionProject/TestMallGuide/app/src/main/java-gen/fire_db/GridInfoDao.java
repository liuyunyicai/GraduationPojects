package fire_db;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;

import de.greenrobot.dao.AbstractDao;
import de.greenrobot.dao.Property;
import de.greenrobot.dao.internal.DaoConfig;

import fire_db.GridInfo;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.
/** 
 * DAO for table "GRID_INFO".
*/
public class GridInfoDao extends AbstractDao<GridInfo, Long> {

    public static final String TABLENAME = "GRID_INFO";

    /**
     * Properties of entity GridInfo.<br/>
     * Can be used for QueryBuilder and for referencing column names.
    */
    public static class Properties {
        public final static Property Grid_id = new Property(0, long.class, "grid_id", true, "GRID_ID");
        public final static Property Grid_x = new Property(1, int.class, "grid_x", false, "GRID_X");
        public final static Property Grid_y = new Property(2, int.class, "grid_y", false, "GRID_Y");
        public final static Property Grid_z = new Property(3, int.class, "grid_z", false, "GRID_Z");
        public final static Property Grid_type = new Property(4, int.class, "grid_type", false, "GRID_TYPE");
        public final static Property Grid_isfree = new Property(5, int.class, "grid_isfree", false, "GRID_ISFREE");
        public final static Property Grid_temperature = new Property(6, double.class, "grid_temperature", false, "GRID_TEMPERATURE");
        public final static Property Grid_smoke = new Property(7, double.class, "grid_smoke", false, "GRID_SMOKE");
        public final static Property Grid_O2 = new Property(8, double.class, "grid_O2", false, "GRID__O2");
        public final static Property Grid_CO = new Property(9, double.class, "grid_CO", false, "GRID__CO");
        public final static Property Grid_CO2 = new Property(10, double.class, "grid_CO2", false, "GRID__CO2");
        public final static Property Grid_peoplenum = new Property(11, int.class, "grid_peoplenum", false, "GRID_PEOPLENUM");
    };


    public GridInfoDao(DaoConfig config) {
        super(config);
    }
    
    public GridInfoDao(DaoConfig config, DaoSession daoSession) {
        super(config, daoSession);
    }

    /** Creates the underlying database table. */
    public static void createTable(SQLiteDatabase db, boolean ifNotExists) {
        String constraint = ifNotExists? "IF NOT EXISTS ": "";
        db.execSQL("CREATE TABLE " + constraint + "\"GRID_INFO\" (" + //
                "\"GRID_ID\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE ," + // 0: grid_id
                "\"GRID_X\" INTEGER NOT NULL ," + // 1: grid_x
                "\"GRID_Y\" INTEGER NOT NULL ," + // 2: grid_y
                "\"GRID_Z\" INTEGER NOT NULL ," + // 3: grid_z
                "\"GRID_TYPE\" INTEGER NOT NULL ," + // 4: grid_type
                "\"GRID_ISFREE\" INTEGER NOT NULL ," + // 5: grid_isfree
                "\"GRID_TEMPERATURE\" REAL NOT NULL ," + // 6: grid_temperature
                "\"GRID_SMOKE\" REAL NOT NULL ," + // 7: grid_smoke
                "\"GRID__O2\" REAL NOT NULL ," + // 8: grid_O2
                "\"GRID__CO\" REAL NOT NULL ," + // 9: grid_CO
                "\"GRID__CO2\" REAL NOT NULL ," + // 10: grid_CO2
                "\"GRID_PEOPLENUM\" INTEGER NOT NULL );"); // 11: grid_peoplenum
    }

    /** Drops the underlying database table. */
    public static void dropTable(SQLiteDatabase db, boolean ifExists) {
        String sql = "DROP TABLE " + (ifExists ? "IF EXISTS " : "") + "\"GRID_INFO\"";
        db.execSQL(sql);
    }

    /** @inheritdoc */
    @Override
    protected void bindValues(SQLiteStatement stmt, GridInfo entity) {
        stmt.clearBindings();
        stmt.bindLong(1, entity.getGrid_id());
        stmt.bindLong(2, entity.getGrid_x());
        stmt.bindLong(3, entity.getGrid_y());
        stmt.bindLong(4, entity.getGrid_z());
        stmt.bindLong(5, entity.getGrid_type());
        stmt.bindLong(6, entity.getGrid_isfree());
        stmt.bindDouble(7, entity.getGrid_temperature());
        stmt.bindDouble(8, entity.getGrid_smoke());
        stmt.bindDouble(9, entity.getGrid_O2());
        stmt.bindDouble(10, entity.getGrid_CO());
        stmt.bindDouble(11, entity.getGrid_CO2());
        stmt.bindLong(12, entity.getGrid_peoplenum());
    }

    /** @inheritdoc */
    @Override
    public Long readKey(Cursor cursor, int offset) {
        return cursor.getLong(offset + 0);
    }    

    /** @inheritdoc */
    @Override
    public GridInfo readEntity(Cursor cursor, int offset) {
        GridInfo entity = new GridInfo( //
            cursor.getLong(offset + 0), // grid_id
            cursor.getInt(offset + 1), // grid_x
            cursor.getInt(offset + 2), // grid_y
            cursor.getInt(offset + 3), // grid_z
            cursor.getInt(offset + 4), // grid_type
            cursor.getInt(offset + 5), // grid_isfree
            cursor.getDouble(offset + 6), // grid_temperature
            cursor.getDouble(offset + 7), // grid_smoke
            cursor.getDouble(offset + 8), // grid_O2
            cursor.getDouble(offset + 9), // grid_CO
            cursor.getDouble(offset + 10), // grid_CO2
            cursor.getInt(offset + 11) // grid_peoplenum
        );
        return entity;
    }
     
    /** @inheritdoc */
    @Override
    public void readEntity(Cursor cursor, GridInfo entity, int offset) {
        entity.setGrid_id(cursor.getLong(offset + 0));
        entity.setGrid_x(cursor.getInt(offset + 1));
        entity.setGrid_y(cursor.getInt(offset + 2));
        entity.setGrid_z(cursor.getInt(offset + 3));
        entity.setGrid_type(cursor.getInt(offset + 4));
        entity.setGrid_isfree(cursor.getInt(offset + 5));
        entity.setGrid_temperature(cursor.getDouble(offset + 6));
        entity.setGrid_smoke(cursor.getDouble(offset + 7));
        entity.setGrid_O2(cursor.getDouble(offset + 8));
        entity.setGrid_CO(cursor.getDouble(offset + 9));
        entity.setGrid_CO2(cursor.getDouble(offset + 10));
        entity.setGrid_peoplenum(cursor.getInt(offset + 11));
     }
    
    /** @inheritdoc */
    @Override
    protected Long updateKeyAfterInsert(GridInfo entity, long rowId) {
        entity.setGrid_id(rowId);
        return rowId;
    }
    
    /** @inheritdoc */
    @Override
    public Long getKey(GridInfo entity) {
        if(entity != null) {
            return entity.getGrid_id();
        } else {
            return null;
        }
    }

    /** @inheritdoc */
    @Override    
    protected boolean isEntityUpdateable() {
        return true;
    }
    
}
