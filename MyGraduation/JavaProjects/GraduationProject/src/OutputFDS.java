import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

import org.omg.PortableServer.ServantActivator;

public class OutputFDS {

	private static Scanner in = new Scanner(System.in);
	
	public static void main(String[] args) {
		try { // 防止文件建立或读取失败，用catch捕捉错误并打印，也可以throw
			System.out.println("Input file_name:");
			String fileName = in.next();
			
			// 输入输出起止时间
			System.out.println("Input start end time:");
			int start = in.nextInt();
			int end = in.nextInt();
			
			// 输入z的高度
			System.out.println("Input Z level:");
			int z_levels = in.nextInt();
			
			/* 写入Txt文件 */
			File writename = new File("output.vbs"); // 相对路径，如果没有则要建立一个新的output。txt文件
			writename.createNewFile(); // 创建新文件
			BufferedWriter out = new BufferedWriter(new FileWriter(writename));
			
			for (int z_level = 0; z_level < z_levels; z_level++) {
				for (int time = start; time <= end; time++) {
					out.write("createobject(\"wscript.shell\").run \"fds2ascii.exe\",9\r\n"); // \r\n即为换行
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
					out.flush(); // 把缓存区内容压入文件
				}
			}
			
			out.close(); // 最后记得关闭文件
			

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	private static void writeTxt(String str, BufferedWriter out) throws IOException {
		out.write("wscript.sleep 100\r\n"); 
		out.write("ws.sendkeys \"" + str + "\"\r\n"); 
		out.write("ws.sendkeys \"{ENTER}\"\r\n");
		out.flush(); // 把缓存区内容压入文件
	}

}
