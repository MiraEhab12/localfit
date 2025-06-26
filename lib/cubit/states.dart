// الحالات العامة للـ Home أو للمنتجات
import 'package:equatable/equatable.dart';

abstract class Homestate {}

class GetProductsInitialState extends Homestate {}

class GetProductsLoadingState extends Homestate {}

class GetProductsSuccessfulState extends Homestate {}

class GetProductsErrorState extends Homestate {
  final String errorMessage;

  GetProductsErrorState(this.errorMessage);
}


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

