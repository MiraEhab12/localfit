import 'package:flutter/material.dart';
import 'package:localfit/homescreen.dart';
import '../api_manager_for_sign_in/apimanager.dart';
import 'sign_in.dart';

class RegisterScreen extends StatefulWidget {
  static const String routename = 'register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordVisible = false;
  bool isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isNameValid = true;
  bool isEmailValid = true;
  bool isPhoneValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;

  String nameError = '';
  String emailError = '';
  String phoneError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty) {
      isNameValid = false;
      nameError = 'Name is required';
      isValid = false;
    } else {
      isNameValid = true;
      nameError = '';
    }

    if (email.isEmpty) {
      isEmailValid = false;
      emailError = 'Email is required';
      isValid = false;
    } else if (!isValidEmail(email)) {
      isEmailValid = false;
      emailError = 'Enter a valid email (e.g., user@domain.com)';
      isValid = false;
    } else {
      isEmailValid = true;
      emailError = '';
    }

    if (phone.isEmpty) {
      isPhoneValid = false;
      phoneError = 'Phone is required';
      isValid = false;
    } else if (!RegExp(r'^\+?\d{10,15}$').hasMatch(phone)) {
      isPhoneValid = false;
      phoneError = 'Enter a valid phone number';
      isValid = false;
    } else {
      isPhoneValid = true;
      phoneError = '';
    }

    if (password.isEmpty) {
      isPasswordValid = false;
      passwordError = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      isPasswordValid = false;
      passwordError = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      isPasswordValid = true;
      passwordError = '';
    }

    if (confirmPassword.isEmpty) {
      isConfirmPasswordValid = false;
      confirmPasswordError = 'Confirm password is required';
      isValid = false;
    } else if (password != confirmPassword) {
      isConfirmPasswordValid = false;
      confirmPasswordError = 'Passwords do not match';
      isValid = false;
    } else {
      isConfirmPasswordValid = true;
      confirmPasswordError = '';
    }

    setState(() {});
    return isValid;
  }

  void handleRegister() async {
    if (!validateInputs()) return;

    setState(() => isLoading = true);

    try {
      final response = await ApiManager().sendregister(
          nameController.text.trim(),  // userName
          emailController.text.trim(),
          passwordController.text.trim(),
          "user"  // role افتراضياً


    );

      setState(() => isLoading = false);

      if (response['success'] == true) {
        showSnackBar('Registration successful!');
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routename,
              (route) => false,
        );
      } else {
        final error = response['error']?.toString().toLowerCase() ?? '';
        final message = response['message'] ?? 'Registration failed';

        setState(() {
          if (error.contains('email')) {
            isEmailValid = false;
            emailError = message;
          } else {
            isEmailValid = true;
            emailError = '';
          }

          if (error.contains('phone')) {
            isPhoneValid = false;
            phoneError = message;
          } else {
            isPhoneValid = true;
            phoneError = '';
          }

          if (error.contains('password')) {
            isPasswordValid = false;
            passwordError = message;
          } else {
            isPasswordValid = true;
            passwordError = '';
          }

          if (!error.contains('email') &&
              !error.contains('phone') &&
              !error.contains('password')) {
            showSnackBar(message, isError: true);
          }
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      showSnackBar('Something went wrong. Please try again.', isError: true);
    }
  }

  Widget customTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isValid,
    required String errorText,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hint,
            errorText: isValid ? null : errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isValid ? Colors.grey : Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isValid ? Colors.blue : Colors.red,
                width: 2,
              ),
            ),
            prefixIcon: label.toLowerCase().contains('name')
                ? const Icon(Icons.person)
                : label.toLowerCase().contains('email')
                ? const Icon(Icons.email)
                : label.toLowerCase().contains('phone')
                ? const Icon(Icons.phone)
                : const Icon(Icons.lock),
            suffixIcon: isPassword
                ? IconButton(
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
            )
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              customTextField(
                controller: nameController,
                label: 'Full Name',
                hint: 'Enter your name',
                isValid: isNameValid,
                errorText: nameError,
                keyboardType: TextInputType.name,
              ),
              customTextField(
                controller: emailController,
                label: 'Email',
                hint: 'user@domain.com',
                isValid: isEmailValid,
                errorText: emailError,
                keyboardType: TextInputType.emailAddress,
              ),
              customTextField(
                controller: phoneController,
                label: 'Phone Number',
                hint: 'Enter your phone',
                isValid: isPhoneValid,
                errorText: phoneError,
                keyboardType: TextInputType.phone,
              ),
              customTextField(
                controller: passwordController,
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
                isValid: isPasswordValid,
                errorText: passwordError,
              ),
              customTextField(
                controller: confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                isPassword: true,
                isValid: isConfirmPasswordValid,
                errorText: confirmPasswordError,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5C5545),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignInScreen.routename);
                },
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
