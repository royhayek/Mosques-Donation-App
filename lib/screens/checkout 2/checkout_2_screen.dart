import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart' as p;
import 'package:location/location.dart';
import 'package:mosques_donation_app/database/user_info_db.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/models/order.dart';
import 'package:mosques_donation_app/models/organisation.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/providers/cart_provider.dart';
import 'package:mosques_donation_app/screens/checkout/widgets/custom_text_field.dart';
import 'package:mosques_donation_app/screens/payment/payment_screen.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/custom_card_button.dart';
import 'package:mosques_donation_app/widgets/custom_drop_down.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

const kGoogleApiKey = "AIzaSyBG3keQpOZF3ISJgrlVBencyf3ZcmeQpfw";

class Checkout2Screen extends StatefulWidget {
  static String routeName = "checkout_2_screen";

  final int categoryId;
  final int subcategoryId;
  final PickResult mosque;
  final Cart cart;
  final bool mosqueCare;

  const Checkout2Screen(
      {Key key,
      this.mosque,
      this.cart,
      this.categoryId,
      this.subcategoryId,
      this.mosqueCare = false})
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

  AuthProvider authProvider;
  CartProvider cartProvider;
  AppProvider appProvider;

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
  bool _showMosque = true;
  String coordination;
  var db = new UserDatabaseHelper();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    appProvider = Provider.of<AppProvider>(context, listen: false);

    if (widget.cart != null) {
      switch (widget.cart.templateId) {
        case 1:
          _getOrganisations();
          break;
        case 2:
        case 5:
          if (widget.mosque != null) {
            _getLocation(
              widget.mosque.geometry.location.lat,
              widget.mosque.geometry.location.lng,
              mosque: widget.mosque.name,
            );
          }
          break;
        case 3:
          break;
        case 4:
          break;
      }
    } else {
      if (widget.mosque != null) {
        _getLocation(
          widget.mosque.geometry.location.lat,
          widget.mosque.geometry.location.lng,
          mosque: widget.mosque.formattedAddress,
        );
      }
    }

