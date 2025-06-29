import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appcolor/appcolors.dart';
import '../../clothesofwomen/productwithsize.dart';
 // تأكد من استدعاء CartCubit
import '../../cubit/cartcubit.dart';
import '../../cubit/favcubit.dart';

class FavTab extends StatefulWidget {
  @override
  State<FavTab> createState() => _FavTabState();
}

class _FavTabState extends State<FavTab> {
  Map<int, String> selectedSizes = {};

  void _showSizeBottomSheet(int index) {
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
                    title: Center(child: Text(size)),
                    onTap: () {
                      setState(() {
                        selectedSizes[index] = size;
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Favorites",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FavCubit, List<Responseproductsofbrands>>(
        builder: (context, favoriteList) {
          if (favoriteList.isEmpty) {
            return Center(
              child: Text(
                "No favorites yet",
                style: TextStyle(fontSize: 22),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final product = favoriteList[index];
              final selectedSize = selectedSizes[index] ?? "Select Size";

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  color: AppColors.whitecolor,
                  width: double.infinity,
                  height: height * 0.19,
                  padding: EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Image.network(
                            "https://localfitt.runasp.net${product.productIMGUrl ?? ''}",
                            width: width * 0.26,
                            height: height * 0.12,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image_outlined),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(product.producTNAME ?? "",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text("EGP ${product.price ?? 'N/A'}"),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          side: BorderSide(
                                              color: Color(0xffE0E0E0), width: 2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero),
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                        ),
                                        onPressed: () {
                                          _showSizeBottomSheet(index);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                selectedSize,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            Icon(Icons.arrow_drop_down_sharp,
                                                color: Color(0xffE0E0E0)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Flexible(
                                      flex: 2,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero),
                                        ),
                                        onPressed: () {
                                          if (selectedSizes[index] == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Please select a size before adding to cart"),
                                              ),
                                            );
                                            return;
                                          }

                                          final item = ProductWithSizeAndQuantity(
                                            product: product,
                                            selectedSize: selectedSizes[index]!,
                                            quantity: 1,
                                          );

                                          // ===================================
                                          // *** هذا هو السطر الذي تم إضافته ***
                                          context.read<CartCubit>().addToCart(item);
                                          // ===================================

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Added to cart with size ${selectedSizes[index]} ✅"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Move to cart",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            context.read<FavCubit>().removeFromFavorite(product);
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}