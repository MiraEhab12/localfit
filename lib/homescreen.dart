
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/search%20screen.dart';
import 'package:localfit/shop_now.dart';
import 'package:localfit/tabs/fav/fav_tab.dart';
import 'package:localfit/tabs/prof/prof_tab.dart';
import 'package:localfit/tabs/shop/shop_tab.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routename = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int selectedindex = 0;

  // عدد التابات لازم يتطابق مع عدد الايقونات في CurvedNavigationBar - 1 (لان 0 للصفحة الرئيسية)
  List<Widget> tabs = [
    FavTab(),
    ShopTab(),
    ProfTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainlightcolor,
      body: selectedindex == 0
          ? Padding(
        padding: const EdgeInsets.only(top: 52),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Your Style, Locally Crafted",
                style: GoogleFonts.italiana(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: AppColors.blackcolor,
                  ),
                ),
              ),
              const SizedBox(height: 19),
              Container(
                padding: const EdgeInsets.only(top: 50),
                width: double.infinity,
                height: 157,
                color: AppColors.maindarkcolor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: const EdgeInsets.only(bottom: 63, left: 32),
                      icon: const Icon(Icons.search),
                      color: AppColors.whitecolor,
                    ),
                    const Expanded(
                      child: Text(
                        "LocalFit",
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
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.asset(
                    "assets/images/home.png",
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.51,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainlightcolor,
                      shadowColor: const Color(0xff978D80),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ShopNow.routename);
                    },
                    child: Text(
                      "Shop Now",
                      style: GoogleFonts.italiana(
                        textStyle: const TextStyle(
                          fontSize: 28,
                          color: AppColors.whitecolor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          : tabs[selectedindex - 1],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.home_filled,
              size: 30,
              color: selectedindex == 0 ? Colors.black : Colors.white),
          Icon(Icons.favorite_border,
              size: 30,
              color: selectedindex == 1 ? Colors.black : Colors.white),
          Icon(Icons.shopping_bag_outlined,
              size: 30,
              color: selectedindex == 2 ? Colors.black : Colors.white),
          Icon(Icons.person_pin,
              size: 30,
              color: selectedindex == 3 ? Colors.black : Colors.white),
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
