package hust.mallguide.httputils.request;

import android.content.SharedPreferences;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.Response;
import com.android.volley.toolbox.HttpHeaderParser;
import com.android.volley.toolbox.StringRequest;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import hust.mallguide.httputils.HttpUtils;

/**
 * Created by admin on 2016/2/29.
 */
// 能够获取及发送Cookie的Request封装
public class CookieStringRequest extends StringRequest {
    private Map<String, String> mHeaders = new HashMap<>();
    private SharedPreferences share;
    private Map<String, String> params;

    public CookieStringRequest(int method, String url, SharedPreferences share, Response.Listener<String> listener,
                               Response.ErrorListener errorListener) {
        super(method, url, listener, errorListener);
        this.share = share;
    }

    public CookieStringRequest(int method, String url, SharedPreferences share, Map<String, String> params,
                               Response.Listener<String> listener, Response.ErrorListener errorListener) {
        super(method, url, listener, errorListener);
        this.share = share;
        this.params = params;
    }

    @Override
    protected Map<String, String> getParams() throws AuthFailureError {
        if (params == null)
            params = new HashMap<>();
        return params;
    }

    // 拿到客户端发起的http请求的Header
    @Override
    public Map<String, String> getHeaders() throws AuthFailureError {
        setCookie();
        return mHeaders;
    }

    // 发送请求时，往Header中添加cookie，可以一并发送
    public void setCookie() throws AuthFailureError {
        if (share != null) {
            // 取出Cookie值
            String cookie = share.getString(HttpUtils.COOKIE, "");
            if (!cookie.equals(""))
                mHeaders.put("Cookie", cookie);
        }
    }

    // 解析获得的结果，保存Cookie
    @Override
    protected Response<String> parseNetworkResponse(NetworkResponse response) {
        String parsed;
        try {
            // 保存Cookie值
            String cookie = response.headers.get(HttpUtils.SET_COOKIE);
            if (cookie != null && (!cookie.equals(""))) {
                SharedPreferences.Editor editor = share.edit();
                editor.putString(HttpUtils.COOKIE, cookie);
                editor.commit();
            }
            parsed = new String(response.data, HttpHeaderParser.parseCharset(response.headers));

        } catch (UnsupportedEncodingException e) {
            parsed = new String(response.data);
        }
        return Response.success(parsed, HttpHeaderParser.parseCacheHeaders(response));
    }

}
