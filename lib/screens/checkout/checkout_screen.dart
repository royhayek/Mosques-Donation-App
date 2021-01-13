import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/models/organisation.dart';
import 'package:mosques_donation_app/screens/checkout%202/checkout_2_screen.dart';
import 'package:mosques_donation_app/screens/checkout/widgets/custom_text_field.dart';
import 'package:mosques_donation_app/screens/products_list/products_list_screen.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';

const kGoogleApiKey = "AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw";

class CheckoutScreen extends StatefulWidget {
  static String routeName = "checkout_screen";

  final Category category;

  const CheckoutScreen({Key key, this.category}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static final kInitialPosition = LatLng(29.378586, 47.990341);
  List<Organisation> organisations = [];
  Widget _body;
  String selectedOrganisation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print(widget.category.templateId);
    switch (widget.category.templateId) {
      case 1:
        _body = Container();
        break;
      case 2:
        _body = _getMosques();
        break;
      case 3:
        _getOrganisations();
        break;
      case 4:
        _body = _buildCustomDonation();
        break;
    }
  }

  _getOrganisations() async {
    await HttpService.getOrganisations().then((o) {
      setState(() {
        organisations = o;
        _body = _buildOrganisationsListView();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name),
          centerTitle: true,
        ),
        body: _body);
  }

  _buildOrganisationsListView() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search here...",
                alignLabelWithHint: false,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.only(
                    left: 14.0, bottom: 6.0, top: 8.0, right: 14.0),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  print('we are here');
                  setState(() {
                    selectedOrganisation = value;
                  });
                  //autoCompleteSearch(value);
                }
              },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: organisations.isNotEmpty
                ? ListView.builder(
                    itemCount: organisations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.pin_drop, color: Colors.white),
                        ),
                        title: Text(organisations[index].name),
                        onTap: () {
                          debugPrint(organisations[index].name);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ProductsListScreen(
                          //       placeId: predictions[index].placeId,
                          //       googlePlace: googlePlace,
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'Start looking for mosques',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _buildCustomDonation() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical * 3),
          Text(
            trans(context, 'phone_no'),
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          CustomTextField(maxLines: 1),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          Text(
            trans(context, 'please_describe_your_donation'),
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          CustomTextField(maxLines: 6),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
          DefaultButton(
            press: () => null,
            text: trans(context, 'submit'),
          ),
        ],
      ),
    );
  }

  _getMosques() {
    return PlacePicker(
      apiKey: "AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw",
      autocompleteComponents: [
        Component('country', 'kw'),
      ],
      initialPosition: kInitialPosition,
      selectInitialPosition: true,
      useCurrentLocation: false,
      myLocationButtonCooldown: 2,
      usePlaceDetailSearch: true,
      enableMyLocationButton: true,
      automaticallyImplyAppBarLeading: false,
      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused) => selectedPlaceWidget(
              selectedPlace, state, isSearchBarFocused, 'checkout'),
    );
  }

  Widget selectedPlaceWidget(PickResult selectedPlace, SearchingState state,
      bool isSearchBarFocused, String route) {
    return isSearchBarFocused
        ? Container()
        : FloatingCard(
            bottomPosition: 40.0,
            leftPosition: 10.0,
            rightPosition: 10.0,
            width: 500,
            elevation: 5,
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: selectedPlace != null
                  ? Column(
                      children: [
                        Text(
                          selectedPlace.formattedAddress,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        RaisedButton(
                          child: Text('Select'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => route != 'checkout'
                                    ? ProductsListScreen(
                                        placeId: selectedPlace.placeId,
                                        photos: selectedPlace.photos,
                                      )
                                    : Checkout2Screen(
                                        category: widget.category,
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          );
  }
}
