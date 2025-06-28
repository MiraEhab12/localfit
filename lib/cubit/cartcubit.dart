// cart_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localfit/cubit/states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../clothesofwomen/productwithsize.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  // مفاتيح التخزين
  static const String _cartIdKey = 'cartId';
  static const String _custIdKey = 'custid';

  List<ProductWithSizeAndQuantity> _cartItems = [];

  // حفظ واسترجاع IDs
  Future<void> saveCartAndCustomerIds(int cartId, int custId) async {
    if (cartId == 0 || custId == 0) return;
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

  // تحميل المنتجات
  void loadCart(List<ProductWithSizeAndQuantity> items) {
    _cartItems = items;
    _emitSuccess();
  }

  void addToCart(ProductWithSizeAndQuantity item) {
    final index = _cartItems.indexWhere((e) =>
    e.product.producTID == item.product.producTID &&
        e.selectedSize == item.selectedSize
    );

    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    _emitSuccess();
  }

  void removeFromCartByIndex(int index) {
    _cartItems.removeAt(index);
    _emitSuccess();
  }

  void updateQuantity(int index, int newQuantity) {
    _cartItems[index].quantity = newQuantity;
    _emitSuccess();
  }

  void updateSize(int index, String newSize) {
    _cartItems[index].selectedSize = newSize;
    _emitSuccess();
  }

  void replaceCartItems(List<ProductWithSizeAndQuantity> items) {
    _cartItems = List<ProductWithSizeAndQuantity>.from(items);
    _emitSuccess();
  }

  void clearCart() {
    _cartItems.clear();
    _emitSuccess();
  }

  void _emitSuccess() {
    emit(CartSuccess(cartItems: List.from(_cartItems)));
  }

  // احصل على السعر الكلي (يمكن استدعاؤها من خارج الكيوبت)
  double get totalPrice => _cartItems.fold(
    0.0,
        (sum, item) => sum + ((item.product.price ?? 0.0) * item.quantity),
  );
}
