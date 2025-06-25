import 'package:flutter/material.dart';
import 'package:localfit/sellerscreen/tabs/brandname.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/sellerscreen/homeseller.dart';

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
      child: Column(
        children: [
          Container(
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
          SizedBox(height: 18),
          for (int index = 0; index < nameoficons.length; index++)
            InkWell(
              onTap: () {
                if (index == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Personaldetailedscreen()));
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
            ),
          SizedBox(height: 40),
          InkWell(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final savedBrandName = prefs.getString('brandName');

              if (savedBrandName == null || savedBrandName.isEmpty) {
                // لو اسم البراند مش محفوظ، اذهب لشاشة إدخال الاسم
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BrandNameScreen()),
                );
              } else {
                Navigator.pushNamed(context, Homeseller.routename,
                    arguments: true);
              }
            },
            child: Text(
              "sell with us",
              style: Appfonts.interfont24weight400.copyWith(
                color: AppColors.maindarkcolor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
