import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/providers/cart_provider.dart';
import 'package:mosques_donation_app/screens/cart_categories/cart_categories_screen.dart';
import 'package:mosques_donation_app/screens/categories/widgets/category_list_item.dart';
import 'package:mosques_donation_app/screens/search/search_screen.dart';
import 'package:mosques_donation_app/screens/top_ten_products_list/top_products_list_screen.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/custom_card_button.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeName = "/categories_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Stack(
          children: [
            Icon(FluentIcons.cart_24_regular, size: 30),
            Consumer<CartProvider>(
              builder: (context, cart, _) => cart.getCartCount() != 0
                  ? Padding(
                      padding: isEnglish(context)
                          ? EdgeInsets.only(
                              right: SizeConfig.blockSizeHorizontal * 2.5,
                            )
                          : EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 2.5,
                            ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          maxRadius: 7,
                          child: Text(
                            '${cart.getCartCount()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 2.8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
        onPressed: () =>
            Navigator.pushNamed(context, CartCategoriesScreen.routeName),
      ),
      actions: [
        IconButton(
          icon: Icon(FluentIcons.search_24_regular, size: 30),
          onPressed: () => Navigator.pushNamed(context, SearchScreen.routeName),
        ),
      ],
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBannerCarousel(),
          _buildProductsButton(context),
          _buildCategoryGridView(),
        ],
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
                height: SizeConfig.blockSizeVertical * 18,
                viewportFraction: 0.6,
              ),
              items: app.banners.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => _launchURL(i.url),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 2),
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

  _buildProductsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 4,
        vertical: SizeConfig.blockSizeVertical * 2,
      ),
      child: CustomCardButton(
        height: SizeConfig.blockSizeVertical * 10,
        text: trans(context, 'top_ten_products'),
        onPressed: () =>
            Navigator.pushNamed(context, TopTenProductsListScreen.routeName),
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
          categoryId: app.categories[i].id,
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
