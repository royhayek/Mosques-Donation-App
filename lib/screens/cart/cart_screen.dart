import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/providers/cart_provider.dart';
import 'package:mosques_donation_app/screens/cart/widgets/cart_list_item.dart';
import 'package:mosques_donation_app/screens/checkout%202/checkout_2_screen.dart';
import 'package:mosques_donation_app/screens/checkout/checkout_screen.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart_screen";

  final Cart cart;

  const CartScreen({Key key, this.cart}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AppProvider appProvider;
  CartProvider cartProvider;
  Cart cart;
  bool _isRetrieving = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);

    getCartByCategory();
  }

  getCartByCategory() {
    setState(() {
      cart = cartProvider.getCartByCategory(widget.cart);
    });
  }

  removeProduct(int cartId) async {
    await HttpService.deleteCartProduct(cartId);
    setState(() {
      cart.products.removeWhere((p) => p.cartId == cartId);
    });
    await cartProvider.getUserCart(_auth.currentUser.uid);
    await cartProvider.getUserCartCount(_auth.currentUser.uid);
    getCartByCategory();
  }

  updateProduct(int cartId, int quantity, num price) async {
    setState(() {
      _isUpdating = true;
    });
    await HttpService.updateCartProduct(cartId, quantity, price)
        .then((value) async {
      await cartProvider.getUserCart(_auth.currentUser.uid);
      await cartProvider.getUserCartCount(_auth.currentUser.uid);
    });
    getCartByCategory();
    setState(() {
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cart.name), centerTitle: true),
      body: _buildCartList(),
    );
  }

  _buildCartList() {
    return !_isRetrieving
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  cart.count == 1
                      ? '${appProvider.getLanguage() == 'English' ? cart.count : ''} ${trans(context, 'product')}'
                      : '${cart.count} ${trans(context, 'products')}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1),
                cart.products.isNotEmpty
                    ? Container(
                        height: SizeConfig.blockSizeVertical * 65,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cart.products.length,
                          itemBuilder: (context, index) => CartListItem(
                            product: cart.products[index],
                            remove: removeProduct,
                            update: updateProduct,
                            isUpdating: _isUpdating,
                          ),
                        ),
                      )
                    : Container(
                        height: SizeConfig.blockSizeVertical * 65,
                        child: Center(
                          child: Text(
                            trans(context, 'your_cart_is_empty'),
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5,
                    vertical: SizeConfig.blockSizeVertical * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        press: () => cart.products.isNotEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => cart.templateId != 5 &&
                                          cart.templateId != 4 &&
                                          cart.templateId != 1
                                      ? CheckoutScreen(
                                          categoryId: widget.cart.id,
                                          cart: cart,
                                        )
                                      : Checkout2Screen(
                                          categoryId: widget
                                              .cart.products[0].categoryId,
                                          cart: cart,
                                        ),
                                ),
                              )
                            : null,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
