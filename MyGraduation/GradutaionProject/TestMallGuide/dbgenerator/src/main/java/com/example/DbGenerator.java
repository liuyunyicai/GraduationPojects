package com.example;

import de.greenrobot.daogenerator.DaoGenerator;
import de.greenrobot.daogenerator.Entity;
import de.greenrobot.daogenerator.Schema;

public class DbGenerator {

    private final static String TABLE_GRID_INFO = "GridInfo";
    private final static String GRID_ID = "grid_id";
    private final static String GRID_X = "grid_x";
    private final static String GRID_Y = "grid_y";
    private final static String GRID_Z = "grid_z";
    private final static String GRID_TYPE = "grid_type";
    private final static String GRID_ISFREE = "grid_isfree";
    private final static String GRID_TEMPERATURE = "grid_temperature";
    private final static String GRID_SMOKE = "grid_smoke";
    private final static String GRID_O2 = "grid_O2";
    private final static String GRID_CO = "grid_CO";
    private final static String GRID_CO2 = "grid_CO2";
    private final static String GRID_PEOPLENUM = "grid_peoplenum";

    private final static String TABLE_ROUTE_INFO = "ZoneInfo";
    private final static String ZONE_STEP = "zone_step";
    private final static String ZONE_STEP_TYPE = "zone_step_type";


    public static void main(String[] args) throws Exception {
        Schema schema = new Schema(1, "fire_db");
        schema.enableKeepSectionsByDefault();

        DbGenerator dbGenerator = new DbGenerator();
        dbGenerator.addGridTables(schema);
        dbGenerator.addZoneTables(schema);

        new DaoGenerator().generateAll(schema, "./app/src/main/java-gen");
    }

    private void addGridTables(Schema schema) {
        Entity entity = schema.addEntity(TABLE_GRID_INFO);

        entity.addLongProperty(GRID_ID).primaryKey().autoincrement().unique().notNull();
        entity.addIntProperty(GRID_X).notNull();
        entity.addIntProperty(GRID_Y).notNull();
        entity.addIntProperty(GRID_Z).notNull();
        entity.addIntProperty(GRID_TYPE).notNull();
        entity.addIntProperty(GRID_ISFREE).notNull();
        entity.addDoubleProperty(GRID_TEMPERATURE).notNull();
        entity.addDoubleProperty(GRID_SMOKE).notNull();
        entity.addDoubleProperty(GRID_O2).notNull();
        entity.addDoubleProperty(GRID_CO).notNull();
        entity.addDoubleProperty(GRID_CO2).notNull();
        entity.addIntProperty(GRID_PEOPLENUM).notNull();
    }

    private void addZoneTables(Schema schema) {
        Entity entity = schema.addEntity(TABLE_ROUTE_INFO);

        entity.addLongProperty(ZONE_STEP).primaryKey().autoincrement().unique().notNull();
        entity.addIntProperty(GRID_X).notNull();
        entity.addIntProperty(GRID_Y).notNull();
        entity.addIntProperty(GRID_Z).notNull();
        entity.addIntProperty(ZONE_STEP_TYPE).notNull();
    }
}
