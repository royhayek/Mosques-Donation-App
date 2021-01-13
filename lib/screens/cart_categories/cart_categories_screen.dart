import 'package:flutter/material.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/screens/cart_categories/widgets/cart_category_list_item.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:provider/provider.dart';

class CartCategoriesScreen extends StatefulWidget {
  static String routeName = "/cart_categories_screen";

  @override
  _CartCategoriesScreenState createState() => _CartCategoriesScreenState();
}

class _CartCategoriesScreenState extends State<CartCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'donation_cart')),
        centerTitle: true,
      ),
      body: _buildCartCategories(),
    );
  }

  _buildCartCategories() {
    return Consumer<AppProvider>(
      builder: (context, app, _) => ListView.builder(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
        shrinkWrap: true,
        itemCount: app.categories.length,
        itemBuilder: (context, index) => CartCategoryListItem(
          category: app.categories[index],
        ),
      ),
    );
  }
}
