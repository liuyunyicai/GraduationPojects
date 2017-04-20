package hust.mallguide.httputils.log;

import android.util.Log;

import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;
import com.squareup.okhttp.ResponseBody;

import java.io.IOException;

import hust.mallguide.utils.LogUtils;
import okio.Buffer;

/**
 * Created by admin on 2016/3/30.
 */
public class LoggingInterceptor implements Interceptor {
    @Override
    public Response intercept(Chain chain) throws IOException {
        // 获得Request
        Request request = chain.request();

        long t1 = System.nanoTime();
        Log.i("LOG_TAG", String.format("Sending request %s on %s%n%s",
                request.url(), chain.connection(), request.headers()));
        LogUtils.w("Request Body:" + bodyToString(request));

        // 执行request
        Response response = chain.proceed(request);
        long t2 = System.nanoTime();
        Log.i("LOG_TAG", String.format("Received response for %s in %.1fms%n%s",
                response.request().url(), (t2 - t1) / 1e6d, response.headers()));
//        LogUtils.w("Response Body:" + responseToString(response));
        return response;
    }

    // 将RequestBody转化成String
    private String bodyToString(final Request request){
        try {
            final Request copy = request.newBuilder().build();
            final Buffer buffer = new Buffer();
            final RequestBody body = copy.body();
            if (body != null)
                body.writeTo(buffer);
            return buffer.readUtf8();
        } catch (final IOException e) {
            return "did not work";
        }
    }

    // 将ResponseBody转化为String
    private String responseToString(final Response response) {
        String bodyStr = "";
        try {
            // 可以对返回结果进行重写
            final Response copy = response.newBuilder().build();
            final ResponseBody body = copy.body();
            if (body != null)
                bodyStr = body.string();
        } catch (Exception e) {
            LogUtils.e("responseToString Error : " + e.toString());
        }
        return bodyStr;
    }
}
