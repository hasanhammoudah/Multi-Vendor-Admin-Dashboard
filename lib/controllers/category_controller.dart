import 'dart:convert';

import 'package:app_web_ecommerce/global_variable.dart';
import 'package:app_web_ecommerce/models/category.dart';
import 'package:app_web_ecommerce/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategory(
      {required dynamic pickedImage,
      required dynamic pickedBanner,
      required String name,
      required BuildContext context}) async {
    try {
      if (pickedImage == null || pickedBanner == null) {
        throw Exception("Image or Banner cannot be null");
      }

      final cloudinary = CloudinaryPublic("doooplg4p", 'uoqwwgyk');
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'categoryImages',
        ),
      );
      String image = imageResponse.secureUrl;

      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: 'pickedBanner',
          folder: 'categoryBanners',
        ),
      );
      String banner = bannerResponse.secureUrl;
      Category category = Category(
        id: "",
        name: name,
        image: image,
        banner: banner,
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/category"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: category.toJson(),
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Uploaded Category Successfully');
          },
          onError: (error) {
            showSnackBar(context, error.toString());
          });
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
    }
  }

  // load the uploaded category
  Future<List<Category>> loadCategory() async {
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/api/category"), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }
}
