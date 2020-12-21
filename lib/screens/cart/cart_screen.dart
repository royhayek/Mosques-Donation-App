import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/cart/widgets/cart_list_item.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Cart'),
        centerTitle: true,
      ),
      body: Column(
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
        ],
      ),
    );
  }
}
