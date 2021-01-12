import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/models/product_attributes.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class SubCategoryListItem extends StatefulWidget {
  final Product product;

  const SubCategoryListItem({Key key, this.product}) : super(key: key);

  @override
  _SubCategoryListItemState createState() => _SubCategoryListItemState();
}

class _SubCategoryListItemState extends State<SubCategoryListItem> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<ProductAttributes> attributes;
  Map<int, dynamic> tmpAttributeObj = {};
  bool isRetrieving = true;

  @override
  void initState() {
    super.initState();
    getProductVariables();
  }

  getProductVariables() async {
    if (widget.product.productType == 'variable')
      await HttpService.getProductAttributes(widget.product.id).then((a) {
        setState(() {
          attributes = a;
        });
      });

    setState(() {
      isRetrieving = false;
    });
  }

  addProductToCart(
      int productId, int attributeId, int quantity, num price) async {
    await HttpService.addToCart(
        _auth.currentUser.uid, productId, attributeId, quantity, price);
  }

  ProductAttributes findProductVariation() {
    ProductAttributes tmpProductVariation;

    Map<String, dynamic> tmpSelectedObj = {};
    (tmpAttributeObj.values).forEach((attributeObj) {
      tmpSelectedObj[attributeObj["name"]] = attributeObj["value"];
    });

    attributes.forEach((productVariation) {
      Map<String, dynamic> tmpVariations = {};

      tmpVariations[productVariation.name] = productVariation.price;

      if (tmpVariations.toString() == tmpSelectedObj.toString()) {
        tmpProductVariation = productVariation;
      }
    });

    return tmpProductVariation;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              '${HttpService.PRODUCT_IMAGES_PATH}${widget.product.image}',
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 16,
              fit: BoxFit.fill,
            ),
            Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            Row(
              children: [
                !isRetrieving
                    ? Text(
                        widget.product.productType == 'simple'
                            ? '${widget.product.price} ${trans(context, 'kd')}'
                            : '${attributes[0].price} ${trans(context, 'kd')}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                        ),
                      )
                    : SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () async {
                      if (widget.product.productType == 'simple')
                        addProductToCart(
                          widget.product.id,
                          0,
                          1,
                          widget.product.price,
                        );
                      else
                        modalBottomSheetAttributes(
                          context,
                          product: widget.product,
                          findProductVariation: findProductVariation,
                          tmpAttributeObj: tmpAttributeObj,
                          productAttributes: attributes,
                          addProductToCart: addProductToCart,
                        );
                    },
                    radius: 100,
                    borderRadius: BorderRadius.circular(15),
                    child: Icon(Icons.add_shopping_cart, size: 23),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
