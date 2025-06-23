import 'package:flutter/material.dart';


class Textfieldinpersonaldatailsscreen extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;


  const Textfieldinpersonaldatailsscreen({

    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
