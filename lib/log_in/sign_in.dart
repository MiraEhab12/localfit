import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localfit/log_in/forgotpassword.dart';
import 'package:localfit/log_in/register.dart';
import '../api_manager_for_sign_in/apimanager.dart';

class SignInScreen extends StatefulWidget {
  static const String routename = 'sign in';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordValid = true;

  String emailErrorText = '';
  String passwordErrorText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool validateInputs() {
    bool isValid = true;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        isEmailValid = false;
        emailErrorText = 'Email is required';
      });
      isValid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        isEmailValid = false;
        emailErrorText = 'Enter a valid email';
      });
      isValid = false;
    } else {
      setState(() {
        isEmailValid = true;
        emailErrorText = '';
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

  void handleLogin() async {
    if (!validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiManager().getemailandpassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      if (response['success'] == true) {
        showSnackBar('Login successful!');
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false, // Remove all previous routes
        );
      } else {
        final error = response['error']?.toString().toLowerCase() ?? '';
        final message = response['message'] ?? 'An error occurred';

        setState(() {
          if (error.contains('email')) {
            isEmailValid = false;
            emailErrorText = message;
          } else {
            isEmailValid = true;
            emailErrorText = '';
          }

          if (error.contains('password')) {
            isPasswordValid = false;
            passwordErrorText = message;
          } else {
            isPasswordValid = true;
            passwordErrorText = '';
          }

          if (!error.contains('email') && !error.contains('password')) {
            showSnackBar(message, isError: true);
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar('Something went wrong. Please try again.', isError: true);
    }
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
              const Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email', style: TextStyle(color: Color(0xff000000))),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: isEmailValid ? null : emailErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isEmailValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isEmailValid ? Colors.blue : Colors.red,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Password', style: TextStyle(color: Color(0xff000000))),
              ),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
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
                  errorText: isPasswordValid ? null : passwordErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isPasswordValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isPasswordValid ? Colors.blue : Colors.red,
                      width: 2,
                    ),
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
                    'Forgot password?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5C5545),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Color(0xffffffff)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  showSnackBar('Google Sign-In not implemented yet.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.black12),
                ),
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text(
                  'Sign With Google',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


