import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:localfit/sellerscreen/homeseller.dart'; // تأكد من استيراد صفحة الهوم
import 'package:shared_preferences/shared_preferences.dart';

// BrandResult class is not used in this file but good to have
class BrandResult {
  final String name;
  final String logoUrl;
  BrandResult({required this.name, required this.logoUrl});
}

class CreateBrandScreen extends StatefulWidget {
  @override
  _CreateBrandScreenState createState() => _CreateBrandScreenState();
}

class _CreateBrandScreenState extends State<CreateBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? _logoFile;
  bool _isLoading = false;

  Future<void> _pickLogo() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _createBrand() async {
    if (!_formKey.currentState!.validate() || _logoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a logo')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('User is not logged in.');
      }

      var uri = Uri.parse('https://localfitt.runasp.net/api/Brands/createbrand');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['Brand_Name'] = nameController.text.trim();
      request.fields['Description'] = descriptionController.text.trim();
      request.fields['Contact_info'] = contactInfoController.text.trim();
      request.fields['EMAIL'] = emailController.text.trim();

      request.files.add(await http.MultipartFile.fromPath('logoFile', _logoFile!.path));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final decoded = jsonDecode(responseBody);

        // --- التعديل الرئيسي هنا ---
        // استخراج البيانات من الـ response
        final brandId = decoded['brandId'];
        final brandName = decoded['brandName'] ?? nameController.text.trim();
        final logoUrl = decoded['logoUrl'];

        // التأكد من أن البيانات ليست null قبل الحفظ
        if (brandId != null) {
          await prefs.setInt('brandId', brandId); // حفظ الـ ID
        }
        await prefs.setString('brandName', brandName);
        if (logoUrl != null) {
          await prefs.setString('brandLogo', logoUrl);
        }
        // --- نهاية التعديل ---

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Brand created successfully!')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homeseller()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create brand: $responseBody')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Your Brand')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: _logoFile == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600]),
                      SizedBox(height: 4),
                      Text('Add Logo', style: TextStyle(color: Colors.grey[600])),
                    ],
                  )
                      : ClipOval(
                    child: Image.file(
                      _logoFile!,
                      fit: BoxFit.contain,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Brand Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter brand name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: contactInfoController,
                decoration: InputDecoration(labelText: 'Contact Info (Phone/Website)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter contact info' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Public Email', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter email';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading ? null : _createBrand,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Create Brand'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:localfit/sellerscreen/homeseller.dart';
//
// class BrandNameScreen extends StatefulWidget {
//   static const String routename = 'brandname';
//
//   const BrandNameScreen({Key? key}) : super(key: key);
//
//   @override
//   State<BrandNameScreen> createState() => _BrandNameScreenState();
// }
//
// class _BrandNameScreenState extends State<BrandNameScreen> {
//   final TextEditingController brandNameController = TextEditingController();
//
//   void onCreatePressed() async {
//     final brandName = brandNameController.text.trim();
//
//     if (brandName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a brand name')),
//       );
//       return;
//     }
//
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('brandName', brandName); // حفظ اسم البراند
//
//     // بعد الحفظ ننتقل لصفحة البائع مع passing arguments true
//     Navigator.pushReplacementNamed(context, Homeseller.routename,
//         arguments: true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter Brand Name'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Text("Let us know your brand name"),
//             Text("we will use this name to identify\n your account and it will be visible to customer on \napplication"),
//             TextField(
//               controller: brandNameController,
//               decoration: InputDecoration(
//                 labelText: 'Brand Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: onCreatePressed,
//               child: Text('Create'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
