import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/homescreen.dart'; // تأكدي من أن هذا المسار صحيح

class SignInScreen extends StatefulWidget {
  static const String routename = 'sign_in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  Future<void> handleLogin() async {
    final username = userNameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء إدخال اسم المستخدم وكلمة المرور')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://localfitt.runasp.net/api/User/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userName": username,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // اطبعي الاستجابة كاملة للتأكد من أسماء الحقول
        print("🔵 Server Response on Login: $data");

        // استخراج كل البيانات المطلوبة
        final token = data['token'];
        final custId = data['id'];     // أو data['custId']
        final cartId = data['cartId'];

        // التحقق من وجود كل البيانات الضرورية وأن التوكن كامل
        if (token != null && token.split('.').length == 3 && custId != null && cartId != null) {
          final prefs = await SharedPreferences.getInstance();

          // مسح البيانات القديمة لضمان عدم وجود تداخل
          await prefs.clear();

          // حفظ كل البيانات الجديدة والصحيحة
          await prefs.setString('token', token);
          await prefs.setInt('custId', custId);
          await prefs.setInt('cartId', cartId);

          print('✅ All data saved successfully!');
          print('   - Token: $token');
          print('   - CustID: $custId');
          print('   - CartID: $cartId');

          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routename, (route) => false);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('بيانات غير مكتملة من الخادم (token, id, or cartId is missing)')),
          );
        }
      } else {
        final errorMsg = data['message'] ?? 'فشل تسجيل الدخول';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في الاتصال: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // واجهة المستخدم تبقى كما هي
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'اسم المستخدم'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: handleLogin,
              child: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}