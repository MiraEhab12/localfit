import 'package:bloc/bloc.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';

class FavCubit extends Cubit<List<Responseproductsofbrands>>{
  FavCubit():super([]);
 void addtofav(Responseproductsofbrands product){
    final updatedFavorites = List<Responseproductsofbrands>.from(state);
    if (!updatedFavorites.any((item) => item.producTID == product.producTID)) {
      updatedFavorites.add(product);
      emit(updatedFavorites);
    }
  }

  void removeFromFavorite(Responseproductsofbrands product) {
    final updatedFavorites = List<Responseproductsofbrands>.from(state);
    updatedFavorites.removeWhere((item) => item.producTID == product.producTID);
    emit(updatedFavorites);
  }
  void toggleFavorite(Responseproductsofbrands product) {
    final updatedFavorites = List<Responseproductsofbrands>.from(state);
    final exists = updatedFavorites.any((item) => item.producTID == product.producTID);

    if (exists) {
      updatedFavorites.removeWhere((item) => item.producTID == product.producTID);
    } else {
      updatedFavorites.add(product);
    }
    emit(updatedFavorites);
  }
  void clearFavorites() {
    emit([]);
  }
}