import 'package:flutter/material.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';

class FavTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColors.whitecolor,
        width: double.infinity,
        height: 155,
        child: Row(
          children: [
            Image.asset(Appassets.vest),
            Column(
              children: [
                Text("data"),
                Text("data"),
                Text("data"),
                SizedBox(
                  width: 225,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(
                            color:  Color(0xffE0E0E0),
                            width: 2
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                          )
                      ),
                      onPressed: (){},
                      child: Row(
                        children: [
                          Text("Size "),
                          Icon(Icons.arrow_drop_down_sharp,
                          color: Color(0xffE0E0E0),)
                        ],
                      ),

                  ),
                ),
                SizedBox(
                  height: 20,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15,),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    )
                  ),
                      onPressed: (){},
                      child: Text("Move to cart ")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
