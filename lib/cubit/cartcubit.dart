import 'package:bloc/bloc.dart';
import 'package:localfit/cubit/states.dart';

import '../api_manager/responses/productsofbrands.dart';

class CartCubit extends Cubit<List<Responseproductsofbrands>>{
  CartCubit():super([]);
  void addToCart(Responseproductsofbrands product) {
    final updatedCart = List<Responseproductsofbrands>.from(state);
    updatedCart.add(product);
    emit(updatedCart);
  }void removeFromCartByIndex(int index) {
    final updatedCart = List<Responseproductsofbrands>.from(state);
    updatedCart.removeAt(index);
    emit(updatedCart);
  }

  void clearCart() {
    emit([]);
  }
}