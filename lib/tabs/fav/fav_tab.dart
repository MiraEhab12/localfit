import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/cubit/favcubit.dart';
import '../../cubit/cartcubit.dart';

class FavTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: BlocBuilder<FavCubit, List<Responseproductsofbrands>>(
        builder: (context, favoriteList) {
          if (favoriteList.isEmpty) {
            return Center(child: Text("No favorites yet 🛒"));
          }
          return ListView.builder(
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final product = favoriteList[index];
              return Container(
                color: AppColors.whitecolor,
                width: double.infinity,
                height: 155,
                padding: EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Image.network(
                          "https://localfit.runasp.net${product.productIMGUrl ?? ''}",
                          width: 100,
                          height: 100,
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
                              Text("EGP${product.price}"),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                          color: Color(0xffE0E0E0), width: 2),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero),
                                    ),
                                    onPressed: () {
                                      // اختيار الحجم لو عايزة
                                    },
                                    child: Row(
                                      children: [
                                        Text("Size "),
                                        Icon(Icons.arrow_drop_down_sharp,
                                            color: Color(0xffE0E0E0))
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero),
                                    ),
                                    onPressed: () {
                                      context.read<CartCubit>().addToCart(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Added to cart ✅"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Text("Move to cart"),
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
              );
            },
          );
        },
      ),
    );
  }
}
