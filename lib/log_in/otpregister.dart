import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/log_in/sign_in.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({required this.email, super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;
  bool isResending = false;
  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    secondsRemaining = 30;
    timer?.cancel(); // يلغي التيمر القديم لو موجود
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  Future<void> verifyEmail() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      showMessage('Please enter a 6-digit OTP');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://localfitt.runasp.net/api/User/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": widget.email, "otp": otp}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showMessage('✅ Email verified successfully!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => SignInScreen()),
              (route) => false,
        );
      } else {
        showMessage(body['message'] ?? 'Verification failed');
      }
    } catch (e) {
      showMessage('An error occurred: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resendVerificationEmail() async {
    setState(() {
      isResending = true;
      secondsRemaining = 30;
    });

    try {
      final response = await http.post(
        Uri.parse('https://localfitt.runasp.net/api/User/resend-verification-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": widget.email}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showMessage('📩 OTP resent successfully!');
        startCountdown();
      } else {
        showMessage(body['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      showMessage('An error occurred: $e');
    } finally {
      setState(() => isResending = false);
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'An OTP has been sent to:',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Enter 6-digit OTP',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              onChanged: (value) {
                if (value.length == 6) {
                  verifyEmail();
                }
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: verifyEmail,
                child: const Text('Verify Email'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Resend OTP in $secondsRemaining seconds',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            isResending
                ? const CircularProgressIndicator()
                : TextButton(
              onPressed:
              secondsRemaining == 0 ? resendVerificationEmail : null,
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  color:
                  secondsRemaining == 0 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
