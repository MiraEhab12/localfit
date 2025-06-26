// 📦 Order Details Page
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailsScreen({required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Map<String, dynamic>? orderData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) return;

      final response = await http.get(
        Uri.parse('https://localfitt.runasp.net/api/Order/${widget.orderId}'),
        headers: {
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          orderData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch order.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order #${widget.orderId}")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orderData == null
          ? Center(child: Text('Failed to load order'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${orderData!['status'] ?? 'Unknown'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Address: ${orderData!['address'] ?? '-'}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("City: ${orderData!['country'] ?? '-'}",
                style: TextStyle(fontSize: 16)),
            Divider(height: 30),
            Text("Products:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: orderData!['items'].length,
                itemBuilder: (context, index) {
                  final item = orderData!['items'][index];
                  return ListTile(
                    title: Text(item['productName'] ?? 'Product'),
                    subtitle: Text("Qty: ${item['quantity']}"),
                    trailing: Text("${item['price']} EGP"),
                  );
                },
              ),
            ),
            Divider(),
            Text("Total: ${orderData!['totalAmount']} EGP",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
