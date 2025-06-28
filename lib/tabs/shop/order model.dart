class OrderItem {
  final int productId;
  final int quantity;
  final double price;
  final String productName;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? '',
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0),
    );
  }
}

class OrderModel {
  final int orderId;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final List<OrderItem> orderItems;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['orderDate'] ?? '');
    } catch (_) {
      parsedDate = DateTime.now();
    }

    double totalAmt = 0.0;
    if (json['totalAmount'] != null) {
      if (json['totalAmount'] is int) {
        totalAmt = (json['totalAmount'] as int).toDouble();
      } else if (json['totalAmount'] is double) {
        totalAmt = json['totalAmount'];
      } else if (json['totalAmount'] is String) {
        totalAmt = double.tryParse(json['totalAmount']) ?? 0.0;
      }
    }

    var itemsJson = json['orderItems'] as List<dynamic>? ?? [];
    List<OrderItem> items = itemsJson.map((e) => OrderItem.fromJson(e)).toList();

    return OrderModel(
      orderId: json['orderId'] ?? 0,
      orderDate: parsedDate,
      totalAmount: totalAmt,
      status: json['status'] ?? '',
      orderItems: items,
    );
  }
}
