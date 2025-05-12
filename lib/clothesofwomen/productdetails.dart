import 'package:flutter/material.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/clothesofwomen/dataclassforlist.dart';

class Productdetails extends StatelessWidget {
  static const String routename='product details';
  const Productdetails({super.key});

  @override
  Widget build(BuildContext context) {
    product receivedata=ModalRoute.of(context)!.settings.arguments as product;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainlightcolor,
      ),
      body: Column(
        children: [
          Image.asset(receivedata.image,
          fit: BoxFit.fitWidth,
          ),
          Text(receivedata.name),
          Text("${receivedata.price}"),
          ElevatedButton(onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 55,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,    
              ),
            ),
              child: Text("Add to cart"),

          ),
        ],
      ),
    );
  }
}
