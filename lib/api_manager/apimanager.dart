import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localfit/api_manager/responses/productsofbrands.dart';

class ApiManager {
  // ✅ تسجيل الدخول باستخدام userName فقط
  Future<Map<String, dynamic>> loginWithUsernameAndPassword(String username,
      String password) async {
    final response = await http.post(
      Uri.parse('https://localfitt.runasp.net/api/User/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'token': jsonDecode(response.body)['token']};
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Login failed'
      };
    }
  }

  // ✅ تسجيل مستخدم جديد
  Future<Map<String, dynamic>> sendregister(String userName, String email,
      String password, String role) async {
    Uri url = Uri.parse("https://localfit.runasp.net/api/user/register");
    try {
      final body = jsonEncode({
        "userName": userName,
        "email": email,
        "password": password,
        "role": role,
      });

      http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return {
          "success": true,
          "message": "Registered successfully",
          "token": json['token'],
        };
      } else {
        return {
          "success": false,
          "message": "Register failed: ${response.statusCode}",
          "error": response.body,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong",
        "error": e.toString(),
      };
    }
  }

  Future<
      List<Responseproductsofbrands>> getListOfClothesProductsOfBrands() async {
    Uri url = Uri.parse('https://localfitt.runasp.net/api/product/getproducts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((jsonItem) {
        return Responseproductsofbrands.fromJson(jsonItem);
      }).toList();
    } else {
      throw Exception(
          'Failed to load products. Status code: ${response.statusCode}');
    }
  }
}
