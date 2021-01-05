import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/cart/widgets/cart_list_item.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'donation_cart')),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              CartListItem(),
              CartListItem(),
              CartListItem(),
              CartListItem(),
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5,
              vertical: SizeConfig.blockSizeVertical * 5,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      trans(context, 'total_price'),
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '12 ${trans(context, 'kd')}',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                DefaultButton(
                  text: trans(context, 'checkout'),
                  press: () => null,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
