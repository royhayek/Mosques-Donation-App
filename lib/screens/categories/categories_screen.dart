import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/cart/cart_screen.dart';
import 'package:mosques_donation_app/screens/categories/widgets/category_list_item.dart';
import 'package:mosques_donation_app/size_config.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeName = "/categories_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FluentIcons.cart_24_regular, size: 30),
          onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
        ),
        actions: [
          IconButton(
            icon: Icon(FluentIcons.search_24_regular, size: 30),
            onPressed: () => null,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 1,
        ),
        children: [
          CategoryListItem(),
          CategoryListItem(),
          CategoryListItem(),
          CategoryListItem(),
          CategoryListItem(),
          CategoryListItem(),
          CategoryListItem(),
          CategoryListItem(),
        ],
      ),
    );
  }
}
