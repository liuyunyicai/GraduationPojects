import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.gexin.rp.sdk.base.IPushResult;
import com.gexin.rp.sdk.base.impl.AppMessage;
import com.gexin.rp.sdk.http.IGtPush;
import com.gexin.rp.sdk.template.NotificationTemplate;

public class Push {
	//定义常量, appId、appKey、masterSecret 采用本文档 "第二步 获取访问凭证 "中获得的应用配置
    private static String appId = "0TuVcNWVBL9JtwKKjDU1T";
    private static String appKey = "PcCQtMYYkW8orfsaggcOj3";
    private static String masterSecret = "7gC7s4HmAb7HxlXbCndDx1";
    private static String url = "http://sdk.open.api.igexin.com/apiex.htm";

    public static void main(String[] args) throws IOException {

        IGtPush push = new IGtPush(url, appKey, masterSecret);

        // 定义"点击链接打开通知模板"，并设置标题、内容、链接
        NotificationTemplate template = new NotificationTemplate();
        template.setAppId(appId);
        template.setAppkey(appKey);
        template.setTitle("火灾事故预警!");
        template.setText("您所在楼宇有火灾危险，请参照疏散路径快速疏散！");
        template.setIsRing(true);
		template.setIsVibrate(true);
		template.setIsClearable(true);
		// 设置打开的网址地址
		template.setTransmissionType(1);
		template.setTransmissionContent("1");
		
        List<String> appIds = new ArrayList<String>();
        appIds.add(appId);

        // 定义"AppMessage"类型消息对象，设置消息内容模板、发送的目标App列表、是否支持离线发送、以及离线消息有效期(单位毫秒)
        AppMessage message = new AppMessage();
        message.setData(template);
        message.setAppIdList(appIds);
        message.setOffline(true);
        message.setOfflineExpireTime(1000 * 600);

        IPushResult ret = push.pushMessageToApp(message);
        System.out.println(ret.getResponse().toString());
    }

}
