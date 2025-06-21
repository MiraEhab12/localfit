
import 'dart:convert';

import 'package:http/http.dart' as http;
class ApiManager{
   Future <Map <String,dynamic>>getemailandpassword(String email, String password) async{
    Uri url=Uri.parse("https://localfit.runasp.net/api/user/login");
    try {
      http.Response response = await http.post(
        url, headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );


    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json;
    } else {

      return {
        "success": false,
        "message": "Login failed: ${response.statusCode}",
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
   Future<Map<String, dynamic>> sendregister(String userName, String email, String password, String role) async {
     Uri url = Uri.parse("https://localfit.runasp.net/api/user/register");
     try {
       final body = jsonEncode({
         "userName": userName,
         "email": email,
         "password": password,
         "role": role,
       });

       print('Request body: $body');

       http.Response response = await http.post(
         url,
         headers: {"Content-Type": "application/json"},
         body: body,
       );

       print('Response status: ${response.statusCode}');
       print('Response body: ${response.body}');

       if (response.statusCode == 200) {
         var json = jsonDecode(response.body);
         return json;
       } else {
         return {
           "success": false,
           "message": "register failed: ${response.statusCode}",
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

}