import "package:flutter/material.dart";
import 'dart:io';
import 'package:flutter/services.dart';
import "package:permission_handler/permission_handler.dart";

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
 static const MethodChannel serverChannel = MethodChannel('com.example.transfer_files/server');
  static const MethodChannel logChannel = MethodChannel('com.example.transfer_files/logs');

  List<String> logs = [];
  bool isServerRunning = false;
  List<String> localIPs = [];
  String? selectedIP;
  int port = 9999;

  @override
  void initState() {
    super.initState();
    _getLocalIPs();
    logChannel.setMethodCallHandler((call) async {
      if (call.method == "log") {
        setState(() {
          logs.add(call.arguments);
           if (logs.length > 10) { // Keep only the last 100 logs
            logs.removeAt(0);
          }
        });
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
        logs.add("Server started on $selectedIP:$port");
      });
       }
       else {
    logs.add("Permission denied! Go to Settings > Apps > Your App > Permissions and enable 'Manage All Files'.");
  }
    } catch (e) {
      setState(() {
        logs.add("Error: $e");
      });
    }
  }

  Future<void> stopServer() async {
    try {
      await serverChannel.invokeMethod('stopServer');
      setState(() {
        isServerRunning = false;
        logs.add("Server stopped.");
      });
    } catch (e) {
      setState(() {
        logs.add("Error stopping server: $e");
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
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(logs[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}