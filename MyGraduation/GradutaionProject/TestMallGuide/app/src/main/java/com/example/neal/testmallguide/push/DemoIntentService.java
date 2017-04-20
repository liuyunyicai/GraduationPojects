package com.example.neal.testmallguide.push;

import android.content.Context;
import android.util.Log;

import com.example.neal.testmallguide.utils.LogUtils;
import com.example.neal.testmallguide.utils.SharedUtils;
import com.igexin.sdk.GTIntentService;
import com.igexin.sdk.PushManager;
import com.igexin.sdk.message.GTCmdMessage;
import com.igexin.sdk.message.GTTransmitMessage;

/**
 * 继承 GTIntentService 接收来自个推的消息, 所有消息在线程中回调, 如果注册了该服务, 则务必要在 AndroidManifest中声明, 否则无法接受消息<br>
 * onReceiveMessageData 处理透传消息<br>
 * onReceiveClientId 接收 cid <br>
 * onReceiveOnlineState cid 离线上线通知 <br>
 * onReceiveCommandResult 各种事件处理回执 <br>
 */
public class DemoIntentService extends GTIntentService {
    public static final String FIRE_WARNING = "1";
    public static final String CANCEL_FIRE_WARNING = "0";


    public DemoIntentService() {

    }

    @Override
    public void onReceiveServicePid(Context context, int pid) {
    }

    @Override
    public void onReceiveMessageData(Context context, GTTransmitMessage msg) {
//        String appid = msg.getAppid();
//        String taskid = msg.getTaskId();
//        String messageid = msg.getMessageId();
        byte[] payload = msg.getPayload();
//        String pkg = msg.getPkgName();
//        String cid = msg.getClientId();

//        LogUtils.d("onReceiveMessageData -> " + "appid = " + appid + "\ntaskid = " + taskid + "\nmessageid = " + messageid + "\npkg = " + pkg
//                + "\ncid = " + cid);

        if (payload == null) {
            LogUtils.e("receiver payload = null");
        } else {
            String data = new String(payload);

            boolean value = false;
            if (data.equals(CANCEL_FIRE_WARNING)) {
                value = false;
            } else if (data.equals(FIRE_WARNING)) {
                value = true;
            }

            // 将数据保存至本地
            SharedUtils.getSharedUtils(context).put(new SharedUtils.UnitData<Boolean>(SharedUtils.ISFIRED, value));

            LogUtils.d("receiver payload = " + data);
        }

    }

    @Override
    public void onReceiveClientId(Context context, String clientid) {
        Log.e(TAG, "onReceiveClientId -> " + "clientid = " + clientid);
    }

    @Override
    public void onReceiveOnlineState(Context context, boolean online) {
    }

    @Override
    public void onReceiveCommandResult(Context context, GTCmdMessage cmdMessage) {
    }
}