// lib/cubit/my_orders_cubit.dart

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../tabs/shop/order model.dart';

// States
abstract class MyOrdersState {}
class MyOrdersInitial extends MyOrdersState {}
class MyOrdersLoading extends MyOrdersState {}
class MyOrdersSuccess extends MyOrdersState {
  final List<OrderModel> orders;
  MyOrdersSuccess(this.orders);
}
class MyOrdersError extends MyOrdersState {
  final String message;
  MyOrdersError(this.message);
}

// Cubit
class MyOrdersCubit extends Cubit<MyOrdersState> {
  MyOrdersCubit() : super(MyOrdersInitial()) {
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    emit(MyOrdersLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        emit(MyOrdersError("Please log in to see your orders."));
        return;
      }

      final url = Uri.parse('https://localfitt.runasp.net/api/Orders/user-orders');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<OrderModel> orders = data.map((json) => OrderModel.fromJson(json)).toList();
        emit(MyOrdersSuccess(orders));
      } else {
        emit(MyOrdersError("Failed to load orders: ${response.statusCode}"));
      }
    } catch (e) {
      emit(MyOrdersError("An error occurred: $e"));
    }
  }
}