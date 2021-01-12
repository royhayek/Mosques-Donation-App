import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/screens/cart/widgets/cart_list_item.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart_screen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Cart cart;
  bool isRetrieving = true;

  @override
  void initState() {
    super.initState();
    getUserCart();
  }

  getUserCart() async {
    await HttpService.getUserCart(_auth.currentUser.uid).then((c) {
      setState(() {
        cart = c;
      });
    });

    setState(() {
      isRetrieving = false;
    });
  }

  removeProduct(int cartId) async {
    await HttpService.deleteCartProduct(cartId);
    setState(() {
      cart.products.removeWhere((p) => p.cartId == cartId);
    });
    getUserCart();
  }

  updateProduct(int cartId, int quantity, num price) async {
    await HttpService.updateCartProduct(cartId, quantity, price)
        .then((value) => getUserCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'donation_cart')),
        centerTitle: true,
      ),
      body: !isRetrieving
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  cart.count == 1
                      ? '${cart.count} product'
                      : '${cart.count} products',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.products.length,
                  itemBuilder: (context, index) => CartListItem(
                    product: cart.products[index],
                    remove: removeProduct,
                    update: updateProduct,
                  ),
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
                            '${cart.total} ${trans(context, 'kd')}',
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
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
