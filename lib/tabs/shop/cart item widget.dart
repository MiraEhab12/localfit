// lib/widgets/cart_item_widget.dart
import 'package:flutter/material.dart';
import '../../clothesofwomen/productwithsize.dart';
import '../../cubit/cartcubit.dart';
class CartItemWidget extends StatelessWidget {
  final ProductWithSizeAndQuantity cartItem;
  final CartCubit cubit;

  const CartItemWidget({super.key, required this.cartItem, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          "https://localfit.runasp.net${cartItem.product.productIMGUrl ?? ''}",
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        ),
        title: Text(cartItem.product.producTNAME ?? 'No name'),
        subtitle: Text('Size: ${cartItem.selectedSize} | Qty: ${cartItem.quantity}'),
        trailing: Text('EGP ${((cartItem.product.price ?? 0.0) * cartItem.quantity).toStringAsFixed(2)}'),
      ),
    );
  }
}
