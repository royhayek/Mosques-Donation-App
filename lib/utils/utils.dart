import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/models/product_attributes.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/translation/app_localizations.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

String trans(BuildContext context, String text) {
  return AppLocalizations.of(context).translate(text);
}

bool isEnglish(BuildContext context) {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  return appProvider.getLanguage() == 'English';
}

void modalBottomSheetAttributes(BuildContext modalcontext,
    {Product product,
    Map tmpAttributeObj,
    Function findProductVariation,
    List<ProductAttributes> productAttributes,
    Function addProductToCart}) {
  modalBottom(
    modalcontext,
    height: product.description != null ? 400 : 250,
    title: '',
    bodyWidget: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          children: [
            product.description != null
                ? Text(
                    trans(modalcontext, 'description'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                : Container(),
            Text(
              product.description.length > 150
                  ? product.description.substring(0, 150)
                  : product.description,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            product.description.length > 150
                ? InkWell(
                    onTap: () => _showDescriptionDialog(
                        modalcontext, product.description),
                    child: Text(
                      ' ${trans(modalcontext, 'read_more')}',
                      style:
                          TextStyle(color: Theme.of(modalcontext).primaryColor),
                    ),
                  )
                : Container(),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            print(tmpAttributeObj);
            return ListTile(
              title: Text(trans(modalcontext, 'select_an_option'),
                  style: TextStyle(color: Colors.black)),
              trailing: (tmpAttributeObj.isNotEmpty)
                  ? Text(tmpAttributeObj["name"])
                  : Icon(Icons.chevron_right),
              onTap: () => modalBottomSheetOptionsForAttribute(
                modalcontext,
                product,
                tmpAttributeObj,
                findProductVariation,
                productAttributes,
                addProductToCart,
              ),
            );
          },
        ),
      ],
    ),
    extraWidget: Container(
      child: Column(
        children: <Widget>[
          Text(
            (tmpAttributeObj.isNotEmpty
                ? trans(modalcontext, 'price') +
                    ": " +
                    '${tmpAttributeObj['value']} ${trans(modalcontext, 'kd')}'
                : (((productAttributes.length == tmpAttributeObj.values.length))
                    ? "This variation is unavailable"
                    : trans(modalcontext, 'select_your_option'))),
            style: Theme.of(modalcontext).textTheme.headline1.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
          ),
          Text(
            (tmpAttributeObj.isNotEmpty
                ? tmpAttributeObj['stockStatus'] != 1
                    ? trans(modalcontext, 'out_of_stock')
                    : ""
                : ""),
            style: TextStyle(color: Theme.of(modalcontext).primaryColor),
          ),
          DefaultButton(
            text: trans(modalcontext, 'continue'),
            press: () {
              if (tmpAttributeObj.isNotEmpty &&
                  tmpAttributeObj['stockStatus'] != 1) {
                Fluttertoast.showToast(
                  msg: trans(modalcontext, 'product_out_of_stock'),
                );
                return;
              }

              if (tmpAttributeObj['value'] == null) {
                Fluttertoast.showToast(
                  msg: trans(modalcontext, 'please_select_an_option_first'),
                );
                return;
              }

              if (findProductVariation() != null) {
                if (findProductVariation().stockStatus != 0) {
                  Fluttertoast.showToast(msg: 'This item is not in stock');
                  return;
                }
              }

              addProductToCart(
                modalcontext,
                tmpAttributeObj['productId'],
                tmpAttributeObj['attributeId'],
                1,
                tmpAttributeObj['value'],
                true,
                null,
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
      margin: EdgeInsets.only(bottom: 10),
    ),
  );
}

_showDescriptionDialog(BuildContext dialogcontext, String description) {
  showDialog(
    context: dialogcontext,
    builder: (BuildContext ctx) {
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

void modalBottom(BuildContext modalcontext,
    {double height, String title, Widget bodyWidget, Widget extraWidget}) {
  showModalBottomSheet(
    context: modalcontext,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: bodyWidget,
                  ),
                ),
                extraWidget ?? null
              ].where((t) => t != null).toList(),
            ),
          ),
        ),
      );
    },
  );
}

void modalBottomSheetOptionsForAttribute(
    BuildContext modalcontext,
    Product product,
    Map tmpAttributeObj,
    Function findProductVariation,
    List<ProductAttributes> productAttributes,
    Function addProductToCart) {
  modalBottom(
    modalcontext,
    height: 300,
    title: trans(modalcontext, 'select_your_option'),
    bodyWidget: ListView.separated(
      itemCount: productAttributes.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Row(
            children: [
              Text(
                productAttributes[index].name,
                style: TextStyle(color: Colors.black),
              ),
              Spacer(),
              Text(
                productAttributes[index].salePrice != null &&
                        productAttributes[index].salePrice != 0
                    ? '${productAttributes[index].salePrice.toString()} ${trans(modalcontext, 'kd')}'
                    : '${productAttributes[index].price.toString()} ${trans(modalcontext, 'kd')}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              )
            ],
          ),
          trailing: (tmpAttributeObj.isNotEmpty &&
                  tmpAttributeObj["value"] == productAttributes[index].price)
              ? Icon(Icons.check, color: Colors.blueAccent)
              : Icon(Icons.check, color: Colors.white),
          onTap: () {
            tmpAttributeObj.clear();
            tmpAttributeObj = {
              "productId": productAttributes[index].productId,
              "attributeId": productAttributes[index].id,
              "stockStatus": productAttributes[index].stockStatus,
              "name": productAttributes[index].name,
              "value": productAttributes[index].salePrice != null &&
                      productAttributes[index].salePrice != 0
                  ? productAttributes[index].salePrice
                  : productAttributes[index].price
            };
            Navigator.pop(modalcontext);
            Navigator.pop(modalcontext);
            modalBottomSheetAttributes(
              modalcontext,
              product: product,
              tmpAttributeObj: tmpAttributeObj,
              findProductVariation: findProductVariation,
              productAttributes: productAttributes,
              addProductToCart: addProductToCart,
            );
          },
        );
      },
    ),
  );
}
