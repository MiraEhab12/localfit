import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/clothesofwomen/dataclassforlist.dart';
import 'package:localfit/listofclothes/listofclothes.dart';

class Woman_screen extends StatelessWidget{
  static const String routename='womanscreen';
List<product> products=[
product(name: 'polo sweater', image: Appassets.polo, price: 1200),
product(name: 'leather jacket', image: Appassets.jacket, price: 2800),
  product(name: 'Black Vest', image:Appassets.vest, price: 1000),
  product(name: 'Zipper Pullovert', image:Appassets.pullover, price: 1500),
  product(name: 'polo sweater', image: Appassets.polo, price: 1200),
  product(name: 'leather jacket', image: Appassets.jacket, price: 2800),
  product(name: 'Black Vest', image:Appassets.vest, price: 1000),
  product(name: 'Zipper Pullovert', image:Appassets.pullover, price: 1500),
];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
backgroundColor: AppColors.mainlightcolor,
      appBar: AppBar(
        title: Text("women",style: GoogleFonts.inter(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          )
        ), ),
        backgroundColor: AppColors.mainlightcolor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                mainAxisExtent: 294,
                crossAxisSpacing: 23, // مسافة بين الأعمدة
                mainAxisSpacing: 11
            ),
            itemBuilder: (context,index){
              return Listofclothes(
                  nameofclothes: products[index].name,
                  nameofimage:products[index].image,
                  price: products[index].price
              );
            },
          ),
        
        ),
      ),
    );
  }
}