import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigation extends StatelessWidget {
   int sta;
   CustomBottomNavigation({
    super.key,
    required this.sta,
    });


  List<Color>chooseState(int st){
    Color blwithalpha=Colors.black;
    Color bl=Colors.black.withAlpha(100);
    switch(st){
      
      case 0:
        return [blwithalpha,bl,bl];
      case 1:
        return [bl,blwithalpha,bl];
      case 2:
        return [bl,bl,blwithalpha];
      default:
        return [bl,bl,bl];
    }
  }

  @override
  Widget build(BuildContext context) {
    List li = chooseState(sta);
    return Padding(
      padding: const EdgeInsets.only(bottom: 40,left: 25,right: 25,top: 15),
      child: Container(
        height: 60,
         width: 50,
          
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 20,
          )],
          border: Border.all(
            color: Colors.black,
            width: 2,
          )
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 20,
                )],
                border: Border.all(
                  color: li[0],
                  width: 2,
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset("assets/icons/updown.svg",
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
                ),
              ),
            ),

            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 20,
                )],
                border: Border.all(
                  color: li[1],
                  width: 2,
                )
              ),
               child: Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: SvgPicture.asset("assets/icons/transfer.svg",
                               colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
                               ),
               ),
            ),

            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 20,
                )],
                border: Border.all(
                  color: li[2],
                  width: 2,
                )
              ),
               child: Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: SvgPicture.asset("assets/icons/settingsline.svg",
                               colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
                               ),
               ),
            ),
          ],
        ),
      ),
    );
  }
}