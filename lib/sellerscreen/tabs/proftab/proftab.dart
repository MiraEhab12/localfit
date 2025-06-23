import 'package:flutter/material.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/sellerscreen/tabs/proftab/help.dart';
import 'package:localfit/sellerscreen/tabs/proftab/personaldetails.dart';
class ProfTab extends StatelessWidget {
  List<String> imageoficons=[
    Appassets.personal,
    Appassets.help,
    Appassets.contact,
    Appassets.logout
  ];
  List <String> nameoficons=[
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
              index==0? Navigator.push(context, MaterialPageRoute(builder: (_)=>Personaldetailedscreen()))
                  :index==1?Navigator.push(context, MaterialPageRoute(builder: (_)=>Help()))
                  :null;
            },
            child: Row(
              children: [
                Image.asset(imageoficons[index]),
                Text(nameoficons[index])
              ],
            ),
          )
      ],
    );
  }
}

