import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'orderdetailes.dart';
import 'package:localfit/log_in/sign_in.dart'; // تأكد إن الملف دا موجود

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
  int? cartId;
  int? custId;

  final List<String> countries = [
    'Cairo', 'Giza', 'Minya', 'Beni Suef',
    'Nasr City', 'Maadi', 'Faisal', '6th of October',
    'Sheikh Zayed', 'Dokki', 'Mohandessin',
    'Al Rehab', 'Al Shorouk', 'Fayoum'
  ];

  @override
  void initState() {
    super.initState();
    loadSavedAddress();
    loadCartAndCustomerIds();
  }

  Future<void> loadCartAndCustomerIds() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cartId = prefs.getInt('cartId');
      custId = prefs.getInt('custId');
    });
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
      showMessage('من فضلك أكمل جميع الحقول المطلوبة.');
      return;
    }

    if (cartId == null || custId == null) {
      showMessage('خطأ في بيانات المستخدم أو السلة. يرجى تسجيل الدخول مجددًا.');
      return;
    }

    await AddressStorage.saveAddress(selectedCountry!, addressController.text.trim());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print("🔐 Current Token: $token");

      if (token.isEmpty) {
        showMessage('من فضلك قم بتسجيل الدخول أولاً.');
        Navigator.pushReplacementNamed(context, SignInScreen.routename);
        return;
      }

      final bodyJson = jsonEncode({
        "cartId": cartId,
        "custid": custId,
        "shippingAddress": addressController.text.trim(),
      });

      print("🔵 Sending Order Creation Request: $bodyJson");

      final response = await http.post(
        Uri.parse('https://localfitt.runasp.net/api/Order/createorder'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyJson,
      );

      print("🟢 Status Code: ${response.statusCode}");
      print("🟡 Response Body: ${response.body}");

      if (response.statusCode == 401) {
        showMessage("انتهت صلاحية الجلسة. الرجاء تسجيل الدخول مرة أخرى.");
        Navigator.pushReplacementNamed(context, SignInScreen.routename);
        return;
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        showMessage("فشل في إنشاء الطلب. تأكد من تسجيل الدخول وتوفر بيانات صحيحة.");
        return;
      }

      final data = jsonDecode(response.body);
      final orderId = data['orderId'] ?? data['id'] ?? data['orderID'];

      if (orderId == null) {
        showMessage("لم يتم العثور على رقم الطلب.");
        return;
      }

      final username = prefs.getString('username') ?? 'User';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
            orderId: orderId,
            username: username,
            shippingAddress: addressController.text.trim(),
            totalAmount: widget.totalAmount,
          ),
        ),
      );
    } catch (e) {
      showMessage('حدث خطأ أثناء إنشاء الطلب: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إتمام الشراء")),
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
                decoration: InputDecoration(labelText: 'المدينة', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              RadioListTile<String>(
                value: 'Cash',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => setState(() => selectedPaymentMethod = val),
                title: Text("الدفع عند الاستلام"),
              ),
              RadioListTile<String>(
                value: 'Card',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => setState(() => selectedPaymentMethod = val),
                title: Text("بطاقة إئتمان/خصم"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmOrder,
                child: Text("تأكيد الدفع"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
