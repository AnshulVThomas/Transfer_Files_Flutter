import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dartssh2/dartssh2.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final String host = "your.sftp.server"; // Change to your SFTP server
  final int port = 22;
  final String username = "yourUsername";
  final String password = "yourPassword";
  final String filePath = "/path/to/file.txt"; // Change to the file you want to transfer

  String qrData = "Generating QR...";

  @override
  void initState() {
    super.initState();
    generateSFTPQr();
  }

  Future<void> generateSFTPQr() async {
    try {
      // Connect to the SFTP server
      final client = SSHClient(
        await SSHSocket.connect(host, port),
        username: username,
        onPasswordRequest: () => password,
      );

      final sftp = await client.sftp();
      final stat = await sftp.stat(filePath);

      if (stat != null) {
        setState(() {
          qrData = "sftp://$username:$password@$host:$port$filePath";
        });
      }

      client.close();
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
        child: qrData.startsWith("sftp://")
            ? QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
              )
            : Text(qrData, style: TextStyle(fontSize: 16, color: Colors.red)),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: QRCodeGenerator()));
}
  
  // In the above code snippet, we have created a QR code generator that generates a QR code for an SFTP file. The QR code contains the SFTP URL with the username, password, host, port, and file path. 
  // The  generateSFTPQr  function connects to the SFTP server using the  SSHClient  class from the  dartssh2  package. It then checks if the file exists on the server and generates the SFTP URL for the file. 
  // The  QRCodeGenerator  widget displays the QR code if the URL is generated successfully, otherwise, it displays an error message. 
  // To run the code, replace the placeholders with your SFTP server details and the file path you want to transfer.