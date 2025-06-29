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























// lib/cubit/cart_cubit.dart
// lib/cubit/cart_cubit.dart

// import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:localfit/cubit/states.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../api_manager/responses/CartApiResponse.dart';
// import '../clothesofwomen/productwithsize.dart';
// import '../api_manager/responses/productsofbrands.dart';
//
//
// class CartCubit extends Cubit<CartState> {
//   CartCubit() : super(CartInitial());
//
//   static const String _cartIdKey = 'cartId';
//   final String _apiBaseUrl = 'https://localfitt.runasp.net/api';
//
//   // دالة لجلب بيانات المستخدم (أهم جزء)
//   Future<Map<String, dynamic>?> _getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final custId = prefs.getInt('custId');
//
//     if (token == null || custId == null) {
//       emit(CartError("User not logged in. Please sign in to view your cart."));
//       return null;
//     }
//     return {'token': token, 'custId': custId};
//   }
//
//   // جلب العربة الخاصة بالمستخدم المحدد
//   Future<void> loadCartFromServer() async {
//     emit(CartLoading());
//     final userData = await _getUserData();
//     if (userData == null) return;
//
//     final int custId = userData['custId'];
//     final String token = userData['token'];
//
//     try {
//       final response = await http.get(
//         Uri.parse('$_apiBaseUrl/Cart/$custId'),
//         // إرسال التوكن لإثبات هوية المستخدم
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final cart = CartApiResponse.fromJson(data);
//
//         if (cart.cartId != 0) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setInt(_cartIdKey, cart.cartId);
//         }
//
//         final localCartItems = cart.cartItems.map((item) {
//           final productModel = Responseproductsofbrands(
//             producTID: item.productId,
//             producTNAME: item.productName,
//             price: item.price,
//             productIMGUrl: item.productIMGUrl,
//           );
//           return ProductWithSizeAndQuantity(
//             product: productModel,
//             quantity: item.quantity,
//             selectedSize: item.size,
//           );
//         }).toList();
//
//         emit(CartSuccess(cartItems: localCartItems));
//       } else if (response.statusCode == 404) {
//         emit(CartSuccess(cartItems: []));
//       } else {
//         emit(CartError('Failed to load cart. Status: ${response.statusCode}'));
//       }
//     } catch (e) {
//       emit(CartError('An error occurred: $e'));
//     }
//   }
//
//   // إضافة منتج لعربة المستخدم المحدد
//   Future<void> addToCart(ProductWithSizeAndQuantity item) async {
//     final userData = await _getUserData();
//     if (userData == null) return;
//
//     final body = jsonEncode({
//       "productId": item.product.producTID,
//       "quantity": item.quantity,
//       "size": item.selectedSize,
//       "custId": userData['custId'],
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse('$_apiBaseUrl/Cart/add-to-cart'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${userData['token']}', // إرسال التوكن
//         },
//         body: body,
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // بعد الإضافة الناجحة، أعد تحميل العربة من السيرفر
//         await loadCartFromServer();
//       } else {
//         emit(CartError('Failed to add item. Status: ${response.statusCode}'));
//       }
//     } catch (e) {
//       emit(CartError('An error occurred while adding to cart: $e'));
//     }
//   }
//
//   // حذف منتج من عربة المستخدم المحدد
//   Future<void> removeFromCart(int productId) async {
//     emit(CartLoading());
//     final userData = await _getUserData();
//     if (userData == null) return;
//
//     final prefs = await SharedPreferences.getInstance();
//     final cartId = prefs.getInt(_cartIdKey);
//
//     if (cartId == null) {
//       emit(CartError('Cannot remove item, cart ID is missing.'));
//       // بعد الخطأ، حاول تحميل العربة مجددًا لإصلاح الحالة
//       await loadCartFromServer();
//       return;
//     }
//
//     try {
//       final response = await http.delete(
//         Uri.parse('$_apiBaseUrl/Cart/remove-from-cart?cartId=$cartId&productId=$productId'),
//         headers: {'Authorization': 'Bearer ${userData['token']}'}, // إرسال التوكن
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         await loadCartFromServer();
//       } else {
//         emit(CartError("Failed to remove item. Server responded with ${response.statusCode}"));
//       }
//     } catch (e) {
//       emit(CartError("An error occurred: ${e.toString()}"));
//     }
//   }
// }
////////////empty///////////