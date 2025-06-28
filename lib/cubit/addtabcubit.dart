import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductError extends AddProductState {
  final String message;
  AddProductError(this.message);
}

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  Future<void> sendProduct({
    required String productName,
    required String description,
    required double price,
    required int brandId,
    required int catId,
    required int stockLevel,
    required File imageFile,
    required String brandName,
    required String brandLogo,
  }) async {
    emit(AddProductLoading());
    try {
      // هنا تستخرج التوكن من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var uri = Uri.parse('https://localfitt.runasp.net/api/Product/createproduct');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['PRODUCT_NAME'] = productName;
      request.fields['DESCRIPTION'] = description;
      request.fields['PRICE'] = price.toString();
      request.fields['Brand_ID'] = brandId.toString();
      request.fields['CAT_ID'] = catId.toString();
      request.fields['StockLevel'] = stockLevel.toString();

      // إرسال اسم البراند واللوجو مع المنتج
      request.fields['Brand_Name'] = brandName;
      request.fields['Brand_Logo'] = brandLogo;

      request.files.add(await http.MultipartFile.fromPath('imageFile', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 201) {
        emit(AddProductSuccess());
      } else {
        final resStr = await response.stream.bytesToString();
        emit(AddProductError('Failed to add product: $resStr'));
      }
    } catch (e) {
      emit(AddProductError('Error: $e'));
    }
  }
}
