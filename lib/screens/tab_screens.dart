import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/account_screen.dart';
import 'package:mosques_donation_app/screens/categories/categories_screen.dart';
import 'package:mosques_donation_app/screens/mosques/mosques_screen.dart';
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
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
      {'page': MosquesScreen()},
      {'page': AccountScreen()},
    ];
    return Scaffold(
      body: _body(context),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }
}
