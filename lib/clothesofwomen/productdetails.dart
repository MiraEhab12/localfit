import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/clothesofwomen/productwithsize.dart';
import 'package:localfit/cubit/cartcubit.dart';

class Productdetails extends StatefulWidget {
  static const String routename = 'product details';

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
        List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
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
                      Navigator.pop(context);
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
    final Responseproductsofbrands receiveDetails =
    ModalRoute.of(context)!.settings.arguments as Responseproductsofbrands;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainlightcolor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            "https://localfit.runasp.net${receiveDetails.productIMGUrl ?? ''}",
            fit: BoxFit.fill,
            width: width,
            height: height * 0.6,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image_outlined);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              receiveDetails.producTNAME ?? '',
              style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "${receiveDetails.price} EGP",
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 27, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _showSizeBottomSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xffe0e0e0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            selectedSize ?? "Select Size",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 24),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedSize?.isEmpty ?? true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select a size before adding to cart")),
                        );
                        return;
                      }

                      final cartItems = context.read<CartCubit>().state;

                      final alreadyInCart = cartItems.any(
                            (item) => item.product.producTID == receiveDetails.producTID,
                      );

                      if (alreadyInCart) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Already in cart ✅"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      final item = ProductWithSizeAndQuantity(
                        product: receiveDetails,
                        selectedSize: selectedSize!,
                        quantity: 1,
                      );

                      context.read<CartCubit>().addToCart(item);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added to cart with size $selectedSize ✅"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Add to cart",
                        style: GoogleFonts.inter(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
