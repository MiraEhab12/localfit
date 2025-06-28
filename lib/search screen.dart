import 'package:flutter/material.dart';
import 'package:localfit/api_manager/responses/productsofbrands.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/clothesofwomen/productdetails.dart'; // استدعاء شاشة تفاصيل المنتج

class SearchScreen extends StatefulWidget {
  static const String routename = 'search screen';
  final List<Responseproductsofbrands> allProducts;

  SearchScreen({required this.allProducts});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Responseproductsofbrands> searchResults = [];

  @override
  void initState() {
    super.initState();
    // عرض كل المنتجات في البداية
    searchResults = widget.allProducts;
  }

  void _search(String query) {
    print('Searching for: $query'); // تأكد من عمل البحث

    if (query.isEmpty) {
      setState(() {
        searchResults = widget.allProducts;
      });
      return;
    }

    final results = widget.allProducts.where((product) {
      final productName = product.producTNAME?.toLowerCase() ?? '';
      return productName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text('Search', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.mainlightcolor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: _search,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // عرض رسالة لا توجد نتائج أو قائمة النتائج
            if (searchResults.isEmpty)
              Expanded(
                child: Center(
                  child: Text('No products found matching your search.'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final product = searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Productdetails.routename,
                          arguments: product,
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.network(
                              "https://localfitt.runasp.net${product.productIMGUrl ?? ''}",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image_outlined, size: 50);
                              },
                            ),
                            title: Text(
                              product.producTNAME ?? 'No Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('EGP ${product.price ?? 'N/A'}'),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
