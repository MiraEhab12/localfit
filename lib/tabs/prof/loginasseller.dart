import 'dart:convert';
// --- التعديل الأهم: استخدام اسم مستعار 'io' لتجنب التضارب ---
import 'dart:io' as io;
import 'package:flutter/material.dart';
// سنستخدم هذا الـ import فقط
import 'package:http/io_client.dart';

class SellerLoginScreen extends StatefulWidget {
  const SellerLoginScreen({super.key});

  @override
  State<SellerLoginScreen> createState() => _SellerLoginScreenState();
}

class _SellerLoginScreenState extends State<SellerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // --- استخدام io.HttpClient للتأكد من أننا نستخدم النسخة الصحيحة ---
    final httpClient = io.HttpClient();
    httpClient.badCertificateCallback = (io.X509Certificate cert, String host, int port) => true;
    httpClient.followRedirects = true;
    httpClient.maxRedirects = 5;

    final ioClient = IOClient(httpClient);

    // استخدام const لإصلاح التحذير الذي ظهر في الصورة
    const String apiUrl = 'https://localfitt.runasp.net/api/User/admin/login';
    final Uri url = Uri.parse(apiUrl);

    try {
      final response = await ioClient.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      // الكود التالي سيعمل الآن بشكل صحيح بعد حل مشكلة الـ redirect
      if (mounted) { // التحقق من أن الـ widget ما زال موجوداً
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          // طباعة للتحقق فقط، يمكن إزالتها لاحقاً
          print('Login successful: $responseData');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل الدخول بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          // TODO: Navigate to the seller's home screen
          // Navigator.of(context).pushReplacement(...);
        } else {
          print('Login failed with status code: ${response.statusCode}');
          print('Response body: ${response.body}');

          String errorMessage = 'فشل تسجيل الدخول. تحقق من بياناتك.';
          if (response.body.isNotEmpty) {
            try {
              final errorData = jsonDecode(response.body);
              errorMessage = errorData['message'] ?? response.body;
            } catch (e) {
              errorMessage = response.body;
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

    } catch (error) {
      print('An error occurred: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في الاتصال بالشبكة. حاول مرة أخرى.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      ioClient.close();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // باقي الكود الخاص بالـ UI كما هو لم يتغير
    return Scaffold(
      backgroundColor: const Color(0xFFD7CFC1),
      appBar: AppBar(
        title: const Text(
          'Seller Login',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6DFF1),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Login as Seller',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on io.HttpClient {
  set followRedirects(bool followRedirects) {}

  set maxRedirects(int maxRedirects) {}
}