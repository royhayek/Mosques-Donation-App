import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/widgets/product_list_item.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class TopTenProductsListScreen extends StatefulWidget {
  static const routeName = 'top_ten_products_list_screen';
  @override
  _TopTenProductsListScreenState createState() =>
      _TopTenProductsListScreenState();
}

class _TopTenProductsListScreenState extends State<TopTenProductsListScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  _getProducts() async {
    await HttpService.getTopTenProducts().then((p) {
      setState(() {
        _products = p;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'top_ten_products')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: !_isLoading
            ? _products.isNotEmpty
                ? GridView.builder(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return ProductListItem(product: _products[index]);
                    },
                  )
                : Center(
                    child: Text(
                      trans(context, 'no_products_yet'),
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                      ),
                    ),
                  )
            : Container(
                height: SizeConfig.blockSizeVertical * 70,
                child: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
