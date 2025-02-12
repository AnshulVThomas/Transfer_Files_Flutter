import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String? QRCodeResultValues;
  String QRCodeResult="";

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Determine the smaller dimension to use for the container
    final double containerSize = screenWidth < screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      appBar: Appbar_qr(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          Center(
            child: Container(
              height: containerSize - 30,
              width: containerSize - 30,
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
              child: ClipRRect(

                borderRadius: BorderRadius.circular(17), // Clip the camera view to rounded corners
                child: MobileScanner(
                  fit: BoxFit.cover,
                  onDetect: (BarcodeCapture capture) {
                    final barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      setState(() {
                        QRCodeResultValues = barcodes.first.rawValue;
                        QRCodeResult = "Values $QRCodeResultValues";
                      });
                    } else {
                      setState(() {
                        QRCodeResult = "Scan Failed Try again";
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          Text(QRCodeResult),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
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
                    child: Text("Display QR Code",
                    style: TextStyle(
                      fontSize:20,
                      color: Colors.black,
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  

  AppBar Appbar_qr() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        "Scan QRCode",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
