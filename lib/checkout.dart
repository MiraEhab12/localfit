import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/log_in/sign_in.dart';
import 'package:localfit/tabs/shop/confirm%20order.dart';
import '../../clothesofwomen/productwithsize.dart';
class PaymentOptionTile extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final Widget iconWidget;

  const PaymentOptionTile({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.iconWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Colors.deepPurple, // يمكنك تغيير اللون
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(), // يدفع الأيقونة إلى أقصى اليمين
            iconWidget,
          ],
        ),
      ),
    );
  }
}

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
    'Cairo', 'Giza', 'Minya', 'Beni Suef', 'Nasr City', 'Maadi', 'Faisal',
    '6th of October', 'Sheikh Zayed', 'Dokki', 'Mohandessin', 'Al Rehab',
    'Al Shorouk', 'Fayoum',
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
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

    // =================== بداية الإضافة المطلوبة ===================
    // هنا نقوم بحفظ العنوان والمدينة الجديدين في ذاكرة الجهاز
    await prefs.setString('user_address', addressController.text.trim());
    await prefs.setString('user_country', selectedCountry!);
    // =================== نهاية الإضافة المطلوبة ===================

    final token = prefs.getString('token') ?? '';
    print("🔐 Current Token: $token");
    if (token.isEmpty || token.split('.').length != 3) {
      showMessage('من فضلك قم بتسجيل الدخول أولاً.');
      Navigator.pushReplacementNamed(context, SignInScreen.routename);
      return;
    }
    final bodyJson = jsonEncode({
      "cartId": cartId,
      "custid": custId,
      "shippingAddress": "${addressController.text.trim()}, $selectedCountry",
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
    void handlePaymentChange(String? value) {
      setState(() {
        selectedPaymentMethod = value;
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text(" Check out",style: TextStyle(
        fontSize: 24,
      ),
      )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items: countries
                    .map((country) => DropdownMenuItem(value: country, child: Text(country)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCountry = val),
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Payment method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              PaymentOptionTile(
                title: 'Cash On Delivery',
                value: 'Cash',
                groupValue: selectedPaymentMethod,
                onChanged: handlePaymentChange,
                iconWidget: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Cash', style: TextStyle(color: Colors.black54)),
                ),
              ),
              const Divider(),
              PaymentOptionTile(
                title: 'Credit/Debit Card',
                value: 'Card',
                groupValue: selectedPaymentMethod,
                onChanged: handlePaymentChange,
                iconWidget: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.credit_card, color: Colors.black54),
                ),
              ),
              const Divider(),
              PaymentOptionTile(
                title: 'Apple Pay',
                value: 'ApplePay',
                groupValue: selectedPaymentMethod,
                onChanged: handlePaymentChange,
                iconWidget: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.apple, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: confirmOrder,
                  child: const Text("تأكيد الدفع"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
