import 'dart:convert';
import 'dart:math';

import 'package:app_web_ecommerce/global_variable.dart';
import 'package:app_web_ecommerce/models/banner.dart';
import 'package:app_web_ecommerce/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BannerController {
  uploadBanner(
      {required dynamic pickedImage, required BuildContext context}) async {
    try {
      final cloudinary = CloudinaryPublic("doooplg4p", 'uoqwwgyk');
      CloudinaryResponse imageResponses = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'banners',
        ),
      );
      String image = imageResponses.secureUrl;
      BannerModel bannerModel = BannerModel(id: "", image: image);

      http.Response response = await http.post(
        Uri.parse("$uri/api/banner"),
        body: bannerModel.toJson(),
        headers: {
          "Content-Type": "application/json",
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Uploaded Banner Successfully');
          },
          onError: (error) {
            showSnackBar(context, error.toString());
          });
    } catch (e) {
      print(e);
    }
  }

  //fetchn banner
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response =
          await http.get(Uri.parse("$uri/api/banner"), headers: {
        "Content-Type": "application/json; charset=UTF-8",
      });
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      }else{
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      throw Exception('Error loading banners: $e');
    }
  }
}
