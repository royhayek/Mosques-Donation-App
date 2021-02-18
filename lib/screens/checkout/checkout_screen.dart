import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mosques_donation_app/database/user_info_db.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/models/order.dart';
import 'package:mosques_donation_app/models/organisation.dart';
import 'package:mosques_donation_app/models/subcategory.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/screens/checkout%202/checkout_2_screen.dart';
import 'package:mosques_donation_app/screens/checkout/widgets/custom_text_field.dart';
import 'package:mosques_donation_app/screens/products_list/products_list_screen.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/custom_card_button.dart';
import 'package:mosques_donation_app/widgets/custom_drop_down.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_webservice/places.dart' as p;

const kGoogleApiKey = "AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw";

class CheckoutScreen extends StatefulWidget {
  static String routeName = "checkout_screen";

  final Subcategory subcategory;
  final Category category;
  final int categoryId;
  final Cart cart;

  const CheckoutScreen(
      {Key key, this.categoryId, this.cart, this.subcategory, this.category})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _donorController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _mosqueController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _govController = TextEditingController();
  TextEditingController _blockController = TextEditingController();

  static final kInitialPosition = LatLng(29.378586, 47.990341);
  AuthProvider authProvider;
  List<Organisation> organisations = [];
  Widget _body;
  String selectedOrganisation;
  var db = new UserDatabaseHelper();
  bool _showMosque = true;
  String _selectedOrganisation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (widget.cart != null) {
      switch (widget.cart.templateId) {
        case 1:
          _body = Container();
          break;
        case 2:
        case 5:
          _body = _getMosques();
          break;
        case 3:
          _getOrganisations();
          break;
        case 4:
          // _body = _buildCustomDonation();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (ctx) => Checkout2Screen(
          //       cart: widget.cart,
          //       categoryId: widget.categoryId,
          //     ),
          //   ),
          // );
          break;
      }
    } else if (widget.subcategory != null) {
      if (widget.subcategory.showCustomField == 1) {
        _body = _buildCustomDonation();
      } else {
        _body = _getMosques();
      }
    } else if (widget.category != null) {
      if (widget.category.showCustomField == 1) {
        _body = _buildMosqueCustomDonation();
      } else if (widget.category.showCustomField2 == 1) {
        print('we are here');
        _body = _buildMosqueGeolocation();
      }
    }

