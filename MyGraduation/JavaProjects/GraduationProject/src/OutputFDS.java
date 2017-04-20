import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

import org.omg.PortableServer.ServantActivator;

public class OutputFDS {

	private static Scanner in = new Scanner(System.in);
	
	public static void main(String[] args) {
		try { // ��ֹ�ļ��������ȡʧ�ܣ���catch��׽���󲢴�ӡ��Ҳ����throw
			System.out.println("Input file_name:");
			String fileName = in.next();
			
			// ���������ֹʱ��
			System.out.println("Input start end time:");
			int start = in.nextInt();
			int end = in.nextInt();
			
			// ����z�ĸ߶�
			System.out.println("Input Z level:");
			int z_levels = in.nextInt();
			
			/* д��Txt�ļ� */
			File writename = new File("output.vbs"); // ���·�������û����Ҫ����һ���µ�output��txt�ļ�
			writename.createNewFile(); // �������ļ�
			BufferedWriter out = new BufferedWriter(new FileWriter(writename));
			
			for (int z_level = 0; z_level < z_levels; z_level++) {
				for (int time = start; time <= end; time++) {
					out.write("createobject(\"wscript.shell\").run \"fds2ascii.exe\",9\r\n"); // \r\n��Ϊ����
					out.write("wscript.sleep 500\r\n"); 
					out.write("set ws=wscript.createobject(\"wscript.shell\")\r\n"); 
					
					writeTxt(fileName, out);
					writeTxt("2", out);
					writeTxt("1", out);
					writeTxt("z", out);
					writeTxt("" + (time - 1) + " " + (time) + " " + z_levels * 2, out);
					writeTxt("5", out);
					for (int i = 0; i < 5; i++) {
						writeTxt("" + (z_level + 6 * i + 1), out);
					}
					writeTxt("Floor" + (z_level + 1) + "_" + (time - 1) + "_" + (time) + "_Data.txt", out);
					out.write("wscript.sleep 500\r\n");
					out.write("\r\n");
					out.flush(); // �ѻ���������ѹ���ļ�
				}
			}
			
			out.close(); // ���ǵùر��ļ�
			

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	private static void writeTxt(String str, BufferedWriter out) throws IOException {
		out.write("wscript.sleep 100\r\n"); 
		out.write("ws.sendkeys \"" + str + "\"\r\n"); 
		out.write("ws.sendkeys \"{ENTER}\"\r\n");
		out.flush(); // �ѻ���������ѹ���ļ�
	}

}