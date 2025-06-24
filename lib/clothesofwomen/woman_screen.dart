import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/cubit/cubitListofproductsofbrands.dart';
import 'package:localfit/cubit/states.dart';
import 'package:localfit/listofclothes/listofclothes.dart';

class Woman_screen extends StatefulWidget {
  static const String routename = 'womanscreen';

  @override
  State<Woman_screen> createState() => _Woman_screenState();
}

class _Woman_screenState extends State<Woman_screen> {
  late CubitListOfProductOfBrand cubit;
  bool isSeller = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is bool) {
      isSeller = arg;
    }
  }
  @override
  void initState() {
    super.initState();
    cubit = CubitListOfProductOfBrand();
    cubit.getproductsofbrand();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
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
          actions: isSeller? [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final result =
                await Navigator.pushNamed(context, '/add'); // تأكدي من اسم الرُوت

                if (result == true) {
                  cubit.getproductsofbrand();
                }
              },
            )
          ] :null
        ),
        body: BlocBuilder<CubitListOfProductOfBrand, Homestate>(
          builder: (context, state) {
            if (state is GetPoductsLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetProductsErorrState) {
              return Center(
                  child: Text("حدث خطأ أثناء تحميل المنتجات، حاول مرة أخرى"));
            } else if (state is GetProductsSucessfulState) {
              if (cubit.listofproducts.isEmpty) {
                return Center(child: Text("لا توجد منتجات حالياً"));
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: cubit.listofproducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 300,
                    crossAxisSpacing: 23,
                    mainAxisSpacing: 11,
                  ),
                  itemBuilder: (context, index) {
                    return Listofclothes(
                      infoproduct: cubit.listofproducts[index],
                    );
                  },
                ),
              );
            } else {
              return Center(child: Text("حدث خطأ غير متوقع"));
            }
          },
        ),
      ),
    );
  }
}
