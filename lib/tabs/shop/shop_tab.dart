// lib/screens/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localfit/checkout.dart';
import 'package:localfit/cubit/cartcubit.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/homescreen.dart';
import '../../clothesofwomen/productwithsize.dart';
import '../../cubit/states.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = 'cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // الثوابت لاختيار المقاس والكمية
  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<int> quantities = List.generate(10, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("MyCart", style: Appfonts.interfont24weight400),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartError) {
            return Center(child: Text(state.message));
          }
          if (state is CartSuccess) {
            final cartItems = state.cartItems;
            final cubit = context.read<CartCubit>();

            if (cartItems.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Column(
                  children: [
                    SizedBox(height: 28),
                    Image.asset(Appassets.shopping),
                    SizedBox(height: 37),
                    Text("Cart is empty 🛒", style: Appfonts.interfont24weight400),
                    SizedBox(height: 25),
                    Text("Looks like you haven’t made\nYour choice yet",
                        style: Appfonts.interfont15weight400),
                    SizedBox(height: 70),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.maindarkcolor,
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Color(0xffE0E0E0), width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false,
                        );
                      },
                      child: Text(
                        "Continue Shopping",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }

            double totalPrice = cartItems.fold(
                0, (sum, item) => sum + (item.product.price ?? 0) * item.quantity);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          color: AppColors.ligthgray,
                          width: double.infinity,
                          height: height * 0.19,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 21, bottom: 21, right: 48),
                                child: Row(
                                  children: [
                                    Image.network(
                                      "https://localfitt.runasp.net${item.product.productIMGUrl ?? ''}",
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.broken_image_outlined),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.product.producTNAME ?? "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("${item.product.price}"),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              // زر اختيار المقاس
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.zero,
                                                    side: BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // فتح مربع اختيار المقاس
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return Container(
                                                        height: 250,
                                                        child: ListView.builder(
                                                          itemCount: sizes.length,
                                                          itemBuilder: (ctx, i) {
                                                            return ListTile(
                                                              title: Text(sizes[i]),
                                                              onTap: () {
                                                                setState(() {
                                                                  cartItems[index].selectedSize = sizes[i];
                                                                });
                                                                Navigator.pop(ctx);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text("Size: ${item.selectedSize}"),
                                              ),
                                              SizedBox(width: 16),

                                              // زر اختيار الكمية
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.zero,
                                                    side: BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // فتح مربع اختيار الكمية
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return Container(
                                                        height: 250,
                                                        child: ListView.builder(
                                                          itemCount: quantities.length,
                                                          itemBuilder: (ctx, i) {
                                                            return ListTile(
                                                              title: Text(quantities[i].toString()),
                                                              onTap: () {
                                                                setState(() {
                                                                  cartItems[index].quantity = quantities[i];
                                                                });
                                                                Navigator.pop(ctx);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text("Qty: ${item.quantity}"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () {
                                    cubit.removeFromCartByIndex(index);
                                  },
                                  icon: Icon(Icons.delete_outline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 1),
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  height: height * 0.15,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text("Total EGP ${totalPrice.toStringAsFixed(2)}",
                          style: Appfonts.interfont24weight400),
                      SizedBox(height: 21),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Color(0xffE0E0E0), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        onPressed: () {
                          double totalAmount = cartItems.fold(0.0, (sum, item) {
                            return sum + ((item.product.price ?? 0.0) * item.quantity);
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(cartItems: cartItems, totalAmount: totalAmount,),
                            ),
                          );
                        },
                        child: Text("Check out"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Something went wrong!'));
        },
      ),
    );
  }
}
