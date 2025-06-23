import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/cubit/cubitListofproductsofbrands.dart';
import 'package:localfit/cubit/states.dart';
import 'package:localfit/listofclothes/listofclothes.dart';

class Woman_screen extends StatelessWidget {
  static const String routename = 'womanscreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitListOfProductOfBrand()..getproductsofbrand(),
      child: Scaffold(
        backgroundColor: AppColors.mainlightcolor,
        appBar: AppBar(
          title: Text(
            "Women",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: AppColors.mainlightcolor,
        ),
        body: BlocBuilder<CubitListOfProductOfBrand, Homestate>(
          builder: (context, state) {
            if (state is GetPoductsLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetProductsErorrState) {
              return Center(
                  child: Text("Something went wrong, try again later"));
            } else if (state is GetProductsSucessfulState) {
              var bloc = BlocProvider.of<CubitListOfProductOfBrand>(context);
              if (bloc.listofproducts.isEmpty) {
                return Center(child: Text("No products available"));
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: bloc.listofproducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 300,
                    crossAxisSpacing: 23,
                    mainAxisSpacing: 11,
                  ),
                  itemBuilder: (context, index) {
                    return Listofclothes(
                        infoproduct: bloc.listofproducts[index]);
                  },
                ),
              );
            } else {
              return Center(child: Text("Unexpected error"));
            }
          },
        ),
      ),
    );
  }
}
