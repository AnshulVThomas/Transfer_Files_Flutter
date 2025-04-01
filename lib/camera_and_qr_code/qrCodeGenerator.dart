import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:transfer_files/camera_and_qr_code/qrCodeScanner.dart';
import 'package:transfer_files/permission_handle/perm.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final String host = "your.sftp.server";
  final int port = 22;
  final String username = "yourUsername";
  final String password = "yourPassword";
  final String filePath = "/path/to/file.txt";

  String qrData = "Generating QR...";

  @override
  void initState() {
    super.initState();
    generateSFTPQr();
  }

  Future<void> generateSFTPQr() async {
    try {
    

      setState(() {
        qrData = "sftp://$username:$password@$host:$port$filePath";
      });
    
 
    } catch (e) {
      setState(() {
        qrData = "Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Code for SFTP File")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20), // Add rounded edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: 20,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
              child: Center(
                child: qrData.startsWith("sftp://")
                    ? QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 250.0,
                      )
                    : Text(qrData, style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            ),
            SizedBox(
              height: 50,
            ),
           GestureDetector(
                onTap:  () async{ 
                 if(await requestCameraPermission()){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>QRCodeScanner()));
                  }
                 },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // Add rounded edges
                  boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 20,
                  ),
                                ],
                                border: Border.all(
                  color: Colors.black,
                  width: 2,
                                ),
                              ),
                    child: Text("Scan Insted",
                    style: TextStyle(
                      fontSize:20,
                      color: Colors.black,
                    ),),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


  
  // In the above code snippet, we have created a QR code generator that generates a QR code for an SFTP file. The QR code contains the SFTP URL with the username, password, host, port, and file path. 
  // The  generateSFTPQr  function connects to the SFTP server using the  SSHClient  class from the  dartssh2  package. It then checks if the file exists on the server and generates the SFTP URL for the file. 
  // The  QRCodeGenerator  widget displays the QR code if the URL is generated successfully, otherwise, it displays an error message. 
  // To run the code, replace the placeholders with your SFTP server details and the file path you want to transfer.
