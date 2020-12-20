import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/subcategories/subcategories_screen.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, SubCategoriesScreen.routeName),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.12),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Name',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.black87),
                ),
                SizedBox(height: 10),
                Text('Description'),
              ],
            ),
            Spacer(),
            Icon(FluentIcons.ios_chevron_right_20_regular)
          ],
        ),
      ),
    );
  }
}
