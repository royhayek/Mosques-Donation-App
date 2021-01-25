import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mosques_donation_app/screens/account/account_screen.dart';
import 'package:mosques_donation_app/screens/categories/categories_screen.dart';
import 'package:mosques_donation_app/screens/products_list/products_list_screen.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class TabsScreen extends StatefulWidget {
  static String routeName = "/tabs_screen";

  static void setPageIndex(BuildContext context, int index) {
    _TabsScreenState state =
        context.findAncestorStateOfType<_TabsScreenState>();
    state._selectPage(index);
  }

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  static final kInitialPosition = LatLng(29.378586, 47.990341);

  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: _selectPage,
      elevation: 0,
      iconSize: 32,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      currentIndex: _selectedPageIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(fontSize: 14),
      unselectedLabelStyle: TextStyle(fontSize: 14),
      unselectedItemColor: Colors.grey.shade400,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(FluentIcons.grid_24_regular),
          activeIcon: Icon(FluentIcons.grid_28_filled),
          label: trans(context, 'categories'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FluentIcons.building_skyscraper_24_regular),
          activeIcon: Icon(FluentIcons.building_skyscraper_24_filled),
          label: trans(context, 'mosques'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FluentIcons.person_28_regular),
          activeIcon: Icon(FluentIcons.person_28_filled),
          label: trans(context, 'account'),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: <Widget>[
        _pages[_selectedPageIndex]['page'],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      {'page': CategoriesScreen()},
      {
        'page': PlacePicker(
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
              (_, selectedPlace, state, isSearchBarFocused) =>
                  selectedPlaceWidget(selectedPlace, state, isSearchBarFocused),
        ),
      },
      {'page': AccountScreen()},
    ];
    return Scaffold(
      body: _body(context),
      bottomNavigationBar: _bottomNavigationBar(context),
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
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
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
                                builder: (context) => ProductsListScreen(
                                  placeId: selectedPlace.placeId,
                                  photos: selectedPlace.photos,
                                  categoryId: 1,
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
