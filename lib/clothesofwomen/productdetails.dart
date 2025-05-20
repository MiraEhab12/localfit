import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/clothesofwomen/dataclassforlist.dart';

class Productdetails extends StatefulWidget {
  static const String routename='product details';

  const Productdetails({super.key});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  String? selectedSize;


  void _showSizeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        List<String> sizes = ['S', 'M', 'L','XL','XXL'];

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: sizes.map((size) {
              return Column(
                children: [
                  ListTile(
                    title: Text(size),
                    onTap: () {
                      setState(() {
                        selectedSize = size;
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  ),
              Divider(),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    product receivedata=ModalRoute.of(context)!.settings.arguments as product;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainlightcolor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(receivedata.image,
          fit: BoxFit.fitWidth,
            width: width*1,
            height: height*0.6,
          ),
          Text(receivedata.name),
          Text("${receivedata.price}"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 27,horizontal: 16),
            child: Row(
              children: [
                ElevatedButton(onPressed:_showSizeBottomSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xffe0e0e0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                      )
                    ),
                    child: Row(
                      children: [
                        Text(selectedSize??"selected size",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                          )
                        ),
                        ),
                        Icon(Icons.arrow_drop_down,size: 30,)
                      ],
                    )
                ),
                SizedBox(
                  width: 24,
                ),
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
          ),
        ],
      ),
    );
  }
}
