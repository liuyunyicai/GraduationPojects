for i = 101 : 150
    disp('createobject("wscript.shell").run "fds2ascii.exe",9');
    disp('wscript.sleep 100');
    disp('set ws=wscript.createobject("wscript.shell")');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "test"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "2"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "1"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "z"');
    disp('ws.sendkeys "{ENTER}"');
   
    disp('wscript.sleep 100');
    fprintf('ws.sendkeys "%d %d 1"\n', i - 1, i);
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "5"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "1"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "2"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "3"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "4"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    disp('ws.sendkeys "5"');
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 100');
    fprintf('ws.sendkeys "Test%d_%d_Data.txt"\n', i - 1, i);
    disp('ws.sendkeys "{ENTER}"');
    
    disp('wscript.sleep 1000');
    disp('createobject("wscript.shell").run "cmd.exe /c taskkill /im notepad.exe /F",0');
    fprintf('\n');
end




