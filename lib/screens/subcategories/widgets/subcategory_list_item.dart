import 'package:flutter/material.dart';

class SubCategoryListItem extends StatelessWidget {
  const SubCategoryListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/water_pack.jpg',
              width: double.infinity,
              height: 125,
              fit: BoxFit.fill,
            ),
            Text(
              'Sohat Water Pack 6x1L',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            Row(
              children: [
                Text(
                  '3 KD',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () => null,
                    radius: 45,
                    borderRadius: BorderRadius.circular(30),
                    child: Icon(Icons.add_shopping_cart, size: 23),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(0.0),
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 3.0,
            offset: new Offset(0.0, 1.0),
          ),
        ],
      ),
      margin: EdgeInsets.all(5.0),
      height: 150.0,
      width: 100.0,
    );
  }
}
