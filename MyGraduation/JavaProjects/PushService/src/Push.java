import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.gexin.rp.sdk.base.IPushResult;
import com.gexin.rp.sdk.base.impl.AppMessage;
import com.gexin.rp.sdk.http.IGtPush;
import com.gexin.rp.sdk.template.NotificationTemplate;

public class Push {
	//���峣��, appId��appKey��masterSecret ���ñ��ĵ� "�ڶ��� ��ȡ����ƾ֤ "�л�õ�Ӧ������
    private static String appId = "0TuVcNWVBL9JtwKKjDU1T";
    private static String appKey = "PcCQtMYYkW8orfsaggcOj3";
    private static String masterSecret = "7gC7s4HmAb7HxlXbCndDx1";
    private static String url = "http://sdk.open.api.igexin.com/apiex.htm";

    public static void main(String[] args) throws IOException {

        IGtPush push = new IGtPush(url, appKey, masterSecret);

        // ����"������Ӵ�֪ͨģ��"�������ñ��⡢���ݡ�����
        NotificationTemplate template = new NotificationTemplate();
        template.setAppId(appId);
        template.setAppkey(appKey);
        template.setTitle("�����¹�Ԥ��!");
        template.setText("������¥���л���Σ�գ��������ɢ·��������ɢ��");
        template.setIsRing(true);
		template.setIsVibrate(true);
		template.setIsClearable(true);
		// ���ô򿪵���ַ��ַ
		template.setTransmissionType(1);
		template.setTransmissionContent("0");
		
        List<String> appIds = new ArrayList<String>();
        appIds.add(appId);

        // ����"AppMessage"������Ϣ����������Ϣ����ģ�塢���͵�Ŀ��App�б����Ƿ�֧�����߷��͡��Լ�������Ϣ��Ч��(��λ����)
        AppMessage message = new AppMessage();
        message.setData(template);
        message.setAppIdList(appIds);
        message.setOffline(true);
        message.setOfflineExpireTime(1000 * 600);

        IPushResult ret = push.pushMessageToApp(message);
        System.out.println(ret.getResponse().toString());
    }

}