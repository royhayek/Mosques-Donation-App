import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/models/subcategory.dart';
import 'package:mosques_donation_app/screens/checkout/checkout_screen.dart';
import 'package:mosques_donation_app/screens/products_list/products_list_screen.dart';
import 'package:mosques_donation_app/screens/subcategories/subcategories_screen.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final Subcategory subcategory;
  final int categoryId;

  const CategoryListItem(
      {Key key, this.category, this.subcategory, this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => category != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubCategoriesScreen(category: category),
              ),
            )
          : subcategory.showProductsList == 1
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsListScreen(
                      subcategory: subcategory,
                      category: category,
                      categoryId: category != null ? category.id : categoryId,
                    ),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      subcategory: subcategory,
                      // category: category,
                      categoryId: categoryId,
                    ),
                  ),
                ),
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                category != null
                    ? '${HttpService.CATEGORY_IMAGES_PATH}${category.image}'
                    : '${HttpService.SUBCATEGORY_IMAGES_PATH}${subcategory.image}',
                fit: BoxFit.fill,
                width: double.infinity,
                height: SizeConfig.blockSizeHorizontal * 32,
              ),
            ),
            Text(
              category != null ? category.name : subcategory.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
