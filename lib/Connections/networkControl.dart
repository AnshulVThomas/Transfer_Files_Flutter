 import "package:permission_handler/permission_handler.dart";
 import 'package:flutter/services.dart';
import 'package:transfer_files/Connections/cLogs.dart';


 Future<bool> startServerRl( MethodChannel serverChannel ,String? selectedIP,int port) async {
    if (selectedIP == null) return false;
    try {
       
       if (await Permission.manageExternalStorage.request().isGranted) {
    // Permission granted, start the server

 
      await serverChannel.invokeMethod('startServer', {'ip': selectedIP, 'port': port});
     
      
        CLogs.logs.add("Server started on $selectedIP:$port");
         return true;
     
       }
       else {
       
    CLogs.logs.add("Permission denied! Go to Settings > Apps > Your App > Permissions and enable 'Manage All Files'.");
     return false;
  }
    } catch (e) {
        
        CLogs.logs.add("Error: $e");
        return false;
     
    }
  }