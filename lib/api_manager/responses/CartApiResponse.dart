// lib/models/api_response_models.dart

class CartApiResponse {
  final int cartId;
  final int custId;
  final List<CartItemDto> cartItems;
  final double totalPrice;

  CartApiResponse({
    required this.cartId,
    required this.custId,
    required this.cartItems,
    required this.totalPrice,
  });

  factory CartApiResponse.fromJson(Map<String, dynamic> json) {
    // التعامل مع احتمالية أن تكون قائمة المنتجات null
    var itemsList = json['cartItems'] as List? ?? [];
    List<CartItemDto> cartItems =
    itemsList.map((i) => CartItemDto.fromJson(i)).toList();

    return CartApiResponse(
      // *** تعديل هام: إذا كان cartId هو null، استخدم 0 كقيمة افتراضية ***
      cartId: json['cartId'] ?? 0,
      custId: json['custId'] ?? 0,
      cartItems: cartItems,
      totalPrice: (json['totalPrice'] as num? ?? 0).toDouble(),
    );
  }
}

class CartItemDto {
  final int cartItemId;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final String size;
  final String? productIMGUrl;

  CartItemDto({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.size,
    this.productIMGUrl,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) {
    return CartItemDto(
      // توفير قيم افتراضية آمنة لكل الحقول
      cartItemId: json['cartItemId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? 'No Name',
      price: (json['price'] as num? ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      size: json['size'] ?? 'N/A',
      productIMGUrl: json['productIMGUrl'],
    );
  }
}