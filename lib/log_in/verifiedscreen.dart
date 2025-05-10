import 'package:flutter/material.dart';
import 'package:localfit/homescreen.dart';

class VerifiedScreen extends StatefulWidget {
  @override
  _VerifiedScreenState createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Expanded(
            flex: 2,
            child: Container(
              color: Colors.brown,
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check, size: 60, color: Colors.brown),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  "Verified",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
