import 'package:flutter/material.dart';

class Contactus extends StatelessWidget {
  const Contactus({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/contactus.png"),
            ],
          ),
        ),
      ),
    );
  }
}
