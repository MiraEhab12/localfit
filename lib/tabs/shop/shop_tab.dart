import 'package:flutter/material.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/clothesofwomen/dataclassforlist.dart';


class ShopTab extends StatelessWidget {
static const String routename='shoptab';
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          Text("My Cart",style: Appfonts.interfont24weight400,),
          Container(
            child: Row(
              children: [
                Image.asset(Appassets.polo),
                Column(
                  children: [

                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
