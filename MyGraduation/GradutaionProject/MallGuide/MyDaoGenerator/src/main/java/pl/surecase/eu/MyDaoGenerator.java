package pl.surecase.eu;

import java.util.ArrayList;

import de.greenrobot.daogenerator.DaoGenerator;
import de.greenrobot.daogenerator.Entity;
import de.greenrobot.daogenerator.Property;
import de.greenrobot.daogenerator.Schema;

public class MyDaoGenerator {

    private Entity wifiRecord;

    private ArrayList<OneClass> ones = new ArrayList<>();
    private ArrayList<OneClass> manys = new ArrayList<>();

    public static void main(String args[]) throws Exception {
        Schema schema = new Schema(1, "mydb");
        // 保证自定义的代码不会被覆盖
        schema.enableKeepSectionsByDefault();
        // 生成相应的ContentProvider支持
        // entity.addContentProvider();
        MyDaoGenerator generator = new MyDaoGenerator();
        // 添加所有表
        generator.addTables(schema);
        // 添加表中字段
        generator.addWifiRecordTable(generator.wifiRecord);
        // 添加外键映射关系
//        generator.addToOne();
//        generator.addToMany();

        new DaoGenerator().generateAll(schema, "./app/src/main/java-gen");
    }

    // 添加表
    private void addTables(Schema schema) {
        wifiRecord = schema.addEntity(DbValues.TABLE_WIFI_RECORD);
    }

    // 统一添加一对一关系
    private void addToOne() {
        for (OneClass one : ones) {
            one.handler.addToOne(one.target, one.property);
        }
        ones.clear();
    }

    // 添加一对多关系
    private void addToMany() {
        for (OneClass many : manys) {
            many.handler.addToMany(many.target, many.property).setName(many.name);
        }
        manys.clear();
    }

    // 外键映射关系
    private static class OneClass {
        Entity handler;
        Entity target;
        Property property;
        String name;

        public OneClass(Entity handler, Entity target, Property property) {
            this.handler = handler;
            this.target = target;
            this.property = property;
        }

        public OneClass(Entity handler, Entity target, Property property, String name) {
            this.handler = handler;
            this.target = target;
            this.property = property;
            this.name = name;
        }
    }

    // 添加Wifi信息记录表
    private void addWifiRecordTable(Entity entity) {
        entity.addLongProperty(DbValues._ID).primaryKey().unique().notNull();
        entity.addStringProperty(DbValues.SSID).notNull();
        entity.addStringProperty(DbValues.BSSID).notNull();
        entity.addIntProperty(DbValues.LEVEL).notNull();
        entity.addIntProperty(DbValues.RSSI).notNull();
        entity.addIntProperty(DbValues.PIC_X).notNull();
        entity.addIntProperty(DbValues.PIC_Y).notNull();
        entity.addIntProperty(DbValues.FLOOR).notNull();
    }
}
