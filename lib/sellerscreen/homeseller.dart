import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/sellerscreen/tabs/addtab.dart';
import 'package:localfit/sellerscreen/tabs/proftab/proftab.dart';
class Homeseller extends StatefulWidget {
  static const String routename='home';

  @override
  State<Homeseller> createState() => _HomesellerState();
}

class _HomesellerState extends State<Homeseller> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int selectedindex=0;
  List<Widget> tabs=[
    AddTab(),
    ProfTab(),
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
                        color: Color(0xff000000)
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
                color:AppColors.maindarkcolor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(onPressed: (){},
                      padding: const EdgeInsets.only(bottom: 63,left: 32),
                      icon: const Icon(Icons.search),color: Colors.white,
                    ),
                    const Expanded(

                      child: Text("LocalFit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:  Colors.white,
                          fontSize: 36,

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.asset("assets/images/surahome.png",
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.height*0.51,
                  ),
                ],
              ),

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
          Icon(Icons.add_circle_outline, size: 30,color: selectedindex == 1 ? Colors.black  : Colors.white),
          Icon(Icons.person_pin, size: 30,color: selectedindex == 3? Colors.black  : Colors.white),
        ],
        color: AppColors.maindarkcolor,
        buttonBackgroundColor: AppColors.mainlightcolor,
        backgroundColor: AppColors.maindarkcolor,
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