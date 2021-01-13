import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/screens/cart/cart_screen.dart';

import '../../../size_config.dart';

class CartCategoryListItem extends StatelessWidget {
  final Category category;

  const CartCategoryListItem({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => CartScreen(category: category)),
        ),
        leading: Icon(
          FluentIcons.cart_24_regular,
          color: Colors.black,
        ),
        title: Text(
          category.name,
          style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.5),
        ),
        trailing: Icon(
          FluentIcons.ios_chevron_right_20_regular,
        ),
      ),
      Divider(),
    ]);
  }
}
