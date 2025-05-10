import 'package:flutter/material.dart';
import 'activationcodescreen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routename='forgot password';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Forgot Password", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone))),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ActivationCodeScreen()));
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}