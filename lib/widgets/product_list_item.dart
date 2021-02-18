import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/models/product_attributes.dart';
import 'package:mosques_donation_app/models/subcategory.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/providers/cart_provider.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

class ProductListItem extends StatefulWidget {
  final BuildContext context;
  final Product product;
  final int categoryId;
  final Subcategory subcategory;

  const ProductListItem(
      {Key key, this.context, this.product, this.categoryId, this.subcategory})
      : super(key: key);

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  AuthProvider authProvider;
  List<ProductAttributes> attributes;
  Map<int, dynamic> tmpAttributeObj = {};
  bool isRetrieving = true;
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    getProductVariables();
  }

  getProductVariables() async {
    print(widget.product);
    if (widget.product.productType == 'variable') {
      await HttpService.getProductAttributes(widget.product.id).then((a) {
        setState(() {
          attributes = a;
        });
      });
    }

    setState(() {
      isRetrieving = false;
    });
  }

  addProductToCart(
      BuildContext ctx,
      int productId,
      int attributeId,
      int quantity,
      num buyingPrice,
      num price,
      bool withPop,
      String description) async {
    FocusManager.instance.primaryFocus.unfocus();
    Size size;
    if (description != null) {
      size = (TextPainter(
              text: TextSpan(text: description),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;
      print(size.aspectRatio);
    }
    modalBottom(
      context,
      // height: description != null
      //     ? isEnglish(context)
      //         ? SizeConfig.blockSizeVertical * 50
      //         : SizeConfig.blockSizeVertical * 52
      //     : SizeConfig.blockSizeVertical * 35,
      title: description != null
          ? trans(context, 'description')
          : trans(context, 'select_quantity'),
      bodyWidget:
          StatefulBuilder(builder: (BuildContext ctx, StateSetter setState) {
        return Column(
          children: [
            description != null
                ? Column(
                    children: [
                      Wrap(
                        children: [
                          Text(
                            description.length > 150
                                ? description.substring(0, 150)
                                : description,
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          description.length > 150
                              ? InkWell(
                                  onTap: () =>
                                      _showDescriptionDialog(description),
                                  child: Text(
                                    ' ${trans(context, 'read_more')}',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        ],
                      ),
                    ],
                  )
                : Container(),
            Text(
              trans(context, 'select_quantity'),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 8,
              child: CustomNumberPicker(
                initialValue: 1,
                maxValue: 100,
                minValue: 1,
                step: 1,
                valueTextStyle: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                ),
                customAddButton:
                    Icon(Icons.add, size: 26, color: Colors.black87),
                customMinusButton:
                    Icon(Icons.remove, size: 26, color: Colors.black87),
                onValue: (value) {
                  print(value.toString());
                  setState(() {
                    selectedQuantity = value;
                  });
                },
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical),
            widget.product.productType == 'simple' &&
                    widget.product.stockStatus != 1
                ? Column(
                    children: [
                      Text(
                        trans(context, 'out_of_stock'),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        '${price * selectedQuantity} ${trans(context, 'kd')}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                    ],
                  ),
            DefaultButton(
              text: trans(context, 'add_to_cart'),
              press: () async {
                if (widget.product.productType == 'simple' &&
                    widget.product.stockStatus != 1) {
                  Fluttertoast.showToast(
                    msg: trans(context, 'product_out_of_stock'),
                  );
                  return;
                }
                await HttpService.addToCart(
                  ctx,
                  authProvider.user.id,
                  widget.categoryId != null
                      ? widget.categoryId
                      : widget.product.categoryId,
                  productId,
                  attributeId,
                  selectedQuantity,
                  buyingPrice != null ? buyingPrice * selectedQuantity : 0,
                  price * selectedQuantity,
                ).then((value) {
                  if (value == "Product already exist in your cart!") {
                    Fluttertoast.showToast(
                      msg: trans(context, 'product_already_exist_in_cart'),
                    );
                  } else if (value == "Product added to cart!") {
                    Fluttertoast.showToast(
                      msg: trans(context, 'product_added_to_cart'),
                    );
                    CartProvider cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.getUserCartCount(authProvider.user.id);
                    cartProvider.getUserCart(authProvider.user.id);
                  }
                  if (withPop) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    FocusManager.instance.primaryFocus.unfocus();
                  } else
                    Navigator.pop(context);
                  FocusManager.instance.primaryFocus.unfocus();
                });
              },
            ),
            // SizedBox(height: SizeConfig.blockSizeVertical * 3),
          ],
        );
      }),
    );
  }

  ProductAttributes findProductVariation() {
    ProductAttributes tmpProductVariation;

    Map<String, dynamic> tmpSelectedObj = {};
    (tmpAttributeObj.values).forEach((attributeObj) {
      tmpSelectedObj[attributeObj["name"]] = attributeObj["value"];
    });
    tmpSelectedObj["description"] = widget.product.description;

    attributes.forEach((productVariation) {
      Map<String, dynamic> tmpVariations = {};
      print('we are here');

      if (productVariation.salePrice != null &&
          productVariation.salePrice != 0) {
        print('sale price not null');
        tmpVariations[productVariation.name] = productVariation.salePrice;
      } else {
        tmpVariations[productVariation.name] = productVariation.price;
      }

      if (tmpVariations.toString() == tmpSelectedObj.toString()) {
        tmpProductVariation = productVariation;
      }

      print(tmpProductVariation);
    });

    return tmpProductVariation;
  }

  _showDescriptionDialog(String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            description,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _addToCart(),
      child: Card(
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              Row(
                children: [
                  !isRetrieving
                      ? widget.product.salePrice != null &&
                                  widget.product.salePrice != 0 ||
                              (attributes != null &&
                                  attributes[0].salePrice != null)
                          ? Text(
                              widget.product.productType == 'simple'
                                  ? '${widget.product.salePrice} ${trans(context, 'kd')}'
                                  : '${attributes[0].salePrice} ${trans(context, 'kd')}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                              ),
                            )
                          : Text(
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
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                  widget.product.salePrice != null &&
                              widget.product.salePrice != 0 ||
                          (attributes != null &&
                              attributes[0].salePrice != null)
                      ? Text(
                          widget.product.productType == 'simple'
                              ? '${widget.product.price} ${trans(context, 'kd')}'
                              : '${attributes[0].price} ${trans(context, 'kd')}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        )
                      : Container(),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () => _addToCart(),
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
      ),
    );
  }

  _addToCart() {
    if (widget.product.productType == 'simple')
      addProductToCart(
        context,
        widget.product.id,
        0,
        1,
        widget.product.buyingPrice,
        widget.product.salePrice != null && widget.product.salePrice != 0
            ? widget.product.salePrice
            : widget.product.price,
        false,
        widget.product.description,
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
  }
}
