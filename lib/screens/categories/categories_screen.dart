import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/screens/cart/cart_screen.dart';
import 'package:mosques_donation_app/screens/categories/widgets/category_list_item.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeName = "/categories_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FluentIcons.cart_24_regular, size: 30),
          onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
        ),
        actions: [
          IconButton(
            icon: Icon(FluentIcons.search_24_regular, size: 30),
            onPressed: () => null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBannerCarousel(),
            _buildProductsButton(),
            _buildCategoryGridView(),
          ],
        ),
      ),
    );
  }

  _buildBannerCarousel() {
    return Consumer<AppProvider>(
      builder: (context, app, child) {
        if (app.banners.isNotEmpty)
          return Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 5),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                height: SizeConfig.blockSizeVertical * 22,
              ),
              items: app.banners.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => _launchURL(i.url),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            Image.network(
                              '${HttpService.BANNER_IMAGES_PATH}${i.image}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.blockSizeHorizontal * 3),
                                child: Text(
                                  i.title,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        else
          return Container();
      },
    );
  }

  _buildProductsButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 4,
          vertical: SizeConfig.blockSizeVertical * 2,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () => null,
            child: Text(
              'افضل ١٠ منتجات',
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCategoryGridView() {
    return Consumer<AppProvider>(
      builder: (context, app, _) => GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: app.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
          mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
        ),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 1,
          horizontal: SizeConfig.blockSizeHorizontal * 4,
        ),
        itemBuilder: (ctx, i) => CategoryListItem(
          category: app.categories[i],
        ),
      ),
    );
  }

  _launchURL(String imageUrl) async {
    if (await canLaunch(imageUrl)) {
      await launch(imageUrl);
    } else {
      throw 'Could not launch $imageUrl';
    }
  }
}
