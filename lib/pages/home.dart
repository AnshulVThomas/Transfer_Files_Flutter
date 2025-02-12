// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transfer_files/char_img/char_img.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfer_files/pages/secondpage.dart';
// import 'flutter_svg/flutter.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _Char_img_path="assets/characters/magician.svg";
  final TextEditingController _usernameController =TextEditingController();
bool red_textfield =   false;

@override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: Appbar(),

      body: Column(
        
        children: [
          SizedBox(height: 50,),
          character_img_box(context),
          SizedBox(height: 40,),
          textfield_username(),
          SizedBox(height: 50,),
          GestureDetector(
            onTap: () { 
              if(validate_user()){
                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Secondpage()));
              }},
            child: Container(
              height: 45,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                  color: Colors.black.withAlpha(75),
                  blurRadius: 20,
                ),],
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                )
                
              ),
              child: Center(
                child: Text("Select",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),),
              ),
            
            ),
          ),

        ],

      ),



    
    );
  }

  void savedata(String user,String char_img_path_string)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("username", user);
    await pref.setString("char_path", char_img_path_string);
    print(pref.getString("username"));

  }


  bool validate_user(){
    String uname=_usernameController.text;

    if(uname.isEmpty || uname.length < 4){
      setState(() {
        red_textfield=true;
      });
      
      return false;

    }
    savedata(uname,_Char_img_path);
    setState(() {
      red_textfield=false;
    });
    return true;


  }

  Color borderstatuscolor(){
    if(red_textfield){
      return Colors.red;
    }
    return Colors.black;
  }


  Container textfield_username() {
    return Container(
          margin: EdgeInsets.only(top: 20,left: 20,right: 20),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Color(0xff1d1617).withAlpha(75),
              blurRadius: 20
              
              
            )]
          ),
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Username",
              hintStyle: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
              prefixIcon: Padding(
                
                padding: const EdgeInsets.all(3.0),
                child: SvgPicture.asset("assets/icons/account_circle_24dp_E8EAED_FILL0_wght400_GRAD0_opsz24.svg",
                width: 40,
                height: 40,
                colorFilter:ColorFilter.mode(Colors.black.withAlpha(130), BlendMode.srcIn),
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                 borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
              ),
            
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: borderstatuscolor(),
                  width: 2.0,
                ),
              ),


              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: borderstatuscolor().withAlpha(100),
                  width: 2.0,
                ),
              ),


            ),
          ),
        );
  }

  Center character_img_box(BuildContext context) {
    return Center(
          child: GestureDetector(
            onTap: () => ShowCharacterDialog(context),
            child: Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
            
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow:[
                  BoxShadow(
                    color: Colors.black.withAlpha(75),
                    blurRadius: 20,
                  )
                ],
                
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SvgPicture.asset(_Char_img_path,
                ),
              ),
            ),
          ),
        );
  }

void ShowCharacterDialog(BuildContext context){

  showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        
        title: Center(
          child: Text("Character Images",
          style: TextStyle(
            
          ),),
        ),
        titlePadding: EdgeInsets.only(top: 50),
        contentPadding: EdgeInsets.all(40),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: GridView.count(crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: CharImg.getChar().map((CharImg char){
            return GestureDetector(
              onTap: () {
                setState(() {
                  _Char_img_path=char.iconpath;
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 3
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(char.iconpath,
                  fit: BoxFit.contain,),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Close"),),
      ],);
  });

}

  AppBar Appbar() {
    return AppBar(
      title: Text("Profile",
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