package hust.mallguide.logreg;

import android.widget.EditText;

import hust.mallguide.utils.ViewUtils;

/**
 * Created by admin on 2016/4/8.
 */
// 用户信息
public class UserInfo {
    private String user_id;
    private String password;

    public UserInfo() {
        this.password = "1111";
    }

    public UserInfo(UserInfo info) {
        this.user_id = info.user_id;
        this.password = info.password;
    }

    public UserInfo(String user_id, String password) {
        this.user_id = user_id;
        this.password = password;
    }

    public UserInfo(EditText user_id_ed, EditText password_ed) {
        user_id = ViewUtils.getEditTxContent(user_id_ed);
        password = ViewUtils.getEditTxContent(password_ed);
    }

    public static final class Builder {
        private UserInfo info = new UserInfo();

        public Builder() {

        }

        public Builder userid(String user_id) {
            info.user_id = user_id;
            return this;
        }

        public Builder password(String password) {
            info.password = password;
            return this;
        }

        public UserInfo build() {
            return new UserInfo(info);
        }
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }
}
