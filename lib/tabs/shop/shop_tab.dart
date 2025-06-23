import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/clothesofwomen/dataclassforlist.dart';
import 'package:localfit/cubit/cartcubit.dart';
import 'package:localfit/cubit/states.dart';
import 'package:localfit/homescreen.dart';
import 'package:localfit/listofclothes/listofclothes.dart';


class ShopTab extends StatelessWidget {
static const String routename='shoptab';
  @override
  Widget build(BuildContext context) {
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

                          selectedSize = size;

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
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text("MyCart",
        style: Appfonts.interfont24weight400,)
      ,),
      body: BlocBuilder<CartCubit,List<Responseproductsofbrands>>(
        builder: (context,cartitem) {
          if (cartitem.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Column(
                children: [
                  Image.asset(Appassets.shopping),
                  SizedBox(height: 37,),
                  Text("cart is empty 🛒",

                  style: Appfonts.interfont24weight400,),
                  SizedBox(
                    height: 25,
                  ),
                  Text("looks like you haven’t made\nYour choice yet",
                    style: Appfonts.interfont15weight400,),
                  SizedBox(
                    height: 70,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.maindarkcolor,
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Color(0xffE0E0E0),
                              width: 2
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          )
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context,HomeScreen.routename);
                      },
                      child: Text("Continue Shopping"))
                ] ),
            );
          }
          double totalPrice = 0;
          for (var item in cartitem) {
            totalPrice += item.price ?? 0; // لازم يكون في null check هنا
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: cartitem.length,
                    itemBuilder: (context, index) {
                     final product=cartitem[index];
                      return Container(
                        color: AppColors.ligthgray,
                        width: double.infinity,
                        height: 155,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 21, bottom: 21),
                          child: Row(
                            children: [
                              Image.network(
                                  "https://localfit.runasp.net${product.productIMGUrl ?? ''}",
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image_outlined),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.producTNAME??""),
                                    Text("${product.price}"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              side: BorderSide(
                                                  color: Color(0xffE0E0E0),
                                                  width: 2
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.zero
                                              )
                                          ),
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              Text("Size ", style: Appfonts
                                                  .interfont14weight400),
                                              Icon(Icons.arrow_drop_down_sharp,
                                                color: Color(0xffE0E0E0),)
                                            ],
                                          ),

                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              side: BorderSide(
                                                  color: Color(0xffE0E0E0),
                                                  width: 2
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.zero
                                              )
                                          ),
                                          onPressed: () {
                                            _showSizeBottomSheet;
                                          },
                                          child: Row(
                                            children: [
                                              Text("Qty",
                                                style: Appfonts
                                                    .interfont14weight400,),
                                              Icon(Icons.arrow_drop_down_sharp,
                                                color: Color(0xffE0E0E0),),

                                            ],

                                          )
                                        ),
                                      ],
                                    ),

                                  ],
                                ),

                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(onPressed: (){
                                    context.read<CartCubit>().removeFromCartByIndex(index);

                                  },
                                  icon:Icon(Icons.delete_outline)))
                            ],
                          ),
                        ),

                      );
                    }

                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 1),
                    bottom: BorderSide(color: Colors.grey, width: 1),
                  )
                ),
                height: height*0.15,
                width: double.infinity,
                child: Column(
                  children: [
                    Text("Tola EGP${totalPrice}",style: Appfonts.interfont24weight400,),
                    SizedBox(
                      height: 21,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                                color: Color(0xffE0E0E0),
                                width: 2
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero
                            )
                        ),
                        onPressed: (){},
                        child: Text("Check out"))
                  ],
                ),
              )
            ],
          );
        }
      )
    );
  }
}
