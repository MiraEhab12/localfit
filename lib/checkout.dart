import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/appfonts/appfonts.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routename='check out';
  final double totalAmount;

  CheckoutScreen({required this.totalAmount});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPaymentMethod; // "visa" or "cash"

  Future<void> createPaymentIntent() async {
    final url = Uri.parse('https://localfit.runasp.net/api/payment/create-payment-intent');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "amount": widget.totalAmount,
          "currency": "egp",
          "payment_method": selectedPaymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        print("Payment Intent Created: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment successful ✅'),
        ));
      } else {
        print("Failed: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment failed ❌'),
        ));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong ❌'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            border:Border(
              top: BorderSide(width: 1),
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Text("Payment method",style:TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),),

              SizedBox(height: 30),


              RadioListTile<String>(
                title:Row(
                  children: [
                    Text("Cash On Delivery"),
                    SizedBox(width: 100,),
                    Container(
                      width: 52,
                      height: 26,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1),
                          bottom: BorderSide(width: 1),
                          left: BorderSide(width: 1),
                          right: BorderSide(width: 1),
                        )
                      ),
                      child:Icon(Icons.delivery_dining),
                    ),
                  ],
                ),
                value: "Cash On Delivery",
                groupValue: selectedPaymentMethod,

                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                title:Row(
                  children: [
                    Text("Credit/Debit Card"),
                    SizedBox(width: 99,),
                    Container(
                      width: 52,
                      height: 26,
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                            left: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                          )
                      ),
                      child:Icon(Icons.credit_card),
                    ),
                  ],
                ),
                value: "Credit/Debit Card",
                groupValue: selectedPaymentMethod,

                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                title:Row(
                  children: [
                    Text("Apple Pay"),
                    SizedBox(width: 155,),
                    Container(
                      width: 52,
                      height: 26,
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                            left: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                          )
                      ),
                      child:Icon(Icons.apple),
                    ),
                  ],
                ),
                value: "Apple Pay",
                groupValue: selectedPaymentMethod,

                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
              Spacer(),
              Text("Total Amount: ${widget.totalAmount.toStringAsFixed(2)} EGP",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 38,),

              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: ElevatedButton(
                  onPressed: selectedPaymentMethod == null
                      ? null
                      : () {
                    if (selectedPaymentMethod == "Credit/Debit Card") {
                      createPaymentIntent();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Cash order confirmed ✅"),
                        ),
                      );
                    }
                  },
                  child: Text("Confirm Payment"),
                  style: ElevatedButton.styleFrom(

                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                      side: BorderSide(color: Color(0xffE0E0E0), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