    _nameController.text = authProvider.user.name;
    _phoneController.text = authProvider.user.phone;
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
            widget.cart != null
                ? widget.cart.templateId == 4
                    ? Column(
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
                          SizedBox(height: SizeConfig.blockSizeVertical * 1),
                          Text(trans(context, 'or')),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1),
                          CustomCardButton(
                            height: SizeConfig.blockSizeVertical * 8,
                            text: trans(context, 'select_current_location'),
                            onPressed: () {
                              setState(() {
                                _showMosque = false;
                              });
                              _determinePosition().then((position) {
                                _getLocation(
                                    position.latitude, position.longitude);
                              });
                            },
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 3),
                        ],
                      )
                    : Container()
                : Container(),
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
            CustomTextField(maxLines: 1, controller: _nameController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Text(
              '${trans(context, 'phone_no')}*',
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 1, controller: _phoneController),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            widget.cart != null
                ? widget.cart.templateId == 4
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _showMosque
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${trans(context, 'mosque')}*',
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                4.8,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeVertical * 1.5,
                                    ),
                                    CustomTextField(
                                      maxLines: 1,
                                      controller: _mosqueController,
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.blockSizeVertical * 1.5,
                                    ),
                                  ],
                                )
                              : Container(),
                          Text(
                            '${trans(context, 'city')}*',
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
                            '${trans(context, 'street')}*',
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
                            '${trans(context, 'block')}*',
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
                            '${trans(context, 'governorate')}*',
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                          CustomTextField(
                            maxLines: 1,
                            controller: _govController,
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                        ],
                      )
                    : Container()
                : Container(),
            Text(
              trans(context, 'delivery_notes'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            CustomTextField(maxLines: 6, controller: _notesController),
            SizedBox(height: SizeConfig.blockSizeVertical * 4),
            widget.cart.templateId == 4
                ? Text(
                    '${trans(context, 'delivery_fee')}: ${appProvider.settings.consolationDeliveryFee} ${trans(context, 'kd')}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(height: SizeConfig.blockSizeVertical * 2),
            DefaultButton(
              press: () {
                widget.cart.templateId == 4
                    ? _consolationCheckout()
                    : _foodCheckout();
              },
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
                      '${trans(context, 'cemetry')}*',
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
            '${trans(context, 'donator_name')}*',
            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.8),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          CustomTextField(maxLines: 1, controller: _nameController),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          Text(
            '${trans(context, 'phone_no')}*',
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
                      '${trans(context, 'mosque')}*',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomTextField(
                      maxLines: 1,
                      controller: _mosqueController,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Text(
                      '${trans(context, 'city')}*',
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
                      '${trans(context, 'street')}*',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomTextField(maxLines: 1, controller: _streetController),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Text(
                      '${trans(context, 'block')}*',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.8),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    CustomTextField(maxLines: 1, controller: _blockController),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Text(
                      '${trans(context, 'governorate')}*',
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
          SizedBox(height: SizeConfig.blockSizeVertical * 4),
          !widget.mosqueCare
              ? widget.mosque != null
                  ? Text(
                      '${trans(context, 'delivery_fee')}: ${appProvider.settings.mosqueDeliveryFee} ${trans(context, 'kd')}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      '${trans(context, 'delivery_fee')}: ${appProvider.settings.cemetryDeliveryFee} ${trans(context, 'kd')}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
              : Container(),
          SizedBox(height: SizeConfig.blockSizeVertical * 2),
          DefaultButton(
            press: () {
              if (widget.mosqueCare && widget.subcategoryId != null) {
                _customDonationCheckout();
              } else if (widget.mosque != null) {
                _mosqueCheckout();
              } else {
                _cemetryCheckout();
              }
            },
            text: !widget.mosqueCare
                ? trans(context, 'checkout')
                : trans(context, 'submit'),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
        ],
      ),
    );
  }

  _navigateToPaymentMethod(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(cart: widget.cart, order: order),
      ),
    );
  }

  _customDonationCheckout() async {
    if (_nameController.value.text.isEmpty ||
        _phoneController.value.text.isEmpty ||
        _cityController.value.text.isEmpty ||
        _streetController.value.text.isEmpty ||
        _govController.value.text.isEmpty) {
      Fluttertoast.showToast(
        msg: trans(context, 'please_fill_all_information'),
      );
    } else {
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
      order.categoryId = widget.categoryId;
      if (widget.subcategoryId != null)
        order.subcategoryId = widget.subcategoryId;
      order.mosque = _mosqueController.value.text;
      order.donorName = _nameController.value.text;
      order.phoneNo = _phoneController.value.text;
      order.deliveryNotes = _notesController.value.text;
      order.userId = authProvider.user.id.toString();
      order.address = address;
      order.city = _cityController.value.text;
      order.coordination = widget.mosque.geometry.location.toString();
      print(widget.mosque.geometry.location.toString());

      await HttpService.makeOrder(context, order);

      await db.saveUserInfo(_nameController.text, _phoneController.text);
    }
  }

  _mosqueCheckout() async {
    if (_nameController.value.text.isEmpty ||
        _phoneController.value.text.isEmpty ||
        _cityController.value.text.isEmpty ||
        _streetController.value.text.isEmpty ||
        _govController.value.text.isEmpty) {
      Fluttertoast.showToast(
        msg: trans(context, 'please_fill_all_information'),
      );
    } else {
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
      if (widget.cart != null) order.categoryId = widget.categoryId;
      order.mosque = _mosqueController.value.text;
      order.donorName = _nameController.value.text;
      order.phoneNo = _phoneController.value.text;
      order.deliveryNotes = _notesController.value.text;
      order.totalPrice = widget.cart.total +
          appProvider.settings.serviceFee +
          appProvider.settings.mosqueDeliveryFee;
      order.serviceFee = appProvider.settings.serviceFee;
      order.deliveryFee = appProvider.settings.mosqueDeliveryFee;
      order.totalProducts = widget.cart.count;
      if (widget.cart != null) order.cartId = widget.cart.id;
      order.userId = authProvider.user.id.toString();
      order.address = address;
      order.city = _cityController.value.text;
      order.coordination = widget.mosque.geometry.location.toString();
      print(widget.mosque.geometry.location.toString());

      await db.saveUserInfo(_nameController.text, _phoneController.text);

      _navigateToPaymentMethod(order);
    }
  }

  _cemetryCheckout() async {
    if (_selectedCemetry == null ||
        _nameController.value.text.isEmpty ||
        _phoneController.value.text.isEmpty) {
      Fluttertoast.showToast(
          msg: trans(context, 'please_fill_all_information'));
    } else {
      Order order = new Order();
      order.categoryId = widget.categoryId;
      order.cemetry = _selectedCemetry;
      order.donorName = _nameController.value.text;
      order.phoneNo = _phoneController.value.text;
      order.deliveryNotes = _notesController.value.text;
      order.totalPrice = widget.cart.total +
          appProvider.settings.serviceFee +
          appProvider.settings.cemetryDeliveryFee;
      order.serviceFee = appProvider.settings.serviceFee;
      order.deliveryFee = appProvider.settings.cemetryDeliveryFee;
      order.totalProducts = widget.cart.count;
      order.cartId = widget.cart.id;
      order.userId = authProvider.user.id.toString();

      await db.saveUserInfo(_nameController.text, _phoneController.text);
      _navigateToPaymentMethod(order);
    }
  }

  _foodCheckout() async {
    if (_selectedOrganisation == null ||
        _nameController.value.text.isEmpty ||
        _phoneController.value.text.isEmpty) {
      Fluttertoast.showToast(
        msg: trans(context, 'please_fill_all_information'),
      );
    } else {
      Order order = new Order();
      order.categoryId = widget.cart.id;
      order.by = _selectedOrganisation;
      order.donorName = _nameController.value.text;
      order.phoneNo = _phoneController.value.text;
      order.deliveryNotes = _notesController.value.text;
      order.totalPrice =
          widget.cart.total + appProvider.settings.serviceFee + 0;
      order.serviceFee = appProvider.settings.serviceFee;
      order.deliveryFee = 0;
      order.totalProducts = widget.cart.count;
      order.cartId = widget.cart.id;
      order.userId = authProvider.user.id.toString();

      await db.saveUserInfo(_nameController.text, _phoneController.text);

      _navigateToPaymentMethod(order);
    }
  }

  _consolationCheckout() async {
    if (_nameController.value.text.isEmpty ||
        _phoneController.value.text.isEmpty ||
        _cityController.value.text.isEmpty ||
        _streetController.value.text.isEmpty ||
        _govController.value.text.isEmpty) {
      Fluttertoast.showToast(
        msg: trans(context, 'please_fill_all_information'),
      );
    } else {
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
      if (widget.cart != null)
        order.categoryId = widget.cart.id;
      else
        order.categoryId = widget.categoryId;
      order.donorName = _nameController.value.text;
      order.phoneNo = _phoneController.value.text;
      order.deliveryNotes = _notesController.value.text;
      order.totalPrice = widget.cart.total +
          appProvider.settings.serviceFee +
          appProvider.settings.consolationDeliveryFee;
      order.serviceFee = appProvider.settings.serviceFee;
      order.deliveryFee = appProvider.settings.consolationDeliveryFee;
      order.totalProducts = widget.cart.count;
      order.cartId = widget.cart.id;
      order.userId = authProvider.user.id.toString();
      order.city = _cityController.value.text;
      order.address = address;
      if (_mosqueController.text.isNotEmpty)
        order.mosque = _mosqueController.text;
      order.coordination = widget.mosque.geometry.location.toString();

      _navigateToPaymentMethod(order);
    }
  }

  _getOrganisations() async {
    await HttpService.getOrganisations().then((o) {
      setState(() {
        organisations = o;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.cart != null ? Text(widget.cart.name) : Text(''),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: widget.cart != null
            ? widget.cart.templateId == 1
                ? _buildAddressAndGeolocation()
                : widget.cart.templateId == 2 || widget.cart.templateId == 5
                    ? _buildInformationFields()
                    : widget.cart.templateId == 4
                        ? _buildAddressAndGeolocation()
                        : Container()
            : _buildInformationFields(),
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
      mosque: result.name,
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
}