    _donorController.text = authProvider.user.name;
    _phoneController.text = authProvider.user.phone;
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
        title: Text(
          widget.subcategory != null
              ? widget.subcategory.name
              : widget.category != null
                  ? widget.category.name
                  : widget.cart.name,
        ),
        centerTitle: true,
      ),
      body: _body,
    );
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
    return SingleChildScrollView(
      child: Padding(
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
            CustomTextField(maxLines: 1, controller: _phoneController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              trans(context, 'donator_name'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _donorController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              trans(context, 'please_describe_your_donation'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 8, controller: _notesController),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            DefaultButton(
              press: () => _customDonationCheckout(),
              text: trans(context, 'submit'),
            ),
          ],
        ),
      ),
    );
  }

  _buildMosqueCustomDonation() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 3),
            Text(
              '${trans(context, 'mosque')}*',
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(
              maxLines: 1,
              controller: _mosqueController,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              '${trans(context, 'mosque_address')}*',
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(
              maxLines: 1,
              controller: _addressController,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              trans(context, 'phone_no'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _phoneController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              trans(context, 'donator_name'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _donorController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              trans(context, 'missing_products_notes_in_the_mosque'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 8, controller: _notesController),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            DefaultButton(
              press: () => _customMosqueCustomDonation(),
              text: trans(context, 'submit'),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2),
          ],
        ),
      ),
    );
  }

  _buildMosqueGeolocation() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Column(
              children: [
                CustomCardButton(
                  height: SizeConfig.blockSizeVertical * 8,
                  text: trans(context, 'select_mosque'),
                  onPressed: () {
                    setState(() {
                      _showMosque = true;
                    });
                    _buildLocationMap();
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
              ],
            ),
            widget.cart != null
                ? widget.cart.templateId == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${trans(context, 'by')}*',
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                          CustomStringDropDown(
                            hint: '',
                            enabled: true,
                            height: SizeConfig.blockSizeVertical * 7,
                            items: organisations.map((Organisation o) {
                              return DropdownMenuItem<String>(
                                value: o.name,
                                child: Text(o.name),
                              );
                            }).toList(),
                            selectedValue: _selectedOrganisation,
                            onChanged: (name) {
                              _selectedOrganisation = name;
                            },
                          ),
                        ],
                      )
                    : Container()
                : Container(),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              '${trans(context, 'donator_name')}*',
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _donorController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              '${trans(context, 'phone_no')}*',
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _phoneController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _showMosque
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${trans(context, 'mosque')}*',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4.8,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 1.5,
                          ),
                          CustomTextField(
                            maxLines: 1,
                            controller: _mosqueController,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 1.5,
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  '${trans(context, 'city')}*',
                  style:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                CustomTextField(
                  maxLines: 1,
                  controller: _cityController,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                Text(
                  '${trans(context, 'street')}*',
                  style:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                CustomTextField(
                  maxLines: 1,
                  controller: _streetController,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                Text(
                  '${trans(context, 'block')}*',
                  style:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                CustomTextField(
                  maxLines: 1,
                  controller: _blockController,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                Text(
                  '${trans(context, 'governorate')}*',
                  style:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                CustomTextField(
                  maxLines: 1,
                  controller: _govController,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
              ],
            ),
            Text(
              trans(context, 'notes'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 6, controller: _notesController),
            SizedBox(height: SizeConfig.blockSizeVertical * 2),
            DefaultButton(
              press: () {
                _customMosqueCustomDonation2();
              },
              text: trans(context, 'checkout'),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
          ],
        ),
      ),
    );
  }

  _customMosqueCustomDonation() async {
    Order order = new Order();
    order.mosque = _mosqueController.value.text;
    order.address = _addressController.value.text;
    order.subcategoryId =
        widget.subcategory != null ? widget.subcategory.id : null;
    order.categoryId = widget.categoryId;
    order.donorName = _donorController.value.text;
    order.phoneNo = _phoneController.value.text;
    order.deliveryNotes = _notesController.value.text;
    order.userId = authProvider.user.id.toString();

    await HttpService.makeOrder(context, order);
  }

  _customMosqueCustomDonation2() async {
    String block = '';
    if (_blockController.text.isNotEmpty &&
        !_blockController.text.contains('block'))
      block = 'Block ' + _blockController.text;
    else
      block = _blockController.text;

    String address = _cityController.text +
        '\n' +
        _streetController.text +
        '\n' +
        block +
        '\n' +
        _govController.text;

    Order order = new Order();
    order.mosque = _mosqueController.value.text;
    order.address = _addressController.value.text;
    order.subcategoryId =
        widget.subcategory != null ? widget.subcategory.id : null;
    order.categoryId = widget.categoryId;
    order.donorName = _donorController.value.text;
    order.phoneNo = _phoneController.value.text;
    order.deliveryNotes = _notesController.value.text;
    order.userId = authProvider.user.id.toString();
    order.address = address;
    // order.coordination = widget.mosque.geometry.location.toString();

    await HttpService.makeOrder(context, order);
  }

  _customDonationCheckout() async {
    Order order = new Order();
    order.subcategoryId =
        widget.subcategory != null ? widget.subcategory.id : null;
    order.categoryId = widget.categoryId;
    order.donorName = _donorController.value.text;
    order.phoneNo = _phoneController.value.text;
    order.deliveryNotes = _notesController.value.text;
    order.userId = authProvider.user.id.toString();

    await HttpService.makeOrder(context, order);
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
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              child: selectedPlace != null
                  ? Column(
                      children: [
                        Text(
                          selectedPlace.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        RaisedButton(
                          child: Text(trans(context, 'select')),
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
                                        // category: widget.category,
                                        categoryId: widget.categoryId,
                                        mosque: selectedPlace,
                                        cart: widget.cart,
                                        mosqueCare: true,
                                        subcategoryId:
                                            widget.subcategory != null
                                                ? widget.subcategory.id
                                                : null,
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

  _buildLocationMap() async {
    PickResult result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: Text('Select the location'),
            centerTitle: true,
          ),
          body: PlacePicker(
            apiKey: "AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw",
            autocompleteComponents: [
              p.Component('country', 'kw'),
            ],
            initialPosition: kInitialPosition,
            selectInitialPosition: true,
            useCurrentLocation: true,
            automaticallyImplyAppBarLeading: false,
            searchForInitialValue: true,
            usePinPointingSearch: true,
            selectedPlaceWidgetBuilder: (_, selectedPlace, state,
                    isSearchBarFocused) =>
                selectedPlaceWidget2(selectedPlace, state, isSearchBarFocused),
          ),
        ),
      ),
    );

    await _getLocation(
      result.geometry.location.lat,
      result.geometry.location.lng,
      mosque: result.name,
    );
  }

  Widget selectedPlaceWidget2(
      PickResult selectedPlace, SearchingState state, bool isSearchBarFocused) {
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
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              child: selectedPlace != null
                  ? Column(
                      children: [
                        Text(
                          selectedPlace.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        RaisedButton(
                          child: Text(trans(context, 'select')),
                          onPressed: () {
                            Navigator.pop(context, selectedPlace);
                          },
                        ),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          );
  }

  _getLocation(double latitude, double longitude, {String mosque}) async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        "${first.featureName} : ${first.addressLine} : ${first.adminArea} : ${first.subThoroughfare} : ${first.subAdminArea} : ${first.subLocality}");

    _mosqueController.clear();
    _cityController.clear();
    _streetController.clear();
    _govController.clear();
    _blockController.clear();

    setState(() {
      if (mosque != null) _mosqueController.text = mosque;
      _cityController.text = first.locality;
      _streetController.text = first.addressLine;
      _govController.text = first.adminArea;
    });
  }
}
