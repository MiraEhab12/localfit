// // ✅ هذا هو ملف ProductWithSizeAndQuantity بعد التعديل
// // ✅ يحتوي على toJson و fromJson كاملة للتعامل مع API والعرض
//
// import 'package:localfit/api_manager/responses/productsofbrands.dart';
//
// class ProductWithSizeAndQuantity {
//   final Responseproductsofbrands product;
//   String selectedSize;
//   int quantity;
//
//   ProductWithSizeAndQuantity({
//     required this.product,
//     required this.selectedSize,
//     this.quantity = 1,
//   });
//
//   Map<String, dynamic> toJson() {
//     final originalJson = product.toJson();
//     return {
//       ...originalJson,
//       "selectedSize": selectedSize,
//       "quantity": quantity,
//     };
//   }
//
//   factory ProductWithSizeAndQuantity.fromJson(Map<String, dynamic> json) {
//     return ProductWithSizeAndQuantity(
//       product: Responseproductsofbrands.fromJson(json),
//       selectedSize: json["selectedSize"] ?? "S",
//       quantity: json["quantity"] ?? 1,
//     );
//   }
// }
///////////////////////////////////
// lib/clothesofwomen/productwithsize.dart

import '../api_manager/responses/productsofbrands.dart';

class ProductWithSizeAndQuantity {
  final Responseproductsofbrands product;
  String selectedSize;
  int quantity;

  ProductWithSizeAndQuantity({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  // *** تعديل هام: إضافة fromJson factory ***
  // هذا سيقوم بتحليل الـ JSON القادم من الـ API
  factory ProductWithSizeAndQuantity.fromJson(Map<String, dynamic> json) {
    return ProductWithSizeAndQuantity(
      // نفترض أن الـ JSON يحتوي على كل بيانات المنتج مباشرة
      product: Responseproductsofbrands.fromJson(json),
      selectedSize: json['size'] ?? 'M', // قيمة افتراضية في حالة عدم وجود المقاس
      quantity: json['quantity'] ?? 1, // قيمة افتراضية في حالة عدم وجود الكمية
    );
  }

  // هذه الدالة مفيدة لإرسال البيانات للسيرفر
  Map<String, dynamic> toJson() {
    return {
      // نفترض أن API الإضافة يحتاج فقط لهذه البيانات
      "productId": product.producTID,
      "quantity": quantity,
      "size": selectedSize,
    };
  }
}
