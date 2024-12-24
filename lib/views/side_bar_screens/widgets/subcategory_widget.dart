import 'package:app_web_ecommerce/controllers/subcategory_controller.dart';
import 'package:app_web_ecommerce/models/subcategory.dart';
import 'package:flutter/material.dart';

class SubCategoryWidget extends StatefulWidget {
  const SubCategoryWidget({super.key});

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  // A future that will hold the list of categories from the API call
  late Future<List<Subcategory>> futureSubCategories;
  @override
  void initState() {
    super.initState();
    futureSubCategories = SubcategoryController().loadSubcategory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            child: Text("No SubCategories Found"),
          );
        } else {
          final subCategories = snapshot.data as List<Subcategory>;
          return GridView.builder(
            shrinkWrap: true,
            itemCount: subCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.network(
                    subCategories[index].image,
                    height: 100,
                    width: 100,
                  ),
                  Text(subCategories[index].subCategoryName),
                ],
              );
            },
          );
        }
      },
    );
  }
}
