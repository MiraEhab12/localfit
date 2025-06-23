import 'package:flutter/material.dart';
import 'package:localfit/sellerscreen/tabs/proftab/textfield.dart';
class Personaldetailedscreen extends StatelessWidget {
  static const String routename='personal detailed';
  Personaldetailedscreen({super.key});
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Personal details",style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
            SizedBox(
              height: 40,
            ),
            Text("First Name"),
            SizedBox(
              height: 12,
            ),
            Textfieldinpersonaldatailsscreen(
              label: 'first names',
              controller: firstNameController,
            ),
            SizedBox(
              height: 24,
            ),
            Text("Last Name"),
            SizedBox(
              height: 12,
            ),
            Textfieldinpersonaldatailsscreen(
              label: 'last name',
              controller: lastNameController,
            ),
            SizedBox(
              height: 24,
            ),
            Text("Email"),
            SizedBox(
              height: 12,
            ),
            Textfieldinpersonaldatailsscreen(
              label: 'Email',
              controller: emailController,
            ),
            SizedBox(
              height: 24,
            ),
            Text("Mobile"),
            SizedBox(
              height: 12,
            ),
            Textfieldinpersonaldatailsscreen(
              label: 'mobile',
              controller: phoneController,
            )
          ],
        ),
      ),
    );
  }
}
