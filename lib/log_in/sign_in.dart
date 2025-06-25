import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localfit/homescreen.dart';
import 'package:localfit/log_in/forgotpassword.dart';
import 'package:localfit/log_in/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class SignInScreen extends StatefulWidget {
  static const String routename = 'sign in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isUsernameValid = true;
  bool isPasswordValid = true;

  String usernameErrorText = '';
  String passwordErrorText = '';

  bool validateInputs() {
    bool isValid = true;
    final userName = userNameController.text.trim();
    final password = passwordController.text.trim();

    if (userName.isEmpty) {
      setState(() {
        isUsernameValid = false;
        usernameErrorText = 'Username is required';
      });
      isValid = false;
    } else {
      setState(() {
        isUsernameValid = true;
        usernameErrorText = '';
      });
    }

    if (password.isEmpty) {
      setState(() {
        isPasswordValid = false;
        passwordErrorText = 'Password is required';
      });
      isValid = false;
    } else {
      setState(() {
        isPasswordValid = true;
        passwordErrorText = '';
      });
    }

    return isValid;
  }

  Future<void> handleLogin() async {
    if (!validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    final username = userNameController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('https://localfit.runasp.net/api/User/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userName": username,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final token = data['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routename, (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: Token not received')),
          );
        }
      } else if (response.statusCode == 401) {
        final errorMsg = data['message'] ?? 'Unauthorized';
        if (errorMsg.contains('Email not verified')) {
          _showEmailNotVerifiedDialog(username);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
        }
      } else {
        final errorMsg = data['message'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showEmailNotVerifiedDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Email Not Verified'),
        content: const Text(
            'Your email is not verified. Please verify your email before logging in.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await resendVerificationEmail(email);
            },
            child: const Text('Resend Verification Email'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> resendVerificationEmail(String email) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://localfit.runasp.net/api/User/resend-verification-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent. Please check your inbox.')),
        );
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ??
            'Failed to resend verification email';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Username'),
              ),
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  errorText: isUsernameValid ? null : usernameErrorText,
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Password'),
              ),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  errorText: isPasswordValid ? null : passwordErrorText,
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, ForgotPasswordScreen.routename);
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: handleLogin,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, RegisterScreen.routename);
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
