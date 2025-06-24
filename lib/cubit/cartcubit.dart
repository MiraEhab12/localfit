import 'package:flutter_bloc/flutter_bloc.dart';
import '../clothesofwomen/productwithsize.dart';

class CartCubit extends Cubit<List<ProductWithSizeAndQuantity>> {
  CartCubit() : super([]);

  void addToCart(ProductWithSizeAndQuantity item) {
    final updatedCart = List<ProductWithSizeAndQuantity>.from(state);
    final existingIndex = updatedCart.indexWhere((e) =>
    e.product.producTID == item.product.producTID &&
        e.selectedSize == item.selectedSize);

    if (existingIndex != -1) {
      updatedCart[existingIndex].quantity += item.quantity;
    } else {
      updatedCart.add(item);
    }

    emit(updatedCart);
  }

  void removeFromCartByIndex(int index) {
    final updated = List<ProductWithSizeAndQuantity>.from(state);
    updated.removeAt(index);
    emit(updated);
  }

  void updateQuantity(int index, int newQuantity) {
    final updated = List<ProductWithSizeAndQuantity>.from(state);
    updated[index].quantity = newQuantity;
    emit(updated);
  }

  void updateSize(int index, String newSize) {
    final updated = List<ProductWithSizeAndQuantity>.from(state);
    updated[index].selectedSize = newSize;
    emit(updated);
  }

  void replaceCartItems(List<ProductWithSizeAndQuantity> items) {
    emit(List<ProductWithSizeAndQuantity>.from(items));
  }

  void clearCart() {
    emit([]);
  }
}
