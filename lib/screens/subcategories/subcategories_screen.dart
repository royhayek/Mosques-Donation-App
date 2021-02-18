import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/screens/products_list/products_list_screen.dart';
import 'package:mosques_donation_app/screens/subcategories/widgets/subcategory_list_item.dart';

import '../../size_config.dart';

class SubCategoriesScreen extends StatelessWidget {
  static String routeName = "/subcategories_screen";

  final Category category;

  const SubCategoriesScreen({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: category.subcategories.isNotEmpty
          ? AppBar(title: Text(category.name), centerTitle: true)
          : PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(),
            ),
      body: category.subcategories.isNotEmpty
          ? _buildCategoryGridView()
          : ProductsListScreen(category: category),
    );
  }

  _buildCategoryGridView() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: category.subcategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
        mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical * 1,
        horizontal: SizeConfig.blockSizeHorizontal * 4,
      ),
      itemBuilder: (ctx, i) => SubcategoryListItem(
        subcategory: category.subcategories[i],
        categoryId: category.id,
      ),
    );
  }
}
