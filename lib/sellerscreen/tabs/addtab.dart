// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../cubit/addtabcubit.dart'; // عدل المسار حسب مكان الكيوبت
//
// class AddTab extends StatelessWidget {
//   static const String routename = 'add_tab';
//
//   final _formKey = GlobalKey<FormState>();
//
//   AddTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => AddProductCubit(),
//       child: Scaffold(
//         appBar: AppBar(title: Text("Add Product")),
//         body: BlocConsumer<AddProductCubit, AddProductState>(
//           listener: (context, state) {
//             if (state is AddProductSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Product added successfully!")),
//               );
//               _formKey.currentState?.reset();
//               context.read<AddProductCubit>().reset();
//             } else if (state is AddProductError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//           },
//           builder: (context, state) {
//             final cubit = context.read<AddProductCubit>();
//
//             return SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: InputDecoration(labelText: "Product Name"),
//                       onChanged: cubit.updateName,
//                       validator: (val) =>
//                       val == null || val.isEmpty ? "Please enter product name" : null,
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       decoration: InputDecoration(labelText: "Price"),
//                       keyboardType: TextInputType.number,
//                       onChanged: cubit.updatePrice,
//                       validator: (val) =>
//                       val == null || val.isEmpty ? "Please enter price" : null,
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       decoration: InputDecoration(labelText: "Description"),
//                       maxLines: 3,
//                       onChanged: cubit.updateDescription,
//                       validator: (val) =>
//                       val == null || val.isEmpty ? "Please enter description" : null,
//                     ),
//                     SizedBox(height: 20),
//
//                     GestureDetector(
//                       onTap: () async {
//                         final picker = ImagePicker();
//                         final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                         if (pickedFile != null) {
//                           cubit.updateImagePath(pickedFile.path);
//                         }
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: cubit.imagePath == null
//                             ? Center(child: Text("Tap to select product image"))
//                             : Image.file(File(cubit.imagePath!), fit: BoxFit.cover),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//
//                     state is AddProductLoading
//                         ? CircularProgressIndicator()
//                         : ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           cubit.sendProduct();
//                         }
//                       },
//                       child: Text("Add Product"),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/addtabcubit.dart'; // استورد Cubit

class AddTab extends StatefulWidget {
  static const String routename = '/add';
  const AddTab({Key? key}) : super(key: key);

  @override
  State<AddTab> createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

  String productName = '';
  String description = '';
  double price = 0;

  // قيم ثابتة مؤقتة للـ brandId, catId, stockLevel
  int brandId = 1;
  int catId = 1;
  int stockLevel = 10;

  String? brandName;
  String? brandLogo;

  @override
  void initState() {
    super.initState();
    _loadBrandInfo();
  }

