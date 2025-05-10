import 'package:flutter/material.dart';
import 'package:localfit/log_in/forgotpassword.dart';
import 'package:localfit/log_in/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class SignInScreen extends StatefulWidget {
  static const String routename='sign in';
const SignInScreen({super.key});

@override
State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
bool isPasswordVisible = false; // حالة إظهار كلمة المرور

@override
Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.white,
body: Padding(
padding: const EdgeInsets.symmetric(horizontal: 24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Center(
child: Text(
"Sign In",
style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
),
),
const SizedBox(height: 32),
const Text("Email",style: TextStyle(color: Color(0xff000000))),
TextField(
decoration: InputDecoration(
hintText: "Enter Your Email",
prefixIcon: const Icon(Icons.email_outlined),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
),
),
),
const SizedBox(height: 16),
const Text("Password",style: TextStyle(color: Color(0xff000000)),),
TextField(
obscureText: !isPasswordVisible,
decoration: InputDecoration(
hintText: "Enter Your Password",
prefixIcon: const Icon(Icons.lock_outline),
suffixIcon: IconButton(
icon: Icon(
isPasswordVisible ? Icons.visibility : Icons.visibility_off,
),
onPressed: () {
setState(() {
isPasswordVisible = !isPasswordVisible;
});
},
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
),
),
),
const SizedBox(height: 8),
Align(
alignment: Alignment.centerRight,
child: TextButton(
onPressed: () {
  Navigator.pushNamed(context, ForgotPasswordScreen.routename);
},
child: const Text(
"Forgot password",
style: TextStyle(color: Colors.black54),
),
),
),
const SizedBox(height: 16),
ElevatedButton(
onPressed: () {},
style: ElevatedButton.styleFrom(
backgroundColor: Color(0xff5C5545),
minimumSize: const Size(double.infinity, 50),
),
child: const Text("Sign In",style: TextStyle(color: Color(0xffffffff)),),
),
const SizedBox(height: 16),
Row(
children: const [
Expanded(child: Divider()),
Padding(
padding: EdgeInsets.symmetric(horizontal: 10),
child: Text("OR"),
),
Expanded(child: Divider()),
],
),
const SizedBox(height: 16),
ElevatedButton.icon(
onPressed: () {},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.white,
minimumSize: const Size(double.infinity, 50),
side: const BorderSide(color: Colors.black12),
),
icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
label: const Text(
"Sign With Google",
style: TextStyle(color: Colors.black),
),
),
const SizedBox(height: 16),
Center(
child: TextButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(builder: (context) =>   RegisterScreen()),
);
},
child: const Text(
"Don't have an account? Register",
style: TextStyle(color: Colors.black54),
),
),
),
],
),
),
);
}
}