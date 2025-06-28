import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/homescreen.dart';
import 'package:localfit/log_in/sign_in.dart';
import 'package:localfit/tabs/prof/elementsofprofile/contactus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/sellerscreen/homeseller.dart';
import 'package:localfit/sellerscreen/tabs/brandname.dart';
import 'package:localfit/sellerscreen/tabs/proftab/admin%20login.dart';
import 'package:localfit/tabs/prof/elementsofprofile/help.dart';
import 'package:localfit/tabs/prof/elementsofprofile/personaldetailedscreen.dart';

class ProfTab extends StatelessWidget {
  final List<String> imageoficons = [
    Appassets.personal,
    Appassets.help,
    Appassets.contact,
    Appassets.logout
  ];

  final List<String> nameoficons = [
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
            Expanded(
              child: ListView.builder(
                itemCount: nameoficons.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Personaldetailedscreen()),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Help()),
                        );
                      }else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Contactus()),
                        );
                      }else if (index == 3) {
                        Navigator.pushNamed(context, SignInScreen.routename);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                child: Text(
                  "Go to MainScreen",
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



