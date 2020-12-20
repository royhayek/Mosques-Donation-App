import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosques_donation_app/screens/subcategories/widgets/subcategory_list_item.dart';

class SubCategoriesScreen extends StatelessWidget {
  static String routeName = "/subcategories_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white, blurRadius: 1, spreadRadius: 0.5)
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                child: Image.asset(
                  'assets/images/kuwait_mosque.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white, blurRadius: 1, spreadRadius: 0.5)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
            child: Text(
              'Donations List',
              style: GoogleFonts.ptSans(fontSize: 20),
            ),
          ),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return false;
              },
              child: GridView(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                shrinkWrap: true,
                children: [
                  SubCategoryListItem(),
                  SubCategoryListItem(),
                  SubCategoryListItem(),
                  SubCategoryListItem(),
                  SubCategoryListItem(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
