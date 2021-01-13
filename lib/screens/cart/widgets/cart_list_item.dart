import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class CartListItem extends StatelessWidget {
  final Product product;
  final Function remove;
  final Function update;

  const CartListItem({Key key, this.product, this.remove, this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Image.network(
                '${HttpService.PRODUCT_IMAGES_PATH}${product.image}',
                width: 100,
                height: 90,
              ),
              SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      product.productType == 'simple'
                          ? product.name
                          : product.name + ' - ' + product.attribute.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Row(
                      children: [
                        Text('${product.productPrice} ${trans(context, 'kd')}'),
                        Spacer(),
                        quantityPickerWidget(context),
                        SizedBox(width: SizeConfig.blockSizeHorizontal * 10),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 10,
                height: SizeConfig.blockSizeHorizontal * 10,
                child: IconButton(
                  icon: Icon(FluentIcons.delete_28_regular),
                  splashRadius: SizeConfig.blockSizeHorizontal * 5,
                  iconSize: SizeConfig.blockSizeHorizontal * 6,
                  onPressed: () {
                    remove(product.cartId);
                  },
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  quantityPickerWidget(BuildContext context) {
    return Row(
      children: [
        quantityPickerButton(
          context,
          Icons.remove,
          () => product.quantity != 1
              ? update(
                  product.cartId,
                  product.quantity - 1,
                  (product.quantity - 1) *
                      (product.productType == 'simple'
                          ? product.price
                          : product.attribute.price),
                )
              : null,
        ),
        SizedBox(width: SizeConfig.blockSizeHorizontal * 2.5),
        Text(product.quantity.toString()),
        SizedBox(width: SizeConfig.blockSizeHorizontal * 2.5),
        quantityPickerButton(
          context,
          Icons.add,
          () => update(
            product.cartId,
            product.quantity + 1,
            (product.quantity + 1) *
                (product.productType == 'simple'
                    ? product.price
                    : product.attribute.price),
          ),
        ),
      ],
    );
  }

  quantityPickerButton(
      BuildContext context, IconData iconData, Function update) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 24,
        height: 24,
        child: Icon(iconData, size: 18, color: Colors.white),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onTap: update,
    );
  }
}
