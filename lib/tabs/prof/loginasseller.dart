// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:jwt_decode/jwt_decode.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:localfit/sellerscreen/tabs/brandname.dart';
// import 'package:localfit/sellerscreen/homeseller.dart';
//
// class SellerLoginScreen extends StatefulWidget {
//   static const String routename = 'seller_login';
//
//   @override
//   State<SellerLoginScreen> createState() => _SellerLoginScreenState();
// }
//
// class _SellerLoginScreenState extends State<SellerLoginScreen> {
//   final TextEditingController userNameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   bool isLoading = false;
//   bool isPasswordVisible = false;
//
//   Future<void> _handleSellerLogin() async {
//     final username = userNameController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please enter username and password')));
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://localfitt.runasp.net/api/User/admin/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "userName": username,
//           "password": password,
//         }),
//       );
//
//       print('🔄 Login response code: ${response.statusCode}');
//       final data = jsonDecode(response.body);
//       print('📥 Login response body: $data');
//
//       if (response.statusCode == 200) {
//         final token = data['token'];
//
//         if (token == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Login failed: Token not received')));
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }
//
//         // استخراج الدور من الرد أو من التوكن JWT
//         String role = '';
//
//         if (data.containsKey('role')) {
//           role = data['role'];
//           print('Role from response field: $role');
//         } else {
//           Map<String, dynamic> payload = Jwt.parseJwt(token);
//           print('Decoded JWT payload: $payload');
//
//           role = payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
//               payload['role'] ??
//               'unknown';
//           print('Role extracted from JWT: $role');
//         }
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.clear(); // مسح أي بيانات قديمة
//         await prefs.setString('token', token);
//         await prefs.setString('userRole', role); // خزن الدور الحقيقي
//
//         print('User role saved: $role');
//
//         // التنقل بناءً على الدور المستخرج
//         if (role.toLowerCase() == 'admin') {
//           // ادمن ينقل للصفحة الرئيسية مباشرة
//           Navigator.pushReplacementNamed(context, Homeseller.routename, arguments: true);
//         } else if (role.toLowerCase() == 'seller') {
//           final savedBrandName = prefs.getString('brandName');
//           if (savedBrandName == null || savedBrandName.isEmpty) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => CreateBrandScreen()),
//             );
//           } else {
//             Navigator.pushReplacementNamed(context, Homeseller.routename, arguments: true);
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Access denied: Your role is $role')),
//           );
//         }
//       } else {
//         final errorMsg = data['message'] ?? 'Login failed';
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(errorMsg)));
//       }
//     } catch (e) {
//       print('Login error: $e');
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Seller Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: userNameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: passwordController,
//               obscureText: !isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 suffixIcon: IconButton(
//                   icon: Icon(isPasswordVisible
//                       ? Icons.visibility
//                       : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       isPasswordVisible = !isPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: _handleSellerLogin,
//               child: Text('Login as Seller'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
