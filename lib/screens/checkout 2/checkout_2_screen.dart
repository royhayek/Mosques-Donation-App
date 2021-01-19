import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart' as p;
import 'package:location/location.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/models/order.dart';
import 'package:mosques_donation_app/models/organisation.dart';
import 'package:mosques_donation_app/screens/checkout/widgets/custom_text_field.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/custom_card_button.dart';
import 'package:mosques_donation_app/widgets/custom_drop_down.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';

const kGoogleApiKey = "AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw";

class Checkout2Screen extends StatefulWidget {
  static String routeName = "checkout_2_screen";

  final Category category;
  final PickResult mosque;
  final Cart cart;

  const Checkout2Screen({Key key, this.category, this.mosque, this.cart})
      : super(key: key);

  @override
  _Checkout2ScreenState createState() => _Checkout2ScreenState();
}

class _Checkout2ScreenState extends State<Checkout2Screen> {
  // TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _govController = TextEditingController();
  TextEditingController _blockController = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _mosqueController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final kInitialPosition = LatLng(29.378586, 47.990341);
  LocationData currentLocation;
  String _selectedOrganisation;
  String _selectedCemetry;
  List<Organisation> organisations = [];
  List<String> cemetries = [
    'مقبرة الصليبخات',
    'مقبرة صبحان',
    'مقبرة الجهراء',
    'المقبرة الجعفرية',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('we are here');
    switch (widget.category.templateId) {
      case 1:
        _getOrganisations();
        break;
      case 2:
      case 5:
        if (widget.mosque != null) {
          _getLocation(
            widget.mosque.geometry.location.lat,
            widget.mosque.geometry.location.lng,
            mosque: widget.mosque.formattedAddress,
          );
        }
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }

  _buildAddressAndGeolocation() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            widget.category.templateId == 4
                ? Column(
                    children: [
                      CustomCardButton(
                        height: SizeConfig.blockSizeVertical * 8,
                        text: 'Select Mosque',
                        onPressed: () => _buildLocationMap(),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      Text('Or'),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      CustomCardButton(
                        height: SizeConfig.blockSizeVertical * 8,
                        text: 'Select Current Location',
                        onPressed: () => _determinePosition().then((position) {
                          _getLocation(position.latitude, position.longitude);
                        }),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 3),
                    ],
                  )
                : Container(),
            widget.category.templateId == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By',
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
                : Container(),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              trans(context, 'donator_name'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _nameController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              trans(context, 'phone_no'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _phoneController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            widget.category.templateId == 4
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'City',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      CustomTextField(
                        maxLines: 1,
                        controller: _cityController,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      Text(
                        'Street',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      CustomTextField(
                        maxLines: 1,
                        controller: _streetController,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      Text(
                        'Block',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      CustomTextField(
                        maxLines: 1,
                        controller: _blockController,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      Text(
                        'Governorate',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      CustomTextField(
                        maxLines: 1,
                        controller: _govController,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      Text(
                        trans(context, 'delivery_notes'),
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      CustomTextField(
                          maxLines: 6, controller: _notesController),
                    ],
                  )
                : Container(),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            DefaultButton(
              press: () => widget.category.templateId == 4
                  ? _consolationCheckout()
                  : _foodCheckout(),
              text: trans(context, 'checkout'),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
          ],
        ),
      ),
    );
  }

  _buildInformationFields() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          widget.mosque == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cemetry',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4.8,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomStringDropDown(
                      hint: '',
                      enabled: true,
                      height: SizeConfig.blockSizeVertical * 7,
                      items: cemetries.map((String cemetry) {
                        return DropdownMenuItem<String>(
                          value: cemetry,
                          child: Text(cemetry),
                        );
                      }).toList(),
                      selectedValue: _selectedCemetry,
                      onChanged: (cemetry) {
                        _selectedCemetry = cemetry;
                      },
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                  ],
                )
              : Container(),
          Text(
            trans(context, 'donator_name'),
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          CustomTextField(maxLines: 1, controller: _nameController),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          Text(
            trans(context, 'phone_no'),
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          CustomTextField(maxLines: 1, controller: _phoneController),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          widget.mosque != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomTextField(
                      maxLines: 1,
                      controller: _cityController,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Text(
                      'Street',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomTextField(maxLines: 1, controller: _streetController),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Text(
                      'Block',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomTextField(maxLines: 1, controller: _blockController),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Text(
                      'Governorate',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomTextField(maxLines: 1, controller: _govController),
                  ],
                )
              : Container(),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          Text(
            trans(context, 'delivery_notes'),
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          CustomTextField(maxLines: 6, controller: _notesController),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
          DefaultButton(
            press: () =>
                widget.mosque != null ? _mosqueCheckout() : _cemetryCheckout(),
            text: trans(context, 'checkout'),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
        ],
      ),
    );
  }

  _mosqueCheckout() async {
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
    order.categoryId = widget.category.id;
    order.mosque = _mosqueController.value.text;
    order.donorName = _nameController.value.text;
    order.phoneNo = _phoneController.value.text;
    order.deliveryNotes = _notesController.value.text;
    order.cartId = widget.cart.id;
    order.userId = _auth.currentUser.uid.toString();
    order.address = address;

    await HttpService.makeOrder(order);
  }

  _cemetryCheckout() async {
    print(_selectedCemetry);
    Order order = new Order();
    order.categoryId = widget.category.id;
    order.cemetry = _selectedCemetry;
    order.donorName = _nameController.value.text;
    order.phoneNo = _phoneController.value.text;
    order.deliveryNotes = _notesController.value.text;
    order.cartId = widget.cart.id;
    order.userId = _auth.currentUser.uid.toString();

    await HttpService.makeOrder(order);
  }

  _foodCheckout() async {
    print(_selectedCemetry);
    Order order = new Order();
    order.categoryId = widget.category.id;
    order.by = _selectedOrganisation;
    order.donorName = _nameController.value.text;
    order.phoneNo = _phoneController.value.text;
    order.deliveryNotes = _notesController.value.text;
    order.cartId = widget.cart.id;
    order.userId = _auth.currentUser.uid.toString();

    await HttpService.makeOrder(order);
  }

  _consolationCheckout() async {
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
    order.categoryId = widget.category.id;
    order.donorName = _nameController.value.text;
    order.phoneNo = _phoneController.value.text;
    order.deliveryNotes = _notesController.value.text;
    order.cartId = widget.cart.id;
    order.userId = _auth.currentUser.uid.toString();
    order.address = address;
    if (_mosqueController.text.isNotEmpty)
      order.mosque = _mosqueController.text;

    await HttpService.makeOrder(order);
  }

  _getOrganisations() async {
    await HttpService.getOrganisations().then((o) {
      setState(() {
        organisations = o;
        organisations.insert(0, Organisation(id: 0, name: 'Administration'));
        print(organisations);
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
      body: SingleChildScrollView(
        child: widget.category.templateId == 1
            ? _buildAddressAndGeolocation()
            : widget.category.templateId == 2 || widget.category.templateId == 5
                ? _buildInformationFields()
                : widget.category.templateId == 4
                    ? _buildAddressAndGeolocation()
                    : Container(),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
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
                selectedPlaceWidget(selectedPlace, state, isSearchBarFocused),
          ),
        ),
      ),
    );

    await _getLocation(
      result.geometry.location.lat,
      result.geometry.location.lng,
      mosque: result.formattedAddress,
    );
  }

  Widget selectedPlaceWidget(
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
                          selectedPlace.formattedAddress,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        RaisedButton(
                          child: Text('Select'),
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
}
