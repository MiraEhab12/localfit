import 'package:bloc/bloc.dart';
import 'package:localfit/sellerscreen/cubit/states.dart';
import 'package:http/http.dart' as http;


class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  String name = '';

  String price = '';
  String description = '';
  String? imagePath;

  void updateName(String value) => name = value;
  void updatePrice(String value) => price = value;
  void updateDescription(String value) => description = value;
  void updateImagePath(String path) => imagePath = path;

  Future<void> sendProduct() async {
    if (name.isEmpty || price.isEmpty || description.isEmpty || imagePath == null) {
      emit(AddProductError('complete all data'));
      return;
    }

    emit(AddProductLoading());
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://localfitt.runasp.net/api/product/createproduct'),
      );

      request.fields['PRODUCT_NAME'] = name;
      request.fields['PRICE'] = price;
      request.fields['DESCRIPTION'] = description;

      request.files.add(await http.MultipartFile.fromPath('IMAGE', imagePath!));

      var response = await request.send();

      if (response.statusCode == 200) {
        emit(AddProductSuccess());
      } else {
        emit(AddProductError('فشل في الإضافة: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AddProductError('حدث خطأ أثناء الإرسال: $e'));
    }
  }
}
