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

  Map<String, dynamic> toJson() {
    final originalJson = product.toJson();
    return {
      ...originalJson,
      "selectedSize": selectedSize,
      "quantity": quantity,
    };
  }
}
