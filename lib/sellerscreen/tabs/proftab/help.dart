import 'package:flutter/material.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';

class Help extends StatelessWidget {
  static const String routename='help';
  const Help({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppColors.mainlightcolor,
        title:  Align(
          alignment: Alignment.center,
          child: Text("Help Center",

            style:Appfonts.interfont14weight400,),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: 16,
            ),
            Text("1.How can i add a product?",style: Appfonts.interfont14weight400,),
            SizedBox(
              height: 16,
            ),
            Text("you can add a product by tapping thr”+” button in your account page and filling out the details",
              style:Appfonts.interfont14weight400,),
            SizedBox(
              height: 16,
            ),
            Text("2.How do i track my orders?",style: Appfonts.interfont14weight400),
            SizedBox(
              height: 16,
            ),

            Text("your orders appear in the “my order” section with real-time status updates",
              style: Appfonts.interfont14weight400,),
            SizedBox(
              height: 16,
            ),
            Text("3.How can i start selling on local fit?",style: Appfonts.interfont14weight400),
            SizedBox(
              height: 16,
            ),
            Text("log in ,complete your store profile,and start uploading your products",
              style: Appfonts.interfont14weight400,),
          ],
        ),
      ),
    );
  }
}
