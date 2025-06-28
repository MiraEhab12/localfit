// الحالات العامة للـ Home أو للمنتجات
import 'package:equatable/equatable.dart';

import '../clothesofwomen/productwithsize.dart';

abstract class Homestate {}

class GetProductsInitialState extends Homestate {}

class GetProductsLoadingState extends Homestate {}

class GetProductsSuccessfulState extends Homestate {

}

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
// lib/cubit/order_state.dart

// <-- هذا السطر مهم جداً لربط الملفين


abstract class OrderState {}

// الحالة الأولية عند بدء تشغيل الـ Cubit
class OrderInitial extends OrderState {}

// حالة جاري تحميل الطلب (عندما يضغط المستخدم على زر Place Order)
class OrderLoading extends OrderState {}

// حالة نجاح إنشاء الطلب
class OrderSuccess extends OrderState {}

// حالة حدوث خطأ أثناء إنشاء الطلب
class OrderError extends OrderState {
  final String message;

  OrderError(this.message);

  // يمكنك إضافة `props` إذا كنت تستخدم مكتبة equatable للمقارنة بين الحالات
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderError &&
        other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
// lib/cubit/cart_state.dart


abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}
class CartSuccess extends CartState {
  final List<ProductWithSizeAndQuantity> cartItems;

  const CartSuccess({required this.cartItems});

  // حساب السعر الكلي أوتوماتيكياً من قائمة المنتجات
  double get totalPrice => cartItems.fold(
    0.0,
        (sum, item) => sum + ((item.product.price ?? 0.0) * item.quantity),
  );

  @override
  List<Object?> get props => [cartItems];
}


class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

