import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transfer_files/index_to_nav.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int selected_nav_index = 0;



  @override
  Widget build(BuildContext context) {
    List<String> bottomNavItems = [
      "assets/icons/updown.svg",
      "assets/icons/transfer.svg",
      "assets/icons/settingsline.svg"
    ];

    return Scaffold(
      body:IndexToNav().li[selected_nav_index],
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 25),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                offset: Offset(0, 15),
                blurRadius: 30,
              ),
            ],
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              bottomNavItems.length,
              (index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBar(is_Active: selected_nav_index == index),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected_nav_index = index;
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            offset: Offset(0, 10),
                            blurRadius: 30,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Opacity(
                        opacity: selected_nav_index == index ? 1 : 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SvgPicture.asset(
                            bottomNavItems[index],
                            colorFilter: ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcATop,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({super.key, required this.is_Active});

  final bool is_Active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 3),
      height: 4,
      width: is_Active ? 28 : 0,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
