// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:localfit/homescreen.dart'; // تأكد من استدعاء شاشة التسجيل
// import 'package:localfit/log_in/register.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SignInScreen extends StatefulWidget {
//   static const String routename = 'sign_in';
//
//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   // --- هذا الجزء لم يتغير (المنطق) ---
//   final TextEditingController userNameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;
//   bool isPasswordVisible = false;
//
//   Future<void> handleLogin() async {
//     final username = userNameController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('الرجاء إدخال البريد الإلكتروني وكلمة المرور')),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://localfitt.runasp.net/api/User/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "userName": username,
//           "password": password,
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         final token = data['token'];
//
//         if (token != null && token.split('.').length == 3) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', token);
//
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             HomeScreen.routename,
//                 (route) => false,
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('التوكن غير صالح أو غير موجود')),
//           );
//         }
//       } else {
//         final errorMsg = data['message'] ?? 'فشل تسجيل الدخول';
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMsg)),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ في الاتصال: $e')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     userNameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//   // --- نهاية الجزء الذي لم يتغير ---
//
//   @override
//   Widget build(BuildContext context) {
//     // ===================================================================
//     //  --- بداية تعديل واجهة المستخدم ---
//     // ===================================================================
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: ListView(
//             children: [
//               SizedBox(height: 50),
//               // --- عنوان الصفحة ---
//               Text(
//                 'Sign In',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 40),
//
//               // --- حقل الإيميل ---
//               Text('UserNmae', style: TextStyle(color: Colors.black54, fontSize: 16)),
//               SizedBox(height: 8),
//               TextFormField(
//                 controller: userNameController, // نفس المتحكم الأصلي
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: "Enter Your username",
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
//                   contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.blue, width: 1.5),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // --- حقل كلمة المرور ---
//               Text('Password', style: TextStyle(color: Colors.black54, fontSize: 16)),
//               SizedBox(height: 8),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: !isPasswordVisible,
//                 decoration: InputDecoration(
//                   hintText: "Enter Your Password",
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       isPasswordVisible ? Icons.visibility_outlined: Icons.visibility_off_outlined,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         isPasswordVisible = !isPasswordVisible;
//                       });
//                     },
//                   ),
//                   contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.blue, width: 1.5),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               // --- رابط نسيت كلمة المرور ---
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     // يمكنك إضافة وظيفة نسيت كلمة المرور هنا
//                   },
//                   child: Text(
//                     'Forgot password',
//                     style: TextStyle(
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),
//
//               // --- زر تسجيل الدخول ---
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF6F6559), // اللون البني من الصورة
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   onPressed: handleLogin, // نفس الدالة الأصلية
//                   child: Text('sign in'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // --- رابط إنشاء حساب جديد في الأسفل ---
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Dont have an account ? ",
//               style: TextStyle(color: Colors.black54),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.pushNamed(context, RegisterScreen.routename);
//               },
//               child: Text(
//                 "Register",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//     // ===================================================================
//     //  --- نهاية تعديل واجهة المستخدم ---
//     // ===================================================================
//   }
// }
//
//
//
//
//




























import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/homescreen.dart';
import 'package:localfit/log_in/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // --- قم باستبدال هذه الدالة بالكامل في ملفك ---
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
        final token = data['token'];

        // =======================================================
        //  *** هذا هو السطر الوحيد الذي تم تعديله ***
        //  نقرأ الآن من داخل كائن "user" وبالمفتاح الصحيح "userId"
        final custId = data['user']?['userId'];
        // =======================================================

        if (token != null && custId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setInt('custId', custId); // سيتم حفظ رقم 6 هنا

          print("✅ تم تسجيل الدخول بنجاح: تم حفظ التوكن و CustID ($custId).");

          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routename,
                (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid response from server (token or ID missing)')),
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
    // واجهة المستخدم الجميلة الخاصة بك تبقى كما هي بدون تغيير
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              SizedBox(height: 50),
              Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),

              Text('Username', style: TextStyle(color: Colors.black54, fontSize: 16)),
              SizedBox(height: 8),
              TextFormField(
                controller: userNameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter Your username",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6F6559), width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text('Password', style: TextStyle(color: Colors.black54, fontSize: 16)),
              SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Enter Your Password",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility_outlined: Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6F6559), width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              isLoading
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF6F6559)))
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6F6559),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: handleLogin,
                  child: Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(color: Colors.black54),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RegisterScreen.routename);
              },
              child: Text(
                "Register",
                style: TextStyle(
                  color: Color(0xFF6F6559),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}