import 'package:flutter/material.dart';
import 'resetpassword.dart';

class ActivationCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Activation Code", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 40,
                height: 50,
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text("5")),
              )),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Resend the code"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
              },
              child: Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}