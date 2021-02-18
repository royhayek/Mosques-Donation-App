import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/providers/cart_provider.dart';
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
  AuthProvider authProvider;
  CartProvider cartProvider;
  List<Cart> cart;
  bool _isRetrieving = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    getCart();
  }

  getCart() async {
    await cartProvider.getUserCart(authProvider.user.id).then((c) {
      setState(() {
        if (mounted) cart = c;
      });
    }).then((value) {
      setState(() {
        _isRetrieving = false;
      });
    }).whenComplete(() {
      setState(() {
        _isRetrieving = false;
      });
    });
  }

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
    return !_isRetrieving
        ? Consumer<CartProvider>(builder: (context, cart, _) {
            if (cart.cart.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                shrinkWrap: true,
                itemCount: cart.cart.length,
                itemBuilder: (context, index) => CartCategoryListItem(
                  cart: cart.cart[index],
                ),
              );
            } else {
              return Container(
                height: SizeConfig.blockSizeVertical * 85,
                child: Center(
                  child: Text(
                    trans(context, 'your_cart_is_empty'),
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                    ),
                  ),
                ),
              );
            }
          })
        : Center(child: CircularProgressIndicator());
  }
}
