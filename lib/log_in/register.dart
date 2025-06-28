import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/log_in/otpregister.dart';
import 'package:localfit/log_in/sign_in.dart';

class RegisterScreen extends StatefulWidget {
  static const String routename = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  // --- تم إضافة هذا المتحكم لحقل الرقم الجديد ---
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // --- هذه الدالة لم تتغير، المنطق كما هو ---
  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('https://localfitt.runasp.net/api/User/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userName": name,
          "email": email,
          "password": password,
          "role": "Buyer",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
            "Registration successful. Navigating to OTP screen for email: $email");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOtpScreen(email: email),
          ),
        );
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ?? 'Registration failed';
        showError(errorMsg);
      }
    } catch (e) {
      showError("An error occurred. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ===================================================================
    //  --- بداية تعديل واجهة المستخدم ---
    // ===================================================================
    return Scaffold(
      backgroundColor: Colors.white,
      // --- تم إزالة AppBar ---
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 20),
                // --- عنوان الصفحة ---
                Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),

                // --- حقل الاسم ---
                Text('Name', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Enter your full name" : null,
                ),
                SizedBox(height: 20),

                // --- حقل الإيميل ---
                Text('Email', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter your email";
                    if (!isValidEmail(val)) return "Enter a valid email";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // --- حقل الرقم الجديد ---
                Text('Number', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 8),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Enter your phone number" : null,
                ),
                SizedBox(height: 20),

                // --- حقل كلمة المرور ---
                Text('password', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => isPasswordVisible = !isPasswordVisible),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter a password";
                    if (val.length < 6)
                      return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // --- حقل تأكيد كلمة المرور ---
                Text('Confirm password', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 8),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return "Confirm your password";
                    if (val != passwordController.text)
                      return "Passwords do not match";
                    return null;
                  },
                ),
                SizedBox(height: 40),

                // --- زر التسجيل ---
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6F6559), // اللون البني من الصورة
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: registerUser,
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // --- رابط تسجيل الدخول ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, SignInScreen.routename);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
    // ===================================================================
    //  --- نهاية تعديل واجهة المستخدم ---
    // ===================================================================
  }
}