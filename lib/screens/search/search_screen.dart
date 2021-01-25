import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/screens/checkout/widgets/custom_text_field.dart';
import 'package:mosques_donation_app/screens/subcategories/widgets/subcategory_list_item.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _searchedProducts = [];
  List<Product> _products = [];
  bool _searched = false;
  bool _isloading = false;

  _onChanged(String keyword) async {
    _searchedProducts.clear();
    if (keyword.isEmpty) {
      setState(() {});
      return;
    }

    _products.forEach((product) {
      if (product.name.toLowerCase().contains(keyword.toLowerCase()))
        setState(() {
          _searched = true;
          _searchedProducts.add(product);
        });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllProducts();
  }

  _getAllProducts() async {
    await HttpService.getAllProducts().then((products) {
      setState(() {
        _products = products;
        print(_products);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text(trans(context, 'search')), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                Text(
                  trans(context, 'search_here'),
                  style:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                CustomTextField(
                  maxLines: 1,
                  controller: _searchController,
                  onChanged: _onChanged,
                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 2),
          !_isloading
              ? _searched && _searchedProducts.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 50),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: _searchedProducts.length,
                        itemBuilder: (context, index) => SubCategoryListItem(
                          product: _searchedProducts[index],
                        ),
                      ),
                    )
                  : Container(
                      height: SizeConfig.blockSizeVertical * 50,
                      child: Center(
                        child: _searched
                            ? Text(trans(context, 'no_products_found'))
                            : Text(
                                trans(context, 'start_looking_for_products')),
                      ),
                    )
              : Container(
                  height: SizeConfig.blockSizeVertical * 50,
                  child: Center(child: CircularProgressIndicator()),
                )
        ],
      ),
    );
  }
}
