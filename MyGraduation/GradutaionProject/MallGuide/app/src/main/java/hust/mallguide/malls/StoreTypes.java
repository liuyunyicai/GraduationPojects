package hust.mallguide.malls;

/**
 * Created by admin on 2016/5/30.
 */
// 商店的类型
public class StoreTypes {
    private int type_id;
    private String type_name;
    private String type_icon;
    private String type_detail;

    public StoreTypes() {}

    public StoreTypes(int type_id, String type_name, String type_icon, String type_detail) {
        this.type_id = type_id;
        this.type_name = type_name;
        this.type_icon = type_icon;
        this.type_detail = type_detail;
    }

    public String getType_detail() {
        return type_detail;
    }

    public void setType_detail(String type_detail) {
        this.type_detail = type_detail;
    }

    public String getType_icon() {
        return type_icon;
    }

    public void setType_icon(String type_icon) {
        this.type_icon = type_icon;
    }

    public int getType_id() {
        return type_id;
    }

    public void setType_id(int type_id) {
        this.type_id = type_id;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
    }
}
