import 'package:flutter/material.dart';

class CartListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/water_pack.jpg',
              width: 90,
              height: 90,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sohat Water Pack 6x1L',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.black87),
                ),
                SizedBox(height: 12),
                Text('3 KD'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
