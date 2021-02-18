import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/src/places.dart' as p;
import 'package:google_place/google_place.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/models/subcategory.dart';
import 'package:mosques_donation_app/widgets/product_list_item.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class ProductsListScreen extends StatefulWidget {
  static String routeName = "/products_list_screen";

  final String placeId;
  final GooglePlace googlePlace;
  final Subcategory subcategory;
  final Category category;
  final int categoryId;
  final List<p.Photo> photos;

  const ProductsListScreen({
    Key key,
    this.placeId,
    this.googlePlace,
    this.subcategory,
    this.category,
    this.categoryId,
    this.photos,
  }) : super(key: key);

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DetailsResult detailsResult;
  List<Uint8List> images = [];
  List<String> imagesString = [];
  List<Product> products;
  bool isLoading = true;
  Widget body;

  @override
  void initState() {
    super.initState();
    if (widget.googlePlace != null) {
      getDetails(widget.placeId);
      getProductByCategory(1);
    } else if (widget.photos != null) {
      widget.photos.forEach((p) {
        imagesString.add(
            'https://maps.googleapis.com/maps/api/place/photo?photoreference=${p.photoReference}&sensor=false&maxheight=200&maxwidth=400&key=AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw');
      });

      getProductByCategory(1);
    } else {
      if (widget.subcategory != null)
        getProductBySubcategory();
      else
        getProductByCategory(widget.category.id);
    }
  }

  getProductByCategory(int id) async {
    await HttpService.getProductsByCategory(id).then((p) {
      setState(() {
        products = p;
        print(products);
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  getProductBySubcategory() async {
    await HttpService.getProductsBySubcategory(widget.subcategory.id).then((p) {
      setState(() {
        products = p;
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 35,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 1,
                      spreadRadius: 0.5,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: !isLoading
                    ? images.isNotEmpty
                        ? Image.memory(
                            images[0],
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : widget.subcategory != null
                            ? Image.network(
                                '${HttpService.SUBCATEGORY_IMAGES_PATH}${widget.subcategory.image}',
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.contain,
                              )
                            : widget.category != null
                                ? Image.network(
                                    '${HttpService.CATEGORY_IMAGES_PATH}${widget.category.image}',
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.contain,
                                  )
                                : widget.photos != null
                                    ? Image.network(
                                        '${imagesString.first}',
                                        width: double.infinity,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 250,
                                        color: Colors.grey.shade200,
                                        child: Center(
                                          child: Text(
                                            'No Image Available',
                                            style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  6,
                                            ),
                                          ),
                                        ),
                                      )
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        color: Colors.grey.shade200,
                      ),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 10.2,
                height: SizeConfig.blockSizeHorizontal * 10.2,
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3.8,
                    vertical: SizeConfig.blockSizeVertical * 5.3),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 1,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: Theme.of(context).iconTheme.color,
                      ),
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
              trans(context, 'donations_list'),
              style: GoogleFonts.ptSans(
                fontSize: SizeConfig.safeBlockHorizontal * 6,
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return false;
              },
              child: !isLoading
                  ? products != null && products.isNotEmpty
                      ? GridView.builder(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 50,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) => ProductListItem(
                            context: context,
                            product: products[index],
                            categoryId: widget.category != null
                                ? widget.category.id
                                : widget.categoryId,
                            subcategory: widget.subcategory,
                          ),
                        )
                      : Center(child: Text(trans(context, 'no_products_yet')))
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  void getDetails(String placeId) async {
    var result = await this.widget.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result;
        images = [];
      });

      if (result.result.photos != null) {
        for (var photo in result.result.photos) {
          getPhoto(photo.photoReference);
        }
      }
    }
  }

  void getPhoto(String photoReference) async {
    var result =
        await this.widget.googlePlace.photos.get(photoReference, null, 400);
    if (result != null && mounted) {
      setState(() {
        images.add(result);
        isLoading = false;
      });
    }
  }
}
