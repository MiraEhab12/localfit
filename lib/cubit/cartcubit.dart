import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../clothesofwomen/productwithsize.dart'; // تأكد من صحة المسار

class CartCubit extends Cubit<List<ProductWithSizeAndQuantity>> {
  CartCubit() : super([]);

  // مفاتيح التخزين للـ SharedPreferences
  static const String _cartIdKey = 'cartId';
  static const String _custIdKey = 'custid';

  // ======== دوال لحفظ واسترجاع cartId و custid =========

  Future<void> saveCartAndCustomerIds(int cartId, int custId) async {
    if (cartId == 0 || custId == 0) return; // لا تحفظ أصفار فارغة
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cartIdKey, cartId);
    await prefs.setInt(_custIdKey, custId);
    print("✅ IDs Saved: CartID=$cartId, CustID=$custId");
  }

  Future<int> getCartId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cartIdKey) ?? 0;
  }

  Future<int> getCustId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_custIdKey) ?? 0;
  }

  // =======================================================

  // إضافة منتج للسلة مع تعديل الكمية إذا المنتج موجود بالفعل بنفس المقاس
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

  // إزالة منتج بواسطة الفهرس
  void removeFromCartByIndex(int index) {
    final updated = List<ProductWithSizeAndQuantity>.from(state);
    updated.removeAt(index);
    emit(updated);
  }

  // تعديل الكمية
  void updateQuantity(int index, int newQuantity) {
    final updated = List<ProductWithSizeAndQuantity>.from(state);
    updated[index].quantity = newQuantity;
    emit(updated);
  }

  // تعديل المقاس
  void updateSize(int index, String newSize) {
    final updated = List<ProductWithSizeAndQuantity>.from(state);
    updated[index].selectedSize = newSize;
    emit(updated);
  }

  // استبدال كل عناصر السلة بقائمة جديدة
  void replaceCartItems(List<ProductWithSizeAndQuantity> items) {
    emit(List<ProductWithSizeAndQuantity>.from(items));
  }

  // تفريغ السلة
  void clearCart() {
    emit([]);
  }
}
