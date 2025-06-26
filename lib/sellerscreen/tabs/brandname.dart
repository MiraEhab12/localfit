import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localfit/sellerscreen/homeseller.dart';

class CreateBrandScreen extends StatefulWidget {
  static const String routename = 'create_brand';

  const CreateBrandScreen({Key? key}) : super(key: key);

  @override
  State<CreateBrandScreen> createState() => _CreateBrandScreenState();
}

class _CreateBrandScreenState extends State<CreateBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? _logoFile;
  bool _isLoading = false;

  // دالة لفك الدور من التوكن JWT
  String? getUserRoleFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      final payloadMap = json.decode(utf8.decode(base64Url.decode(normalized)));

      if (payloadMap is! Map<String, dynamic>) return null;

      if (payloadMap.containsKey('role')) {
        return payloadMap['role'];
      } else if (payloadMap.containsKey('http://schemas.microsoft.com/ws/2008/06/identity/claims/role')) {
        return payloadMap['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      }
      return null;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  Future<void> _pickLogo() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _createBrand() async {
    if (!_formKey.currentState!.validate()) return;

    if (_logoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a brand logo')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token'); // هنا المفتاح 'jwt_token'

      print('✅ التوكن المسترجع من SharedPreferences:');
      print(token);

      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }

      // فك الدور وطباعة الدور في الكونسول
      final role = getUserRoleFromToken(token);
      print('🛡️ دور المستخدم (Role) من التوكن: $role');

      var uri = Uri.parse('https://localfitt.runasp.net/api/Brands/createbrand');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['BrandName'] = nameController.text;
      request.fields['Description'] = descriptionController.text;
      request.fields['ContactInfo'] = contactInfoController.text;
      request.fields['Email'] = emailController.text;

      request.files.add(await http.MultipartFile.fromPath('logoFile', _logoFile!.path));

      print('📤 البيانات المُرسلة:');
      print('BrandName: ${request.fields['BrandName']}');
      print('Description: ${request.fields['Description']}');
      print('ContactInfo: ${request.fields['ContactInfo']}');
      print('Email: ${request.fields['Email']}');
      print('عدد الملفات المرفقة: ${request.files.length}');
      print('📤 الهيدر: ${request.headers}');

      var response = await request.send();

      print('🔄 حالة الاستجابة: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      print('📥 جسم الاستجابة (Response body):\n$responseBody');

      if (response.statusCode == 201) {
        final createdBrand = jsonDecode(responseBody);

        await prefs.setInt('brandId', createdBrand['brand_ID']);
        await prefs.setString('brandName', createdBrand['brand_Name']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Brand created successfully!')),
        );

        Navigator.pushReplacementNamed(context, Homeseller.routename, arguments: true);
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Access denied (403). You might not have permission.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create brand. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Your Brand')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text("Let's set up your brand", style: Theme.of(context).textTheme.headlineSmall),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickLogo,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _logoFile != null ? FileImage(_logoFile!) : null,
                  child: _logoFile == null ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey[600]) : null,
                ),
              ),
              Center(child: Text('Tap to add logo')),
              SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Brand Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a brand name' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: contactInfoController,
                decoration: InputDecoration(labelText: 'Contact Info', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter contact info' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter an email';
                  if (!value.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _createBrand,
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15)),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Create Brand', style: TextStyle(fontSize: 18)),
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
