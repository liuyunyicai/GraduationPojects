package hust.mallguide.httputils;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Message;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.Volley;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.OkUrlFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import hust.mallguide.defalutvalue.MValues;
import hust.mallguide.utils.LogUtils;
import hust.mallguide.httputils.request.CookieJsonRequest;
import hust.mallguide.httputils.request.CookieStringRequest;

/**
 * Created by admin on 2016/2/28.
 */
public class HttpUtils {
    private RequestQueue mRequestQueue;
    private Handler mHandler;

    public static final int GET_SUCCESS = 100;
    public static final int GET_FAILED = -100;
    public static final int GET_JSON_SUCCESS = 101;

    public static final String PROTOCOL_CHARSET = "utf-8";
    public static final String COOKIE = "cookie";
    public static final String SET_COOKIE = "Set-Cookie";
    /**
     * Content type for request.
     */
    public static final String PROTOCOL_CONTENT_TYPE =
            String.format("application/json; charset=%s", PROTOCOL_CHARSET);

    private SharedPreferences share;
    private static Context mContext;
    private static HttpUtils instance;

    private HttpUtils(Context context) {
        mContext = context.getApplicationContext();
        // 创建RequestQueue
        mRequestQueue = Volley.newRequestQueue(mContext, new OkHttpStack());
        share = mContext.getSharedPreferences(MValues.SHARED_NAME, Context.MODE_PRIVATE);
    }

    public static HttpUtils build(Context context) {
        if (instance == null) {
            instance = new HttpUtils(context);
        }
        return instance;
    }

    // 定义返回结果监听器(String类型)
    public static Response.Listener<String> getDefaultStringSuccessListener(final Handler handler) {
        return new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Message msg = handler.obtainMessage(GET_SUCCESS, response);
                handler.sendMessage(msg);
            }
        };
    }

    // 定义返回结果监听器(JSON类型)
    public static Response.Listener<JSONObject> getDefaultJSONSuccessListener(final Handler mHandler) {
        return new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                Message msg = mHandler.obtainMessage(GET_JSON_SUCCESS, response);
                mHandler.sendMessage(msg);
            }
        };
    }

    // 定义返回结果监听器(JSON类型)
    public static Response.Listener<String> getDefaultJSONPostSuccessListener(final Handler mHandler) {
        return new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                try {
                    Message msg = mHandler.obtainMessage(GET_JSON_SUCCESS, new JSONObject(response));
                    mHandler.sendMessage(msg);
                } catch (JSONException e) {
                    LogUtils.e("getDefaultJSONPostSuccessListener Error:" + e.toString());
                }
            }
        };
    }

    // 定义错误监听器
    public static Response.ErrorListener getDefaultErrorListener(final Handler mHandler) {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Message msg = mHandler.obtainMessage(GET_FAILED, error.toString());
                mHandler.sendMessage(msg);
            }
        };
    }


    //**************** 自定义HttpUrlStack ***************** //
    public class OkHttpStack extends HurlStack {
        private final OkUrlFactory okUrlFactory;

        public OkHttpStack() {
            this(new OkUrlFactory(new OkHttpClient()));
        }

        public OkHttpStack(OkUrlFactory okUrlFactory) {
            this.okUrlFactory = okUrlFactory;
        }

        @Override
        protected HttpURLConnection createConnection(URL url) throws IOException {
            return okUrlFactory.open(url);
        }
    }

    // String类型的GET
    public void getResponse(final String url, Response.Listener<String> resListener,
                            Response.ErrorListener errorListener) {
        // 创建Request
        CookieStringRequest request = new CookieStringRequest(Request.Method.GET,
                url, share, resListener, errorListener);
        // 将Requset添加到RequestQueue中
        mRequestQueue.add(request);
    }

    // 获得JSON类型数据
    public void getJsonResponse(final String url, final Map<String, String> params,
                                Response.Listener<JSONObject> jsonResListener, Response.ErrorListener errorListener) {
        CookieJsonRequest request = new CookieJsonRequest(Request.Method.GET,
                makeUrlHavingParams(url, params), share, jsonResListener, errorListener);
        mRequestQueue.add(request);
    }

    // post
    public void postResponse(final String url, final Map<String, String> params,
                             Response.Listener<String> resListener, Response.ErrorListener errorListener) {
        CookieStringRequest request = new CookieStringRequest(Request.Method.POST,
                url, share, params, resListener, errorListener);
        mRequestQueue.add(request);
    }

    //POST获得json数据
    public void postJsonResponse(final String url, final Map<String, String> params,
                                 Response.Listener<String> resListener, Response.ErrorListener errorListener) {
        CookieStringRequest request = new CookieStringRequest(Request.Method.POST,
                url, share, params, resListener, errorListener);
        mRequestQueue.add(request);
    }

    // 产生测试数据
    public Map<String, String> testGetParams() {
        Map<String, String> map = new HashMap<>();
        map.put("username", "张三");
        map.put("password", "admin");
        return map;
    }

    //
    public RequestQueue getRequestQueue() {
        return mRequestQueue;
    }

    // 为GET的URL添加参数
    public static String makeUrlHavingParams(String url, final Map<String, String> params) {
        url += "?";
        for (Map.Entry<String, String> param : params.entrySet()) {
            url += (param.getKey() + "=" + param.getValue() + "&");
        }
        url = url.substring(0, url.length() - 1);
        return url;
    }
}
