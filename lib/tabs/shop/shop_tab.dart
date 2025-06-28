import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appassets/appassets.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:localfit/checkout.dart';
import 'package:localfit/cubit/cartcubit.dart';
import 'package:localfit/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../clothesofwomen/productwithsize.dart';

class ShopTab extends StatefulWidget {
  static const String routename = 'shoptab';

  @override
  _ShopTabState createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  @override
  void initState() {
    super.initState();
    fetchCartItemsFromAPI();
  }

  Future<void> fetchCartItemsFromAPI() async {
    final Uri url = Uri.parse('https://localfitt.runasp.net/api/cart/items');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        print('Token is empty, user not logged in');
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        final cartItems = jsonList.map((item) {
          final product = Responseproductsofbrands.fromJson(item);
          return ProductWithSizeAndQuantity(
            product: product,
            selectedSize: item["selectedSize"] ?? "M",
            quantity: item["quantity"] ?? 1,
          );
        }).toList();

        context.read<CartCubit>().replaceCartItems(cartItems);
      } else {
        print('Failed to fetch cart items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<void> updateCartAPI(ProductWithSizeAndQuantity item) async {
    final Uri url = Uri.parse(
        'https://localfitt.runasp.net/api/cart/items/${item.product.producTID}');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        print('Token is empty, user not logged in');
        return;
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(item.toJson()),
      );
      print("PUT response: ${response.statusCode} ${response.body}");
    } catch (e) {
      print("Error updating product in cart: $e");
    }
  }

  Future<void> deleteCartItemAPI(ProductWithSizeAndQuantity item) async {
    final Uri url = Uri.parse(
        'https://localfitt.runasp.net/api/cart/items/${item.product.producTID}');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        print('Token is empty, user not logged in');
        return;
      }

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Item deleted successfully from cart');
      } else {
        print('Failed to delete item from cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting item from cart: $e');
    }
  }

  void _showQuantityBottomSheet(BuildContext context, int index, int currentQty) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        List<int> quantities = List.generate(10, (i) => i + 1);
        return Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: quantities.map((qty) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(qty.toString()),
                      onTap: () {
                        context.read<CartCubit>().updateQuantity(index, qty);
                        Navigator.pop(context);
                        updateCartAPI(context.read<CartCubit>().state[index]);
                      },
                    ),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showSizeBottomSheet(BuildContext context, int index, String currentSize) {
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
                      context.read<CartCubit>().updateSize(index, size);
                      Navigator.pop(context);
                      updateCartAPI(context.read<CartCubit>().state[index]);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("MyCart", style: Appfonts.interfont24weight400),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, List<ProductWithSizeAndQuantity>>(
        builder: (context, cartItems) {
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
                      padding: const EdgeInsets.only(bottom: 12), // مسافة بين العناصر
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
                                    "https://localfit.runasp.net${item.product.productIMGUrl ?? ''}",
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
                                            Expanded(
                                              flex: 2,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  side: BorderSide(
                                                      color: Color(0xffE0E0E0),
                                                      width: 2),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.zero),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 10),
                                                ),
                                                onPressed: () {
                                                  _showSizeBottomSheet(
                                                      context, index, item.selectedSize);
                                                },
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text("Size: ${item.selectedSize}",
                                                          style: Appfonts
                                                              .interfont14weight400),
                                                      Icon(Icons.arrow_drop_down_sharp,
                                                          color: Color(0xffE0E0E0)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              flex: 1,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  side: BorderSide(
                                                      color: Color(0xffE0E0E0),
                                                      width: 2),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.zero),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 10),
                                                ),
                                                onPressed: () {
                                                  _showQuantityBottomSheet(
                                                      context, index, item.quantity);
                                                },
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text("Qty: ${item.quantity}",
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: Appfonts
                                                              .interfont14weight400),
                                                      Icon(Icons.arrow_drop_down_sharp,
                                                          color: Color(0xffE0E0E0)),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                                  context.read<CartCubit>().removeFromCartByIndex(index);
                                  deleteCartItemAPI(item);
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(totalAmount: totalPrice),
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
        },
      ),
    );
  }
}

