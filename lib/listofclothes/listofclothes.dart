import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/clothesofwomen/dataclassforlist.dart';
import 'package:localfit/clothesofwomen/productdetails.dart';

import '../appassets/appassets.dart';
import '../appcolor/appcolors.dart';

class Listofclothes extends StatelessWidget {
  String nameofclothes;
  String nameofimage;
  double price;
   Listofclothes({required this.nameofclothes,required this.nameofimage,required this.price});

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return   GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(Productdetails.routename,arguments:
        product(name: nameofclothes, image: nameofimage, price: price)
        );
      },
      child: Container(
        width:160,
          decoration: BoxDecoration(
              color: AppColors.mainlightcolor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset:Offset(0,4),
                )
              ]
          ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
      GestureDetector(
          onTap: (){},
          child: Image.asset(Appassets.fav)
      ),
              Expanded(child: Image.asset(nameofimage,fit: BoxFit.cover,)),
              SizedBox(
                height: 19,
              ),
              Text(nameofclothes,
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                )
              ),),
              SizedBox(
                height: 5,
              ),
              Text("EGP$price",
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    )
                ),),
            ],
          ),

        ),
      ),
    );
  }
  }
