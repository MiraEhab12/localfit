import 'package:flutter/material.dart';
import 'package:localfit/sellerscreen/tabs/proftab/admin%20login.dart';
import 'package:localfit/tabs/prof/loginasseller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/sellerscreen/homeseller.dart';
import 'package:localfit/sellerscreen/tabs/brandname.dart'; // CreateBrandScreen // << أضف صفحة تسجيل دخول البائع هنا
import 'package:localfit/tabs/prof/elementsofprofile/help.dart';
import 'package:localfit/tabs/prof/elementsofprofile/personaldetailedscreen.dart';

class ProfTab extends StatelessWidget {
  List<String> imageoficons = [
    Appassets.bag,
    Appassets.ret,
    Appassets.personal,
    Appassets.help,
    Appassets.contact,
    Appassets.logout
  ];

  List<String> nameoficons = [
    'My purchases',
    'Online returns',
    'Personal details',
    'Help',
    'Contact us',
    'Log out'
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                height: height * 0.12,
                width: width * 0.27,
                decoration: BoxDecoration(
                  color: AppColors.mainlightcolor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 5,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  "HELLO",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 18),

            // القائمة
            Expanded(
              child: ListView.builder(
                itemCount: nameoficons.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Personaldetailedscreen()));
                      } else if (index == 3) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => Help()));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Image.asset(imageoficons[index]),
                          SizedBox(width: 15),
                          Text(
                            nameoficons[index],
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // زر Sell with us
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');
                  final userType = prefs.getString('userType'); // نوع المستخدم
                  final savedBrandName = prefs.getString('brandName');

                  print('Token: $token');
                  print('UserType: $userType');
                  print('BrandName: $savedBrandName');

                  if (token == null || token.isEmpty || userType != 'seller') {
                    // مش مسجل دخول كبائع
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminLoginScreen()),
                    );
                    return;
                  }

                  if (savedBrandName == null || savedBrandName.isEmpty) {
                    // مسجل دخول كبائع بس ما عندوش براند
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateBrandScreen()),
                    );
                  } else {
                    // مسجل دخول كبائع وعنده براند
                    Navigator.pushNamed(context, Homeseller.routename, arguments: true);
                  }
                },

                child: Text(
                  "sell with us",
                  style: Appfonts.interfont24weight400.copyWith(
                    color: AppColors.maindarkcolor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
