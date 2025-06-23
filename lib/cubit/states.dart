abstract class Homestate{}
class GetProductsInitialState extends Homestate{}
class GetPoductsLoadingState extends Homestate{}
class GetProductsSucessfulState extends Homestate{}
class GetProductsErorrState extends Homestate{
  final String errorMessage;
  GetProductsErorrState(this.errorMessage);
}