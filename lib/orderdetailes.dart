import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final dynamic orderId;
  final String username;
  final String shippingAddress;
  final double totalAmount;

  const OrderDetailsScreen({
    Key? key,
    required this.orderId,
    required this.username,
    required this.shippingAddress,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: $orderId', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Customer: $username', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Shipping Address: $shippingAddress', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Total Amount: EGP ${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
