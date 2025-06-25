import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/sellerscreen/homeseller.dart';

class BrandNameScreen extends StatefulWidget {
  static const String routename = 'brandname';

  const BrandNameScreen({Key? key}) : super(key: key);

  @override
  State<BrandNameScreen> createState() => _BrandNameScreenState();
}

class _BrandNameScreenState extends State<BrandNameScreen> {
  final TextEditingController brandNameController = TextEditingController();

  void onCreatePressed() async {
    final brandName = brandNameController.text.trim();

    if (brandName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a brand name')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('brandName', brandName); // حفظ اسم البراند

    // بعد الحفظ ننتقل لصفحة البائع مع passing arguments true
    Navigator.pushReplacementNamed(context, Homeseller.routename,
        arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Brand Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Let us know your brand name"),
            Text("we will use this name to identify\n your account and it will be visible to customer on \napplication"),
            TextField(
              controller: brandNameController,
              decoration: InputDecoration(
                labelText: 'Brand Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onCreatePressed,
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
