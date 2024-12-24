import 'dart:convert';

import 'package:app_web_ecommerce/global_variable.dart';
import 'package:app_web_ecommerce/models/subcategory.dart';
import 'package:app_web_ecommerce/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  uploadSubCategory(
      {required String categoryId,
      required String categoryName,
      required String subCategoryName,
      required dynamic pickedImage,
      required context}) async {
    try {
      if (pickedImage == null) {
        throw Exception("Image cannot be null");
      }

      final cloudinary = CloudinaryPublic("doooplg4p", 'uoqwwgyk');
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'subCategoryImages',
        ),
      );
      String image = imageResponse.secureUrl;

      Subcategory subCategory = Subcategory(
        id: "",
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subCategoryName,
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/sub_category"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: subCategory.toJson(),
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Uploaded SubCategory Successfully');
          },
          onError: (error) {
            showSnackBar(context, error.toString());
          });
    } catch (e) {
      print("$e");
    }
  }

// load the uploaded subCategory
  Future<List<Subcategory>> loadSubcategory() async {
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/api/sub_category"), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Subcategory> subcategories =
            data.map((subcategory) => Subcategory.fromJson(subcategory)).toList();
        return subcategories;
      } else {
        throw Exception('Failed to load subCategories');
      }
    } catch (e) {
      throw Exception('Error loading subCategories: $e');
    }
  }
}
