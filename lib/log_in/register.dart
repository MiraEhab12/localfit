import 'package:flutter/material.dart';
import 'sign_in.dart';

class RegisterScreen extends StatefulWidget {
  static const String routename= 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Register", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person))),
            TextField(decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email))),
            TextField(decoration: InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone))),
            TextField(
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
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
              ),

            ),
            TextField(
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock),
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
              ),

            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.routename);
              },
              child: Text("Already have an account? Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}