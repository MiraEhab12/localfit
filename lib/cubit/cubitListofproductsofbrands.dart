import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:localfit/cubit/states.dart';

import '../api_manager/responses/productsofbrands.dart';

class CubitListOfProductOfBrand extends Cubit<Homestate>{
  List<Responseproductsofbrands> listofproducts=[];
  Responseproductsofbrands? responseproductsofbrands;
  CubitListOfProductOfBrand():super(GetProductsLoadingState());

 void getproductsofbrand() async{
   try{
     emit(GetProductsLoadingState());

     Uri url= Uri.https('localfitt.runasp.net','api/product/getproducts');
     http.Response response=await http.get(url,headers: {
       'Content-Type': 'application/json',
       'Accept': 'application/json',
     },

     ).timeout(Duration(seconds: 30));;
     print("RESPONSE STATUS: ${response.statusCode}");
     print("RESPONSE BODY: ${response.body}");
     if(response.statusCode==200){
       var json=jsonDecode(response.body) as List;
     listofproducts=json.map((item)=> Responseproductsofbrands.fromJson(item)).toList();
       emit(GetProductsSuccessfulState());

     }else{
       emit(GetProductsErrorState(
           'Error: Status code is ${response.statusCode}'
       ));
     }
   }
   catch(e){
     print("ERROR IN API: $e");
   emit(GetProductsErrorState('Exception: $e'));
   }

  }
}