package fire_db;

// THIS CODE IS GENERATED BY greenDAO, EDIT ONLY INSIDE THE "KEEP"-SECTIONS

// KEEP INCLUDES - put your custom includes here
import com.example.neal.testmallguide.floorsview.route.RouteInfo;
// KEEP INCLUDES END
/**
 * Entity mapped to table "ZONE_INFO".
 */
public class ZoneInfo {

    private long zone_step;
    private int grid_x;
    private int grid_y;
    private int grid_z;
    private int zone_step_type;

    // KEEP FIELDS - put your custom fields here
    public static final int ROUTE_TYPE= 1;
    public static final int FIRE_TYPE= 2;
    public static final int CROWDED_TYPE= 3;
    public static final int DANGER_TYPE= 4;
    // KEEP FIELDS END

    public ZoneInfo() {
    }

    public ZoneInfo(long zone_step) {
        this.zone_step = zone_step;
    }

    public ZoneInfo(long zone_step, int grid_x, int grid_y, int grid_z, int zone_step_type) {
        this.zone_step = zone_step;
        this.grid_x = grid_x;
        this.grid_y = grid_y;
        this.grid_z = grid_z;
        this.zone_step_type = zone_step_type;
    }

    public long getZone_step() {
        return zone_step;
    }

    public void setZone_step(long zone_step) {
        this.zone_step = zone_step;
    }

    public int getGrid_x() {
        return grid_x;
    }

    public void setGrid_x(int grid_x) {
        this.grid_x = grid_x;
    }

    public int getGrid_y() {
        return grid_y;
    }

    public void setGrid_y(int grid_y) {
        this.grid_y = grid_y;
    }

    public int getGrid_z() {
        return grid_z;
    }

    public void setGrid_z(int grid_z) {
        this.grid_z = grid_z;
    }

    public int getZone_step_type() {
        return zone_step_type;
    }

    public void setZone_step_type(int zone_step_type) {
        this.zone_step_type = zone_step_type;
    }

    // KEEP METHODS - put your custom methods here
    public ZoneInfo(RouteInfo routeInfo, int type) {
        this.zone_step = routeInfo.getRoute_step();
        this.grid_x = routeInfo.getGrid_x();
        this.grid_y = routeInfo.getGrid_y();
        this.grid_z = routeInfo.getGrid_z();
        this.zone_step_type = type;
    }
    // KEEP METHODS END

}
