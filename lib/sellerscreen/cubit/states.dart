import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:localfit/appfonts/appfonts.dart';

abstract class AddProductState {}
class AddProductInitial extends AddProductState {}
class AddProductLoading extends AddProductState {}
class AddProductSuccess extends AddProductState {}
class AddProductError extends AddProductState {
  final String message;
  AddProductError(this.message);
}