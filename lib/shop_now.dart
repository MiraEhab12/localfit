import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <<<--- إضافة مهمة
import 'package:google_fonts/google_fonts.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart'; // <<<--- إضافة مهمة
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/cubit/cubitListofproductsofbrands.dart'; // <<<--- إضافة مهمة
import 'package:localfit/cubit/states.dart'; // <<<--- إضافة مهمة
import 'package:localfit/search%20screen.dart';
import 'package:localfit/tabs/fav/fav_tab.dart';
import 'package:localfit/tabs/prof/prof_tab.dart';
import 'package:localfit/tabs/shop/shop_tab.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:localfit/clothesofwomen/woman_screen.dart';

class ShopNow extends StatefulWidget {
  static const String routename = 'shop now';

  // --- تم حذف هذا الجزء، لأن الشاشة ستحضر بياناتها بنفسها ---
  // final List<Responseproductsofbrands> allProducts;
  // ShopNow({required this.allProducts});

  @override
  State<ShopNow> createState() => _ShopNowState();
}

class _ShopNowState extends State<ShopNow> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int selectedindex = 0;

  // =================== بداية الإضافات الجديدة ===================
  // الخطوة 1: إضافة Cubit لجلب البيانات
  late CubitListOfProductOfBrand allProductsCubit;

  List<Widget> tabs = [
    FavTab(),
    CartScreen(),
    ProfTab(),
  ];

  @override
  void initState() {
    super.initState();
    // الخطوة 2: تهيئة الـ Cubit وبدء تحميل كل المنتجات
    allProductsCubit = CubitListOfProductOfBrand();
    allProductsCubit.getproductsofbrand();
  }
  // =================== نهاية الإضافات الجديدة ===================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainlightcolor,
      body: selectedindex == 0
      // الخطوة 3: استخدام BlocBuilder للتحكم في الواجهة بناءً على حالة التحميل
          ? BlocBuilder<CubitListOfProductOfBrand, Homestate>(
        bloc: allProductsCubit,
        builder: (context, state) {
          if (state is GetProductsLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetProductsSuccessfulState) {
            // عند النجاح، نبني الواجهة ونمرر لها قائمة المنتجات
            return buildShopNowContent(context, allProductsCubit.listofproducts);
          }
          if (state is GetProductsErrorState) {
            return Center(child: Text("Failed to load products."));
          }
          // حالة افتراضية أثناء الانتظار
          return Center(child: CircularProgressIndicator());
        },
      )
          : tabs[selectedindex - 1],
      bottomNavigationBar: buildCurvedNavigationBar(),
    );
  }

  // هذه الدالة تحتوي على تصميم شاشتك الأصلي بدون أي تغيير في الشكل
  Widget buildShopNowContent(BuildContext context, List<Responseproductsofbrands> allProducts) {
    return Padding(
      padding: const EdgeInsets.only(top: 52),
      child: Column(
        children: [
          Text(
            "Your Style, Locally Crafted",
            style: GoogleFonts.italiana(
              textStyle: const TextStyle(
                fontSize: 20,
                color: AppColors.blackcolor,
              ),
            ),
          ),
          const SizedBox(height: 19),
          Container(
            padding: const EdgeInsets.only(top: 50),
            width: double.infinity,
            height: 157,
            color: AppColors.maindarkcolor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // زر البحث الآن سيأخذ قائمة المنتجات من هذه الدالة
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(
                          allProducts: allProducts, // <<<--- الآن يعمل بشكل صحيح
                        ),
                      ),
                    );
                  },
                  padding: const EdgeInsets.only(bottom: 63, left: 32),
                  icon: const Icon(Icons.search),
                  color: AppColors.whitecolor,
                ),
                const Expanded(
                  child: Text(
                    "LocalFit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.whitecolor,
                      fontSize: 36,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 28),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.63),
            child: Text(
              "shop by category",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            "woman",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Woman_screen.routename);
            },
            child: Image.asset(
              "assets/images/womanbutton.png",
              width: MediaQuery.of(context).size.width * 0.44,
              height: MediaQuery.of(context).size.height * 0.30,
            ),
          )
        ],
      ),
    );
  }

  // لم أغير أي شيء في شريط التنقل السفلي
  CurvedNavigationBar buildCurvedNavigationBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      items: <Widget>[
        Icon(Icons.home_filled, size: 30, color: selectedindex == 0 ? Colors.black : Colors.white),
        Icon(Icons.favorite_border, size: 30, color: selectedindex == 1 ? Colors.black : Colors.white),
        Icon(Icons.shopping_bag_outlined, size: 30, color: selectedindex == 2 ? Colors.black : Colors.white),
        Icon(Icons.person_pin, size: 30, color: selectedindex == 3 ? Colors.black : Colors.white),
      ],
      color: AppColors.maindarkcolor,
      buttonBackgroundColor: AppColors.mainlightcolor,
      backgroundColor: AppColors.mainlightcolor,
      letIndexChange: (index) => true,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          selectedindex = index;
        });
      },
    );
  }
}