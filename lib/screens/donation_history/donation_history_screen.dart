import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/screens/donation_history/widgets/donation_list_item.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class DonationHistoryScreen extends StatefulWidget {
  static String routeName = "/donation_history_screen";

  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TabController _tabController;
  List<Product> _pending = [];
  List<Product> _completed = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

    getUserOrderHistory();
  }

  getUserOrderHistory() async {
    await HttpService.getUserOrders(_auth.currentUser.uid).then((history) {
      history.forEach((h) {
        print(h);
        if (h.status == 1) _pending.add(h);
        if (h.status == 2) _completed.add(h);
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'donation_history')),
        centerTitle: true,
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.1),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Tab>[
            Tab(text: trans(context, 'pending')),
            Tab(text: trans(context, 'completed')),
          ],
          controller: _tabController,
          indicator: BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Colors.blueAccent,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Tab>[
          Tab(text: trans(context, 'pending')),
          Tab(text: trans(context, 'completed')),
        ].map(
          (Tab tab) {
            return tab.text == trans(context, 'pending')
                ? !_isLoading
                    ? ListView.builder(
                        itemCount: _pending.length,
                        itemBuilder: (context, index) => DonationListItem(
                          product: _pending[index],
                        ),
                      )
                    : Center(child: CircularProgressIndicator())
                : !_isLoading
                    ? ListView.builder(
                        itemCount: _completed.length,
                        itemBuilder: (context, index) => DonationListItem(
                          product: _completed[index],
                        ),
                      )
                    : Center(child: CircularProgressIndicator());
          },
        ).toList(),
      ),
    );
  }
}
