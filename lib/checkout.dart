import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/thankyou.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressStorage {
  static Future<void> saveAddress(String country, String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_country', country);
    await prefs.setString('user_address', address);
  }

  static Future<Map<String, String?>> getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String? country = prefs.getString('user_country');
    String? address = prefs.getString('user_address');
    return {'country': country, 'address': address};
  }
}

class CheckoutScreen extends StatefulWidget {
  static const String routename = 'check_out';
  final double totalAmount;

  CheckoutScreen({required this.totalAmount});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPaymentMethod;
  String? selectedCountry;
  final addressController = TextEditingController();

  List<String> countries = [
    'Beni Suef',
    '6th of October',
    'Abbassia',
    'Al Maadi',
    'Al Rehab',
    'Al Shorouk',
    'Cairo',
    'Faisal',
    'Garden City',
    'Giza',
    'Minya',
    'Nasr City',
    'New Cairo',
    'Obour City',
    'Sayeda Zeinab',
    'Sharkya',
    'Sheikh Zayed',
    'Shubra',
    'Tahrir Square',
    'Tanta',
    'Zamalek',
    'Fayoum'
  ];

  @override
  void initState() {
    super.initState();
    loadSavedAddress();
  }

  void loadSavedAddress() async {
    final saved = await AddressStorage.getAddress();
    if (saved['country'] != null) {
      setState(() {
        selectedCountry = saved['country'];
        addressController.text = saved['address'] ?? '';
      });
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> confirmOrder() async {
    if (selectedCountry == null || selectedCountry!.isEmpty) {
      showMessage('Please select a city');
      return;
    }
    if (addressController.text.trim().isEmpty) {
      showMessage('Please enter your address');
      return;
    }
    if (selectedPaymentMethod == null) {
      showMessage('Please select a payment method');
      return;
    }

    await AddressStorage.saveAddress(
      selectedCountry!,
      addressController.text.trim(),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        showMessage('User not authenticated. Please log in.');
        return;
      }

      final response = await http.post(
        Uri.parse('https://localfit.runasp.net/api/payment/confirm-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "amount": widget.totalAmount,
          "currency": "egp",
          "payment_method": selectedPaymentMethod,
          "address": addressController.text.trim(),
          "country": selectedCountry,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, ThankYouScreen.routename);
      } else {
        showMessage('Payment confirmation failed ❌');
      }
    } catch (e) {
      showMessage('An error occurred during payment confirmation ❌');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select City", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              value: selectedCountry,
              items: countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCountry = val;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Enter Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextFormField(
              controller: addressController,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Your home address",
              ),
            ),
            SizedBox(height: 30),
            Divider(thickness: 1),
            SizedBox(height: 20),
            Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            RadioListTile<String>(
              title: Row(
                children: [
                  Text("Cash On Delivery"),
                  Spacer(),
                  Icon(Icons.delivery_dining),
                ],
              ),
              value: "Cash On Delivery",
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Text("Credit/Debit Card"),
                  Spacer(),
                  Icon(Icons.credit_card),
                ],
              ),
              value: "Credit/Debit Card",
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Text("Apple Pay"),
                  Spacer(),
                  Icon(Icons.apple),
                ],
              ),
              value: "Apple Pay",
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
            Spacer(),
            Text("Total Amount: ${widget.totalAmount.toStringAsFixed(2)} EGP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: confirmOrder,
                child: Text("Confirm Payment"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
