import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/utils/utils.dart';

import '../../../size_config.dart';

class DonationListItem extends StatelessWidget {
  final Product product;

  const DonationListItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () => null,
            child: Row(
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
                        product.attribute != null
                            ? '${product.name} - ${product.attribute.name} x ${product.quantity}'
                            : '${product.name} x  ${product.quantity}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.1),
                      Text(
                        '${product.productPrice} ${trans(context, 'kd')}',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 3.8,
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.1),
                      Container(
                        padding: EdgeInsets.all(
                          SizeConfig.blockSizeHorizontal * 0.9,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 4,
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          product.createdAt.substring(0, 10),
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
