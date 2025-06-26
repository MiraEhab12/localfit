import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
// === States ===
abstract class AddProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductError extends AddProductState {
  final String message;
  AddProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddProductImageUpdated extends AddProductState {
  final String imagePath;
  AddProductImageUpdated(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

// === Cubit ===
class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  String name = '';
  String price = '';
  String description = '';
  String? imagePath;

  void updateName(String val) => name = val.trim();

  void updatePrice(String val) => price = val.trim();

  void updateDescription(String val) => description = val.trim();

  void updateImagePath(String path) {
    imagePath = path;
    emit(AddProductImageUpdated(path)); // تحديث الحالة عند تغيير الصورة
  }

  void reset() {
    name = '';
    price = '';
    description = '';
    imagePath = null;
    emit(AddProductInitial());
  }

  Future<void> sendProduct() async {
    if (name.isEmpty || price.isEmpty || description.isEmpty || imagePath == null) {
      emit(AddProductError('Please fill all fields and select an image.'));
      return;
    }

    emit(AddProductLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final brandId = prefs.getInt('brandId');

      if (token == null) {
        throw Exception('Authentication error. Please log in again.');
      }

      if (brandId == null) {
        throw Exception('Brand not found. Please create your brand profile first before adding products.');
      }

      var uri = Uri.parse('https://localfitt.runasp.net/api/Products/createproduct');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['ProductName'] = name
        ..fields['Price'] = price
        ..fields['Description'] = description
        ..fields['BrandId'] = brandId.toString()
        ..files.add(await http.MultipartFile.fromPath('ProductImageFile', imagePath!));

      var response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        emit(AddProductSuccess());
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception('Failed to add product. Status: ${response.statusCode}. Details: $errorBody');
      }
    } catch (e) {
      emit(AddProductError(e.toString().replaceFirst("Exception: ", "")));
    }
  }
}
