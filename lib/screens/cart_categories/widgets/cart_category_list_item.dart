import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/screens/cart/cart_screen.dart';

import '../../../size_config.dart';

class CartCategoryListItem extends StatelessWidget {
  final Cart cart;

  const CartCategoryListItem({Key key, this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => CartScreen(cart: cart)),
        ),
        leading: Stack(
          children: [
            Icon(FluentIcons.cart_24_regular, color: Colors.black),
            cart.count != 0
                ? Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 3.5,
                    ),
                    child: CircleAvatar(
                      maxRadius: 7,
                      child: Text(
                        '${cart.count}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 2.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        title: Text(
          cart.name,
          style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.5),
        ),
        trailing: Icon(FluentIcons.ios_chevron_right_20_regular),
      ),
      Divider(),
    ]);
  }
}
