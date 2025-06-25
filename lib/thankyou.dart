import 'package:flutter/material.dart';
import 'package:localfit/appassets/appassets.dart';
class ThankYouScreen extends StatelessWidget{
  static const String routename='thank you';
  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Image.asset(Appassets.ty),
       Text("Thank You!"),
       Text("Your order has been recieved")
     ],
   );
  }
}