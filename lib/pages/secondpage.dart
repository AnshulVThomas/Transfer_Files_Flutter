import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transfer_files/camera_and_qr_code/qrCodeScanner.dart';
// import 'package:transfer_files/char_img/char_img.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:transfer_files/f_picker/f_picker.dart';
import 'package:transfer_files/camera_and_qr_code/qrCodeGenerator.dart';
import 'package:transfer_files/Connections/connections.dart';




class Secondpage extends StatefulWidget{
  const Secondpage({super.key});

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  List<Active> users = Active.getActive();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: Appbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 50,),
          Center(
            child:Container(
  height: 300, // Fixed height for scrollable area
  width: 400,

  child:ListView.builder(
  itemCount: users.length,
  itemBuilder: (context, index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12), // Reduce horizontal padding
      leading: Container(
  width: 44,
  height: 44,
  padding: EdgeInsets.all(4), // Space between image and border
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.black, width: 2), // Stroke
  ),
  child: ClipOval(
    child: SvgPicture.asset(
      users[index].iconpath,
      fit: BoxFit.contain,
    ),
  ),
),

      title: Text(users[index].username, style: TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.upload_outlined, size: 20), // Slightly smaller icon
            padding: EdgeInsets.zero, // Remove padding
            constraints: BoxConstraints(), // Remove default button size constraints
            onPressed: () {

              f_picker().pick();

            },
          ),
          IconButton(
            icon: Icon(Icons.link_off, color: Colors.red, size: 20),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              setState(() {
                 users.remove(users[index]);
              });
             
            },
          ),
        ],
      ),
    );
  },
),


)

          ),SizedBox(
            height: 50,
          ),
           GestureDetector(
                onTap:() async{
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>QRCodeGenerator()));
                  
                },
                child: Container(
                  height: 50,
                  width: 50,
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
                  child: SvgPicture.asset('assets/icons/addlink.svg',
                  colorFilter: ColorFilter.mode(const Color.fromARGB(255, 44, 36, 36), BlendMode.srcATop),
                  ),
                ),
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

// Future<void> requestCameraPermission() async {
//     var status = await Permission.camera.request();
//     if (status.isGranted) {
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>QRCodeScanner()));
//     } else if (status.isDenied) {
//       requestCameraPermission();
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings(); // Opens the app-specific settings page
//     }
//   }


  AppBar Appbar() {
    return AppBar(
      title: Text("Connect",
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