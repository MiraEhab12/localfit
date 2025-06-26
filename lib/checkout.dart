// ✅ Full Checkout & Order Logic in Flutter - With Cart Items & Order Details
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/thankyou.dart';
// <-- assume you manage cart items via Cubit
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cartcubit.dart';
import 'orderdetailes.dart';

class AddressStorage {
  static Future<void> saveAddress(String country, String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_country', country);
    await prefs.setString('user_address', address);
  }

  static Future<Map<String, String?>> getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'country': prefs.getString('user_country'),
      'address': prefs.getString('user_address'),
    };
  }
}

class CheckoutScreen extends StatefulWidget {
  static const String routename = 'check_out';
  final double totalAmount;

  const CheckoutScreen({required this.totalAmount});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPaymentMethod;
  String? selectedCountry;
  final addressController = TextEditingController();

  final List<String> countries = [
    'Cairo', 'Giza', 'Minya', 'Beni Suef',
    'Nasr City','Maadi','Faisal','6th of October','Sheikh Zayed','Dokki',
    'Mohandessin','Al Rehab','Al Shorouk','Fayoum'
  ];

  @override
  void initState() {
    super.initState();
    loadSavedAddress();
  }

  void loadSavedAddress() async {
    final saved = await AddressStorage.getAddress();
    setState(() {
      selectedCountry = saved['country'];
      addressController.text = saved['address'] ?? '';
    });
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> confirmOrder() async {
    if (selectedCountry == null || selectedCountry!.isEmpty ||
        addressController.text.trim().isEmpty ||
        selectedPaymentMethod == null) {
      showMessage('Please complete all required fields.');
      return;
    }

    await AddressStorage.saveAddress(selectedCountry!, addressController.text.trim());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        showMessage('Please log in to proceed.');
        return;
      }

      // احضر المنتجات من الكارت (Cubit)
      final cartItems = context.read<CartCubit>().state;
      final itemsJson = cartItems.map((item) => {
        "productId": item.product.producTID,
        "quantity": item.quantity
      }).toList();

      // 1. Create order
      final orderResponse = await http.post(
        Uri.parse('https://localfitt.runasp.net/api/Order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "country": selectedCountry,
          "address": addressController.text.trim(),
          "items": itemsJson
        }),
      );

      if (orderResponse.statusCode != 200 && orderResponse.statusCode != 201) {
        showMessage('Order creation failed ❌');
        return;
      }

      final orderData = jsonDecode(orderResponse.body);
      final orderId = orderData['orderId'];

      if (orderId == null) {
        showMessage('Order ID not found');
        return;
      }

      // 2. Create payment intent
      final paymentResponse = await http.post(
        Uri.parse('https://localfitt.runasp.net/api/payment/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "orderId": orderId,
          "amount": widget.totalAmount,
          "currency": "egp",
          "payment_method": selectedPaymentMethod
        }),
      );

      if (paymentResponse.statusCode == 200 || paymentResponse.statusCode == 201) {
        // 💡 ممكن تعرض صفحة تفاصيل الأوردر لو حبيت
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderId)));
      } else {
        showMessage('Payment failed ❌');
      }
    } catch (e) {
      showMessage('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items: countries.map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                )).toList(),
                onChanged: (val) => setState(() => selectedCountry = val),
                decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              RadioListTile<String>(
                value: 'Cash On Delivery',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => setState(() => selectedPaymentMethod = val),
                title: Text("Cash On Delivery"),
              ),
              RadioListTile<String>(
                value: 'Credit/Debit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => setState(() => selectedPaymentMethod = val),
                title: Text("Credit/Debit Card"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmOrder,
                child: Text("Confirm Payment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
