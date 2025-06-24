import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localfit/appcolor/appcolors.dart';
import 'package:localfit/appfonts/appfonts.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class AddTab extends StatefulWidget {
  static const String routename = '/add';  // تأكدي تستخدمينه في Navigator

  const AddTab({super.key});

  @override
  State<AddTab> createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      context.read<AddProductCubit>().updateImagePath(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => AddProductCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 70),
            child: BlocConsumer<AddProductCubit, AddProductState>(
              listener: (context, state) {
                if (state is AddProductSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تمت الإضافة بنجاح')),
                  );
                  Navigator.pop(context, true); // مهم جدًا هنا
                } else if (state is AddProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<AddProductCubit>();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(context),
                          child: Container(
                            height: height * 0.2,
                            width: width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _image != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_image!, fit: BoxFit.cover),
                            )
                                : Center(
                              child: Text(
                                "Upload Image",
                                style: Appfonts.interfont24weight400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                        Row(
                          children: [
                            Text(
                              "Item name",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 224,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                controller: nameController,
                                keyboardType: TextInputType.text,
                                onChanged: cubit.updateName,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Text(
                              "Item price",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 224,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                onChanged: cubit.updatePrice,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 224,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                controller: descriptionController,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                onChanged: cubit.updateDescription,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: 200,
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.maindarkcolor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                )),
                            onPressed: state is AddProductLoading
                                ? null
                                : () {
                              cubit.sendProduct();
                            },
                            child: state is AddProductLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              'Upload',
                              style: TextStyle(fontSize: 22),
                            ),
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
      ),
    );
  }
}
