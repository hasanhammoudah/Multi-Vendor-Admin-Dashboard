import 'dart:io';

import 'package:app_web_ecommerce/controllers/category_controller.dart';
import 'package:app_web_ecommerce/controllers/subcategory_controller.dart';
import 'package:app_web_ecommerce/models/category.dart';
import 'package:app_web_ecommerce/views/side_bar_screens/widgets/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});
  static const String id = '\subCategoryScreen';

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late Future<List<Category>> futureSubCategories;
  Category? selectedCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  late String name;
  dynamic _image;
  final SubcategoryController _subcategoryController = SubcategoryController();

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      if (result.files.first.bytes != null) {
        // الصورة موجودة كـ Bytes
        setState(() {
          _image = result.files.first.bytes;
        });
      } else if (result.files.first.path != null) {
        // الصورة موجودة كملف
        final file = File(result.files.first.path!);
        final imageBytes = await file.readAsBytes(); // تحويل إلى Uint8List
        setState(() {
          _image = imageBytes;
        });
      } else {
        print("No valid image selected.");
      }
    } else {
      print("No image selected.");
    }
  }

  @override
  void initState() {
    super.initState();
    futureSubCategories = CategoryController().loadCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Subcategories',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            FutureBuilder(
                future: futureSubCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No Subcategories Found"),
                    );
                  } else {
                    return DropdownButton<Category>(
                        value: selectedCategory,
                        hint: Text('Select Category'),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        });
                  }
                }),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: _image != null
                        ? Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : Text('Subcategory Image'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter subCategory name';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter SubCategory Name',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _subcategoryController.uploadSubCategory(
                        categoryId: selectedCategory!.id,
                        categoryName: selectedCategory!.name,
                        subCategoryName: name,
                        pickedImage: _image,
                        context: context,
                      );
                      setState(() {
                        _formKey.currentState!.reset();
                        _image = null;
                      });
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text(
                  'Pick image',
                ),
              ),
            ),
              Divider(
                color: Colors.grey,
              ),
            SubCategoryWidget(),
          ],
        ),
      ),
    );
  }
}
