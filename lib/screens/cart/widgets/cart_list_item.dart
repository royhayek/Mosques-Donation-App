import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class CartListItem extends StatelessWidget {
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
          InkWell(
            onTap: () => null,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/water_pack.jpg',
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
                        'Sohat Water Pack 6x1L',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      Text('3 ${trans(context, 'kd')}'),
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
                      onPressed: () => null),
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
