import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/clothesofwomen/dataclassforlist.dart';
import 'package:localfit/cubit/cartcubit.dart';
import 'package:localfit/tabs/shop/shop_tab.dart';

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
   Responseproductsofbrands receiveDetails= ModalRoute.of(context)!.settings.arguments as Responseproductsofbrands;
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainlightcolor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Image.network(
           "https://localfit.runasp.net${receiveDetails.productIMGUrl ?? ''} ",
          fit: BoxFit.fitWidth,
            width: width*1,
            height: height*0.6,
    errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.broken_image_outlined);
    }
          ),
          Text(receiveDetails.producTNAME??''),
          Text("${receiveDetails.price}"),
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
                ElevatedButton(onPressed: (){
                  context.read<CartCubit>().addToCart(receiveDetails);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("add to cart ✅"),
                    duration: Duration(seconds: 2),));
                },
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
