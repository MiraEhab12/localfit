import 'package:flutter/material.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/sellerscreen/homeseller.dart';
import 'package:localfit/tabs/prof/elementsofprofile/help.dart';
import 'package:localfit/tabs/prof/elementsofprofile/personaldetailedscreen.dart';

class ProfTab extends StatelessWidget {
List<String> imageoficons=[
  Appassets.bag,
  Appassets.ret,
  Appassets.personal,
  Appassets.help,
  Appassets.contact,
  Appassets.logout
];
List <String> nameoficons=[
  'My purchases',
  'Online returns',
  'Personal details',
  'Help',
  'contact us',
  'Log out'
];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(int index=0;index<nameoficons.length;index++)
        InkWell(
          onTap: (){
index==2? Navigator.push(context, MaterialPageRoute(builder: (_)=>Personaldetailedscreen()))
        :index==3?Navigator.push(context, MaterialPageRoute(builder: (_)=>Help()))
    :null;
          },
          child: Row(
            children: [
              Image.asset(imageoficons[index]),
              Text(nameoficons[index]),
            ],
          ),
        ),
        InkWell(
            onTap: (){
              Navigator.pushNamed(context, Homeseller.routename);
            },
            child: Text("sell with us",style:Appfonts.interfont24weight400,)),
      ],
    );
  }
}
