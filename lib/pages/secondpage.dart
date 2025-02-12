import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transfer_files/nav/bottom_navigation.dart';
import 'package:transfer_files/camera_and_qr_code/qrCodeScanner.dart';
// import 'package:transfer_files/char_img/char_img.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';



class Secondpage extends StatefulWidget {
  const Secondpage({super.key});

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      bottomNavigationBar: CustomBottomNavigation(sta: 0,),
      body: Column(
        children: [
          SizedBox(height: 150,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [


              GestureDetector(
                onTap:() {
                  requestCameraPermission();
                  
                },
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 20,
                    )],
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                )
                  ),
                  child: SvgPicture.asset('assets/icons/Download.svg',
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 20,
                  )],
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
              )
                ),
                child: SvgPicture.asset('assets/icons/Upload.svg',
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  void CamaraAlertDialog(BuildContext context){

  showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        
       child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child:QRCodeScanner(),
       )
        // titlePadding: EdgeInsets.only(top: 50),
        
      );
  });

}

Future<void> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>QRCodeScanner()));
    } else if (status.isDenied) {
      requestCameraPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens the app-specific settings page
    }
  }


  AppBar Appbar() {
    return AppBar(
      title: Text("Upload download",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      ),
      centerTitle: true,
      // shadowColor: const Color.fromARGB(255, 39, 34, 34),
      // elevation: 3,
      backgroundColor: Colors.white,

      
    );
  }
}