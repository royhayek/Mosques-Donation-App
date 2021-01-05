import 'package:flutter/material.dart';
import 'package:mosques_donation_app/utils/utils.dart';

import '../../../size_config.dart';

class DonationListItem extends StatelessWidget {
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
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.1),
                      Text(
                        '3 ${trans(context, 'kd')}',
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
                          '10/12/2020',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
