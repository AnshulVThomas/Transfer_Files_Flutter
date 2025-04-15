import "package:flutter/material.dart";
import 'dart:io';
import 'package:flutter/services.dart';
import "package:permission_handler/permission_handler.dart";
import 'package:transfer_files/Connections/connections.dart';
import 'package:transfer_files/Connections/cLogs.dart';
import 'package:transfer_files/f_picker/f_picker.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
 static const MethodChannel serverChannel = MethodChannel('com.example.transfer_files/server');
  static const MethodChannel logChannel = MethodChannel('com.example.transfer_files/logs');

  bool isServerRunning = false;
  bool isClientRunning = false;
  List<String> localIPs = [];
  String? selectedIP;
  int port = 9999;

  @override
  void initState() {
    super.initState();
    _getLocalIPs();
    logChannel.setMethodCallHandler((call) async {
       
      if (call.method == "setActive"){

        // Active ab=Active(ip: call.arguments['ip'], port: call.arguments['port'], mode: call.arguments["mode"]);
       
        try {
Active ab = Active(
  ip: call.arguments['ip'],
  port: call.arguments['port'],
  mode: call.arguments['mode'],
);

  Active.addActive(ab);
  print("🔥🔥🔥🔥🔥🔥Active profiles: ${Active.getActive()}");

} catch (e, stack) {
  print("🔥🔥🔥🔥🔥🔥 Error in addActive: $e");
  print(stack);
}

      }else if(call.method == "log") {
       
      }
    });
  }

Future<void> requestStoragePermission() async {
  if (await Permission.manageExternalStorage.isGranted) {
    print("Permission already granted.");
    return;
  }

  var status = await Permission.manageExternalStorage.request();

  if (status.isGranted) {
    print("Permission granted.");
  } else {
    print("Permission denied.");
    openAppSettings(); // Open settings if denied
  }
}

  Future<void> _getLocalIPs() async {
    List<String> ipList = [];
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          ipList.add(addr.address);
        }
      }
    }
    setState(() {
      localIPs = ipList;
      if (localIPs.isNotEmpty) {
        selectedIP = localIPs.first;
      }
    });
  }

  Future<void> startServer() async {
    if (selectedIP == null) return;
    try {
       
       if (await Permission.manageExternalStorage.request().isGranted) {
    // Permission granted, start the server

 
      await serverChannel.invokeMethod('startServer', {'ip': selectedIP, 'port': port});
      setState(() {
        isServerRunning = true;
        CLogs.logs.add("Server started on $selectedIP:$port");
      });
       }
       else {
    CLogs.logs.add("Permission denied! Go to Settings > Apps > Your App > Permissions and enable 'Manage All Files'.");
  }
    } catch (e) {
      setState(() {
        CLogs.logs.add("Error: $e");
      });
    }
  }
   Future<void> startClient() async {
    if (selectedIP == null) return;
    try {
       
       if (await Permission.manageExternalStorage.request().isGranted) {
    // Permission granted, start the server
       List<String?> files =await f_picker().pick();
       if(files.isNotEmpty){
 
      await serverChannel.invokeMethod('startClient', {
        'ip': "192.168.80.179",
         'port': port, 
         "mode": "UPLOAD", 
         "filePath": files[0],
         });
       }else{
        setState(() {
        isClientRunning = false;
        CLogs.logs.add("Client failed to start");
      });
       }
      setState(() {
        isClientRunning = true;
        CLogs.logs.add("Client started on $selectedIP:$port");
      });
       }
       else {
    CLogs.logs.add("Permission denied! Go to Settings > Apps > Your App > Permissions and enable 'Manage All Files'.");
  }
    } catch (e) {
      setState(() {
       CLogs.logs.add("Error: $e");
      });
    }
  }

  Future<void> stopServer() async {
    try {
      await serverChannel.invokeMethod('stopServer');
      setState(() {
        isServerRunning = false;
       CLogs.logs.add("Server stopped.");
      });
    } catch (e) {
      setState(() {
       CLogs.logs.add("Error stopping server: $e");
      });
    }
  }
  Future<void> stopClient() async {
    try {
      await serverChannel.invokeMethod('stopClient');
      setState(() {
        isClientRunning = false;
        CLogs.logs.add("Client stopped.");
      });
    } catch (e) {
      setState(() {
        CLogs.logs.add("Error stopping server: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter TCP Server")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedIP,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedIP = newValue;
                  });
                },
                items: localIPs.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: isServerRunning ? stopServer : startServer,
              child: Text(isServerRunning ? "Stop Server" : "Start Server"),
            ),
             ElevatedButton(
              onPressed: isClientRunning ? stopClient : startClient,
              child: Text(isClientRunning ? "Stop Client" : "Start Client"),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: CLogs.logs.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(CLogs.logs[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}