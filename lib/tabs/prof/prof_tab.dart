import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/tabs/prof/elementsofprofile/help.dart';

import '../../appassets/appassets.dart';

class ProfTab extends StatelessWidget {
List<String> assetsoficons=[
  Appassets.bag,
  Appassets.ret,
  Appassets.personal,
  Appassets.help,
Appassets.contact,
  Appassets.logout
];
List<String>namesoficons=[
  'My purchases',
  'Online returns',
  'Personal details',
  'Help',
  'contact us',
  'Log out'
];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          for(int index=0;index<namesoficons.length;index++)
          InkWell(
            onTap: (){

              index==3?Navigator.push(context, MaterialPageRoute(builder: (_)=>Help()))
              :null;
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24
                  ),
                  child: Image.asset(assetsoficons[index]),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(namesoficons[index],style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400
                  )
                ),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