  Future<void> _loadBrandInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      brandName = prefs.getString('brandName');
      brandLogo = prefs.getString('brandLogo');
    });
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _removeImage() {
    setState(() => _image = null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddProductCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Product"),
          backgroundColor: AppColors.maindarkcolor,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<AddProductCubit, AddProductState>(
            listener: (context, state) {
              if (state is AddProductSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Product added!"), backgroundColor: Colors.green),
                );
                _formKey.currentState?.reset();
                _removeImage();
              } else if (state is AddProductError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<AddProductCubit>();

              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Product Image", style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      _image == null
                          ? GestureDetector(
                        onTap: () => _pickImage(context),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
                                Text("Tap to select image", style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                          ),
                        ),
                      )
                          : Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _removeImage,
                            icon: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (v) => productName = v,
                        validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (v) => price = double.tryParse(v) ?? 0,
                        validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
                        decoration: InputDecoration(
                          labelText: 'Price (EGP)',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (v) => description = v,
                        maxLines: 3,
                        validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (brandName != null)
                        Column(
                          children: [
                            Text("Brand: $brandName"),
                            const SizedBox(height: 10),
                            if (brandLogo != null)
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage("https://localfitt.runasp.net$brandLogo"),
                              )
                          ],
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is AddProductLoading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              if (_image == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Select image"), backgroundColor: Colors.orange),
                                );
                              } else {
                                cubit.sendProduct(
                                  productName: productName,
                                  description: description,
                                  price: price,
                                  brandId: brandId,
                                  catId: catId,
                                  stockLevel: stockLevel,
                                  imageFile: _image!,
                                  brandName: brandName ?? '',
                                  brandLogo: brandLogo ?? '',
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.maindarkcolor,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: state is AddProductLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Upload", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}












//شغال
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:localfit/appcolor/appcolors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../cubit/addtabcubit.dart'; // استورد Cubit
//
// class AddTab extends StatefulWidget {
//   static const String routename = '/add';
//   const AddTab({Key? key}) : super(key: key);
//
//   @override
//   State<AddTab> createState() => _AddTabState();
// }
//
// class _AddTabState extends State<AddTab> {
//   final _formKey = GlobalKey<FormState>();
//   File? _image;
//
//   String productName = '';
//   String description = '';
//   double price = 0;
//
//   // قيم ثابتة مؤقتة للـ brandId, catId, stockLevel
//   int brandId = 1;
//   int catId = 1;
//   int stockLevel = 10;
//
//   String? brandName;
//   String? brandLogo;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBrandInfo();
//   }
//
//   Future<void> _loadBrandInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       brandName = prefs.getString('brandName');
//       brandLogo = prefs.getString('brandLogo');
//     });
//   }
//
//   Future<void> _pickImage(BuildContext context) async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _image = File(pickedFile.path));
//     }
//   }
//
//   void _removeImage() {
//     setState(() => _image = null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => AddProductCubit(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Add Product"),
//           backgroundColor: AppColors.maindarkcolor,
//           foregroundColor: Colors.white,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: BlocConsumer<AddProductCubit, AddProductState>(
//             listener: (context, state) {
//               if (state is AddProductSuccess) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Product added!"), backgroundColor: Colors.green),
//                 );
//                 _formKey.currentState?.reset();
//                 _removeImage();
//               } else if (state is AddProductError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//                 );
//               }
//             },
//             builder: (context, state) {
//               final cubit = context.read<AddProductCubit>();
//
//               return SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Text("Product Image", style: TextStyle(fontSize: 18)),
//                       const SizedBox(height: 8),
//                       _image == null
//                           ? GestureDetector(
//                         onTap: () => _pickImage(context),
//                         child: Container(
//                           height: 150,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey),
//                           ),
//                           child: Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
//                                 Text("Tap to select image", style: TextStyle(color: Colors.grey[700])),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                           : Stack(
//                         alignment: Alignment.topRight,
//                         children: [
//                           Container(
//                             height: 200,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_image!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: _removeImage,
//                             icon: CircleAvatar(
//                               backgroundColor: Colors.black54,
//                               child: Icon(Icons.close, color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         onChanged: (v) => productName = v,
//                         validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
//                         decoration: InputDecoration(
//                           labelText: 'Product Name',
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         keyboardType: TextInputType.number,
//                         onChanged: (v) => price = double.tryParse(v) ?? 0,
//                         validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
//                         decoration: InputDecoration(
//                           labelText: 'Price (EGP)',
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         onChanged: (v) => description = v,
//                         maxLines: 3,
//                         validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
//                         decoration: InputDecoration(
//                           labelText: 'Description',
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       if (brandName != null)
//                         Column(
//                           children: [
//                             Text("Brand: $brandName"),
//                             const SizedBox(height: 10),
//                             if (brandLogo != null)
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundImage: NetworkImage("https://localfitt.runasp.net$brandLogo"),
//                               )
//                           ],
//                         ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: state is AddProductLoading
//                               ? null
//                               : () {
//                             if (_formKey.currentState!.validate()) {
//                               if (_image == null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text("Select image"), backgroundColor: Colors.orange),
//                                 );
//                               } else {
//                                 cubit.sendProduct(
//                                   productName: productName,
//                                   description: description,
//                                   price: price,
//                                   brandId: brandId,
//                                   catId: catId,
//                                   stockLevel: stockLevel,
//                                   imageFile: _image!,
//                                 );
//                               }
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.maindarkcolor,
//                             padding: EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child: state is AddProductLoading
//                               ? CircularProgressIndicator(color: Colors.white)
//                               : Text("Upload", style: TextStyle(fontSize: 18)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }






