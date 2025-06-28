// lib/cubit/order_cubit.dart

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/cubit/states.dart'; // تأكد من أن هذا المسار صحيح
import 'package:shared_preferences/shared_preferences.dart';

import '../clothesofwomen/productwithsize.dart'; // استخدم موديل المنتج اللي عندك

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  Future<void> createOrder({
    required List<ProductWithSizeAndQuantity> cartItems,
    required String address,
    required String city,
    required String postalCode,
  }) async {
    if (address.isEmpty || city.isEmpty || postalCode.isEmpty) {
      emit(OrderError("Please fill in all address fields."));
      return;
    }

    emit(OrderLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        emit(OrderError('User is not logged in. Please log in again.'));
        return;
      }

      final url = Uri.parse('https://localfitt.runasp.net/api/Order/createorder');

      final totalPrice = cartItems.fold(
        0.0,
            (sum, item) => sum + ((item.product.price ?? 0.0) * item.quantity),
      );

      final orderItemsJson = cartItems.map((item) => {
        // تأكد من أن اسم الحقل في الموديل هو producTID وليس productID
        'productId': item.product.producTID,
        'quantity': item.quantity,
        'price': item.product.price ?? 0.0,
      }).toList();

      final body = jsonEncode({
        'totalPrice': totalPrice,
        'address': address,
        'city': city,
        'postalCode': postalCode,
        'orderItems': orderItemsJson,
      });

      print("Sending Order Request Body: $body"); // للتحقق من البيانات المرسلة

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print("Received Response Status: ${response.statusCode}");
      print("Received Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // أي رد ناجح (200, 201, 204) يعتبر نجاحاً
        emit(OrderSuccess());
      } else {
        String errorMessage = 'Failed to place order (Code: ${response.statusCode})';

        if (response.body.isNotEmpty) {
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] ?? errorData['title'] ?? response.body;
          } catch (e) {
            errorMessage = response.body;
          }
        }

        emit(OrderError(errorMessage));
      }
    } catch (e) {
      print("Order Exception: $e");
      if (e is FormatException) {
        emit(OrderError('Received an invalid or empty response from the server.'));
      } else {
        emit(OrderError('An unexpected error occurred: ${e.toString()}'));
      }
    }
  }
}
