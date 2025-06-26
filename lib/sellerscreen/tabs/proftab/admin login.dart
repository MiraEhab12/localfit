import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/sellerscreen/tabs/brandname.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // تأكد من صحة المسار هذا

class AdminLoginScreen extends StatefulWidget {
  static const String routename = 'admin_login';

  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // 1. التحقق من أن الفورم صالح
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. تجهيز الطلب للـ API
      // ملاحظة: بناءً على الروابط التي أرسلتها، أفترض أن رابط تسجيل الدخول هو /login
      // إذا كان مختلفًا، قم بتغييره هنا.
      final uri = Uri.parse('https://localfitt.runasp.net/api/User/admin/login');
      final headers = {'Content-Type': 'application/json'};
      // تأكد من أن الـ API يتوقع 'username' و 'password' بهذه الأسماء
      final body = jsonEncode({
        'username': _usernameController.text.trim(),
        'password': _passwordController.text,
      });

      // 3. إرسال الطلب
      final response = await http.post(uri, headers: headers, body: body);

      // 4. التعامل مع الرد
      if (response.statusCode == 200) {
        // نجاح تسجيل الدخول
        final responseData = jsonDecode(response.body);
        final token = responseData['token']; // أفترض أن المفتاح هو 'token'

        if (token != null) {
          // 5. حفظ التوكن في SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          // *** نقطة مهمة جداً: استخدام نفس المفتاح 'jwt_token' ***
          await prefs.setString('jwt_token', token);

          print('✅ تم تسجيل الدخول بنجاح وحفظ التوكن.');

          // 6. الانتقال إلى شاشة إنشاء البراند
          // نستخدم pushReplacementNamed لكي لا يستطيع المستخدم الرجوع لصفحة تسجيل الدخول
          if (mounted) {
            Navigator.pushReplacementNamed(context, CreateBrandScreen.routename);
          }
        } else {
          throw Exception('Token not found in response');
        }
      } else {
        // فشل تسجيل الدخول (مثل كلمة مرور خاطئة)
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Invalid username or password.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      // التعامل مع أخطاء الشبكة أو أي أخطاء أخرى
      print('Login Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      // إيقاف مؤشر التحميل في كل الحالات
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller / Admin Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome, Seller!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Login to manage your brand and products',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your username' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                      : Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}