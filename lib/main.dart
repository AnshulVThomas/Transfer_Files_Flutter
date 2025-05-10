// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfer_files/nav/bottom_navigation.dart';

void main(){
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  Future<bool> char_not_found()async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    // print("username = ${pref.getString("username")}");
   return pref.getString("username")==null;  
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      home:  FutureBuilder<bool>(
        future: char_not_found(),
        builder: (context, snapshot) {
          // Handle waiting state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); 
          } 
          // Handle errors
          else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } 
          // Check if the username is found or not
          else {
            bool isNotFound = snapshot.data ?? true;
            if (! isNotFound) {
              return const CustomBottomNavigation();
            } else {
              return const HomePage(); // Replace with your Home page
            }
          }
        },
      ),
    );
  }
}

