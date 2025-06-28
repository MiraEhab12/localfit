import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/clothesofwomen/productdetails.dart';
import 'package:localfit/cubit/favcubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Listofclothes extends StatelessWidget {
  static const String routename = 'list_of_clothes';
  final Responseproductsofbrands infoproduct;
  const Listofclothes({Key? key, required this.infoproduct}) : super(key: key);

  Future<Map<String, String?>> _getBrandInfoFallback() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'brandName': prefs.getString('brandName'),
      'brandLogo': prefs.getString('brandLogo'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _getBrandInfoFallback(),
      builder: (context, snapshot) {
        final fallbackBrandName = snapshot.data?['brandName'];
        final fallbackBrandLogo = snapshot.data?['brandLogo'];

        final displayBrandName = infoproduct.brandName ?? fallbackBrandName ?? "No Brand";
        final displayBrandLogoUrl = infoproduct.brandLogoUrl ?? fallbackBrandLogo;

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Productdetails.routename,
              arguments: infoproduct,
            );
          },
          child: Container(
            width: 160,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.mainlightcolor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  color: Colors.black26,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<FavCubit, List<Responseproductsofbrands>>(
                    builder: (context, favoriteList) {
                      final isFavorite = favoriteList.any((p) => p.producTID == infoproduct.producTID);
                      return GestureDetector(
                        onTap: () {
                          context.read<FavCubit>().toggleFavorite(infoproduct);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(isFavorite ? 'Removed from favourite' : 'Added to favourite'),
                            duration: Duration(seconds: 2),
                          ));
                        },
                        child: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://localfitt.runasp.net${infoproduct.productIMGUrl ?? ""}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.broken_image_outlined, size: 50, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 19),
                  Text(
                    infoproduct.producTNAME ?? "",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "EGP ${infoproduct.price ?? ""}",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: displayBrandLogoUrl != null
                            ? NetworkImage("https://localfitt.runasp.net$displayBrandLogoUrl")
                            : null,
                        child: displayBrandLogoUrl == null ? Icon(Icons.store, size: 12) : null,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          displayBrandName,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],

              ),
            ),
          ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_onboarding_slider/background_image.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:localfit/api_manager/responses/productsofbrands.dart';
// import 'package:localfit/appassets/appassets.dart';
// import 'package:localfit/appcolor/appcolors.dart';
// import 'package:localfit/clothesofwomen/productdetails.dart';
// import 'package:localfit/cubit/favcubit.dart';
//
// class Listofclothes extends StatelessWidget {
//   static const String routename='list of clothes';
//   final Responseproductsofbrands infoproduct;
//   Listofclothes({required this.infoproduct});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//        Navigator.pushNamed(context, Productdetails.routename,arguments: infoproduct
//        );
//       },
//       child: Container(
//         width: 160,
//         decoration: BoxDecoration(
//           color: AppColors.mainlightcolor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 4,
//               offset: Offset(0, 4),
//               color: Colors.black26,
//             )
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               BlocBuilder<FavCubit, List<Responseproductsofbrands>>(
//                 builder: (context, favoriteList) {
//                   final isFavorite = favoriteList.any((p) => p.producTID == infoproduct.producTID);
//                   return GestureDetector(
//                     onTap: () {
//                       context.read<FavCubit>().toggleFavorite(infoproduct);
//     final snackBar = SnackBar(
//     content: Text(isFavorite
//     ? 'remove from favourite'
//         : 'add to favourite'),
//     duration: Duration(seconds: 2),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     },
//                     child: Icon(
//                       Icons.favorite,
//                       color: isFavorite ? Colors.red : Colors.grey,
//                       size: 30,
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 8),
//               Expanded(
//                 child: Image.network(
//                   "https://localfit.runasp.net${infoproduct.productIMGUrl ?? ""}",
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Icon(Icons.broken_image_outlined);
//                   },
//                 ),
//               ),
//               SizedBox(height: 19),
//               Text(
//                 infoproduct.producTNAME ?? "",
//                 style: GoogleFonts.inter(
//                   textStyle: TextStyle(
//                     fontWeight: FontWeight.w300,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 "EGP${infoproduct.price}",
//                 style: GoogleFonts.inter(
//                   textStyle: TextStyle(
//                     fontWeight: FontWeight.w300,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
