import 'dart:io';

import 'package:app_web_ecommerce/controllers/category_controller.dart';
import 'package:app_web_ecommerce/views/side_bar_screens/widgets/category_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  static const String id = '\category-screen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  late String name;
  dynamic _image;
  dynamic _bannerImage;

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

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      if (result.files.first.bytes != null) {
        // الصورة موجودة كـ Bytes
        setState(() {
          _bannerImage = result.files.first.bytes;
        });
      } else if (result.files.first.path != null) {
        // الصورة موجودة كملف
        final file = File(result.files.first.path!);
        final imageBytes = await file.readAsBytes(); // تحويل إلى Uint8List
        setState(() {
          _bannerImage = imageBytes;
        });
      } else {
        print("No valid image selected.");
      }
    } else {
      print("No image selected.");
    }
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
                  'Category Screen',
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
                        : Text('Category Image'),
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
                          return 'Please enter category name';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Category Name',
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_image == null || _bannerImage == null) {
                        print("Please select both images before saving.");
                        return;
                      }
                      _categoryController.uploadCategory(
                          pickedImage: _image,
                          pickedBanner: _bannerImage,
                          name: name,
                          context: context);
                    } else {
                      print("Form is not valid.");
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
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: _bannerImage != null
                    ? Image.memory(_bannerImage)
                    : Text(
                        'Category Banner',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    pickBannerImage();
                  },
                  child: Text('Pick Image')),
            ),
            Divider(
              color: Colors.grey,
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
