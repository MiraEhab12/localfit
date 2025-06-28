// lib/screens/order_confirmation/order_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:localfit/tabs/shop/my%20order.dart';

import '../../homescreen.dart'; // سننشئ هذه الشاشة لاحقاً

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmed'),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
              SizedBox(height: 24),
              Text(
                'Thank You!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Your order has been placed successfully.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigation to My Orders screen
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyOrdersScreen()));
                },
                child: Text('View My Orders'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                        (route) => false,
                  );
                },
                child: Text('Continue Shopping'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black, side: BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}