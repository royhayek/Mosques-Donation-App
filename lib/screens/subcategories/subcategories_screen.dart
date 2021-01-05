import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/screens/categories/widgets/category_list_item.dart';

import '../../size_config.dart';

class SubCategoriesScreen extends StatelessWidget {
  static String routeName = "/subcategories_screen";

  final Category category;

  const SubCategoriesScreen({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
      ),
      body: _buildCategoryGridView(),
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
      itemBuilder: (ctx, i) => CategoryListItem(
        subcategory: category.subcategories[i],
      ),
    );
  }
}
