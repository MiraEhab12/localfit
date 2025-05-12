
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/shop_now.dart';
import 'package:localfit/tabs/fav/fav_tab.dart';
import 'package:localfit/tabs/prof/prof_tab.dart';
import 'package:localfit/tabs/shop/shop_tab.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:localfit/clothesofwomen/woman_screen.dart';
class ShopNow extends StatefulWidget {
  static const String routename='shop now';

  @override
  State<ShopNow> createState() => _ShopNowState();
}

class _ShopNowState extends State<ShopNow> {

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int selectedindex=0;
  List<Widget> tabs=[
    FavTab(),
    ProfTab(),
    ShopTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainlightcolor,
      body:
      selectedindex==0?
      Padding(
        padding: const EdgeInsets.only(top: 52),
        child: Expanded(
          child: Column(
            children: [
              Text("Your Style, Locally Crafted",
                style: GoogleFonts.italiana(
                    textStyle:
                    const TextStyle(
                        fontSize: 20,
                        color: AppColors.blackcolor
                    )

                ),
              ),
              const SizedBox(
                height: 19,
              ),
              Container(

                padding: const EdgeInsets.only(top: 50),
                width: double.infinity,
                height: 157,
                color: AppColors.maindarkcolor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(onPressed: (){},
                      padding: const EdgeInsets.only(bottom: 63,left: 32),
                      icon: const Icon(Icons.search),color: AppColors.whitecolor,
                    ),
                    const Expanded(

                      child: Text("LocalFit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.whitecolor,
                          fontSize: 36,

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
SizedBox(
  height: 28,
),
Padding(
  padding: EdgeInsets.only(right:MediaQuery.of(context).size.width*0.63),
  child: Text("shop by category", style:
  GoogleFonts.inter(
    textStyle:  TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  )
 ),
),
SizedBox(
  height: 40,
),
Text("woman",style: GoogleFonts.inter(
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400
  )
),),
              GestureDetector(
                onTap:(){
                  Navigator.of(context).pushNamed(Woman_screen.routename);
                },
                child: Image.asset("assets/images/womanbutton.png",
width: MediaQuery.of(context).size.width*0.44,
height: MediaQuery.of(context).size.height*0.30,
                ),
              )
            ],
          ),
        ),
      )
          : tabs[selectedindex-1],
      bottomNavigationBar:

      CurvedNavigationBar(
        key: _bottomNavigationKey,
        items:   <Widget>[
          Icon(Icons.home_filled, size: 30,color: selectedindex == 0 ? Colors.black : Colors.white),
          Icon(Icons.favorite_border, size: 30,color: selectedindex == 1 ? Colors.black  : Colors.white),
          Icon(Icons.shopping_bag_outlined, size: 30,color: selectedindex == 2 ? Colors.black  : Colors.white),
          Icon(Icons.person_pin, size: 30,color: selectedindex == 3? Colors.black  : Colors.white),
        ],
        color: AppColors.maindarkcolor,
        buttonBackgroundColor: AppColors.mainlightcolor,
        backgroundColor: AppColors.mainlightcolor,
        letIndexChange: (index) => true,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            selectedindex = index;
          });
        },
      ),
    );
  }
}