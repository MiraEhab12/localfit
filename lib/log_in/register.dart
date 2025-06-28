// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:localfit/appcolor/appcolors.dart';
// import 'package:localfit/log_in/otpregister.dart';
// import 'package:localfit/log_in/sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class RegisterScreen extends StatefulWidget {
//   static const String routename = 'register';
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   bool isPasswordVisible = false;
//   bool isLoading = false;
//
//   bool isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     return emailRegex.hasMatch(email);
//   }
//
//   Future<void> registerUser() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final name = nameController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://localfitt.runasp.net/api/User/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "userName": name,
//           "email": email,
//           "password": password,
//           "role": "Buyer",
//         }),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final cartId = data['cartId'];
//         final custId = data['custid'];
//         final token = data['token']; // ⬅️ تأكد السيرفر بيرجعه
//         final username = data['userName'] ?? name;
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setInt('cartId', cartId);
//         await prefs.setInt('custId', custId);
//         await prefs.setString('token', token);         // ⬅️ تخزين التوكن
//         await prefs.setString('username', username);   // ⬅️ مفيد للعرض بعدين
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => VerifyOtpScreen(email: email),
//           ),
//         );
//       } else {
//         final errorMsg =
//             jsonDecode(response.body)['message'] ?? 'Registration failed';
//         showError(errorMsg);
//       }
//     } catch (e) {
//       showError("An error occurred. Please try again.");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Register'),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Full Name"),
//                 validator: (val) =>
//                 val == null || val.isEmpty ? "Enter your full name" : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(labelText: "Email"),
//                 validator: (val) {
//                   if (val == null || val.isEmpty) return "Enter your email";
//                   if (!isValidEmail(val)) return "Enter a valid email";
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: !isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   suffixIcon: IconButton(
//                     icon: Icon(isPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                     onPressed: () =>
//                         setState(() => isPasswordVisible = !isPasswordVisible),
//                   ),
//                 ),
//                 validator: (val) {
//                   if (val == null || val.isEmpty) return "Enter a password";
//                   if (val.length < 6)
//                     return "Password must be at least 6 characters";
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: confirmPasswordController,
//                 obscureText: !isPasswordVisible,
//                 decoration: InputDecoration(labelText: "Confirm Password"),
//                 validator: (val) {
//                   if (val == null || val.isEmpty)
//                     return "Confirm your password";
//                   if (val != passwordController.text)
//                     return "Passwords do not match";
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.maindarkcolor,
//                   foregroundColor: Colors.white,
//                 ),
//                 onPressed: registerUser,
//                 child: Text("Register"),
//               ),
//               SizedBox(height: 350),
//               Padding(
//                 padding: const EdgeInsets.only(left: 70),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(context, SignInScreen.routename);
//                   },
//                   child: Text(
//                     "Already have an account? Sign In",
//                     style: TextStyle(color: AppColors.maindarkcolor),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/log_in/otpregister.dart';
import 'package:localfit/log_in/sign_in.dart';
// لا نحتاج SharedPreferences هنا بعد الآن

class RegisterScreen extends StatefulWidget {
  static const String routename = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // --- تم تعديل هذه الدالة بالكامل ---
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
        // تم التسجيل بنجاح، لا نحفظ أي شيء هنا.
        // وظيفتنا فقط هي الانتقال لشاشة تفعيل الكود.
        print("Registration successful. Navigating to OTP screen for email: $email");

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
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    // واجهة المستخدم تبقى كما هي بدون تغيير
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter your full name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter your email";
                  if (!isValidEmail(val)) return "Enter a valid email";
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
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
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(labelText: "Confirm Password"),
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return "Confirm your password";
                  if (val != passwordController.text)
                    return "Passwords do not match";
                  return null;
                },
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maindarkcolor,
                  foregroundColor: Colors.white,
                ),
                onPressed: registerUser,
                child: Text("Register"),
              ),
              SizedBox(height: 350),
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SignInScreen.routename);
                  },
                  child: Text(
                    "Already have an account? Sign In",
                    style: TextStyle(color: AppColors.maindarkcolor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}