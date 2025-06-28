// lib/screens/my_orders/my_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/myordercubit.dart';



class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyOrdersCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          backgroundColor: Colors.black,
        ),
        body: BlocBuilder<MyOrdersCubit, MyOrdersState>(
          builder: (context, state) {
            if (state is MyOrdersLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is MyOrdersError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
            }
            if (state is MyOrdersSuccess) {
              if (state.orders.isEmpty) {
                return Center(child: Text('You have no orders yet.'));
              }
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text('Order #${order.orderId}'),
                      subtitle: Text(DateFormat.yMMMd().format(order.orderDate)),
                      trailing: Text(
                        'EGP ${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: order.orderItems.map((item) => ListTile(
                        title: Text(item.productName),
                        subtitle: Text('Quantity: ${item.quantity}'),
                        trailing: Text('EGP ${item.price.toStringAsFixed(2)}'),
                      )).toList(),
                    ),
                  );
                },
              );
            }
            return Center(child: Text('Welcome to your orders!'));
          },
        ),
      ),
    );
  }
}