import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/log_in/sign_in.dart';
import 'package:localfit/tabs/shop/confirm%20order.dart';
import '../../clothesofwomen/productwithsize.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routename = 'check_out';
  final List<ProductWithSizeAndQuantity> cartItems;
  final double totalAmount;

  const CheckoutScreen({
    required this.totalAmount,
    required this.cartItems,
    Key? key,
  }) : super(key: key);

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
    'Cairo',
    'Giza',
    'Minya',
    'Beni Suef',
    'Nasr City',
    'Maadi',
    'Faisal',
    '6th of October',
    'Sheikh Zayed',
    'Dokki',
    'Mohandessin',
    'Al Rehab',
    'Al Shorouk',
    'Fayoum',
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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCountry = prefs.getString('user_country');
      addressController.text = prefs.getString('user_address') ?? '';
    });
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> confirmOrder() async {
    if (selectedCountry == null ||
        selectedCountry!.isEmpty ||
        addressController.text.trim().isEmpty ||
        selectedPaymentMethod == null) {
      showMessage('من فضلك أكمل جميع الحقول المطلوبة.');
      return;
    }

    if (cartId == null || custId == null) {
      showMessage('خطأ في بيانات المستخدم أو السلة. يرجى تسجيل الدخول مجددًا.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print("🔐 Current Token: $token");

    if (token.isEmpty || !token.contains('.')) {
      showMessage('من فضلك قم بتسجيل الدخول أولاً.');
      Navigator.pushReplacementNamed(context, SignInScreen.routename);
      return;
    }

    final bodyJson = jsonEncode({
      "cartId": cartId,
      "custid": custId,
      "shippingAddress": addressController.text.trim(),
      "paymentMethod": selectedPaymentMethod,
    });

    print("🔵 Sending Order Creation Request: $bodyJson");

    try {
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderConfirmationScreen(),
        ),
      );
    } catch (e) {
      showMessage('حدث خطأ أثناء إنشاء الطلب: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إتمام الشراء")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items: countries
                    .map(
                      (country) => DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  ),
                )
                    .toList(),
                onChanged: (val) => setState(() => selectedCountry = val),
                decoration: const InputDecoration(
                  labelText: 'المدينة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              RadioListTile<String>(
                value: 'Cash',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => setState(() => selectedPaymentMethod = val),
                title: const Text("الدفع عند الاستلام"),
              ),
              RadioListTile<String>(
                value: 'Card',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => setState(() => selectedPaymentMethod = val),
                title: const Text("بطاقة إئتمان/خصم"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmOrder,
                child: const Text("تأكيد الدفع"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
