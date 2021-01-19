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
  String translated;
  translated = AppLocalizations.of(context).translate(text);
  return translated;
}

bool isEnglish(BuildContext context) {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  return appProvider.getLanguage() == 'English';
}

void modalBottomSheetAttributes(BuildContext context,
    {Product product,
    Map tmpAttributeObj,
    Function findProductVariation,
    List<ProductAttributes> productAttributes,
    Function addProductToCart}) {
  modalBottom(
    context,
    height: 250,
    title: '',
    bodyWidget: ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 1,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.black12,
        thickness: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        print(tmpAttributeObj);
        return ListTile(
          title:
              Text('Select an option', style: TextStyle(color: Colors.black)),
          trailing: (tmpAttributeObj.isNotEmpty)
              ? Text(tmpAttributeObj["name"])
              : Icon(Icons.chevron_right),
          onTap: () => modalBottomSheetOptionsForAttribute(
            context,
            product,
            tmpAttributeObj,
            findProductVariation,
            productAttributes,
            addProductToCart,
          ),
        );
      },
    ),
    extraWidget: Container(
      child: Column(
        children: <Widget>[
          Text(
            (tmpAttributeObj.isNotEmpty
                ? "Price" + ": " + '${tmpAttributeObj['value']} KD'
                : (((productAttributes.length == tmpAttributeObj.values.length))
                    ? "This variation is unavailable"
                    : "Choose your options")),
            style: Theme.of(context)
                .textTheme
                .headline1
                .merge(TextStyle(color: Colors.black, fontSize: 16)),
          ),
          Text(
            (findProductVariation() != null
                ? findProductVariation().stockStatus != "instock"
                    ? "Out of stock"
                    : ""
                : ""),
            style: TextStyle(color: Colors.black),
          ),
          DefaultButton(
            text: "Continue",
            press: () {
              if (tmpAttributeObj.isEmpty) {
                Fluttertoast.showToast(
                    msg: 'Please select valid options first');
                return;
              }

              if (findProductVariation() != null) {
                if (findProductVariation().stockStatus != 0) {
                  Fluttertoast.showToast(msg: 'This item is not in stock');
                  return;
                }
              }

              print('variations $tmpAttributeObj');

              addProductToCart(
                tmpAttributeObj['productId'],
                tmpAttributeObj['attributeId'],
                1,
                tmpAttributeObj['value'],
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

void modalBottom(BuildContext context,
    {double height, String title, Widget bodyWidget, Widget extraWidget}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (builder) {
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
                  padding: EdgeInsets.symmetric(vertical: 5),
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
    BuildContext context,
    Product product,
    Map tmpAttributeObj,
    Function findProductVariation,
    List<ProductAttributes> productAttributes,
    Function addProductToCart) {
  modalBottom(
    context,
    height: 300,
    title: "Select an option",
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
                '${productAttributes[index].price.toString()} KD',
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
              "name": productAttributes[index].name,
              "value": productAttributes[index].price
            };
            print(tmpAttributeObj);
            Navigator.pop(context);
            Navigator.pop(context);
            modalBottomSheetAttributes(
              context,
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
