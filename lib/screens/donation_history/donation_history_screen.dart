import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/donation_history/widgets/donation_list_item.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class DonationHistoryScreen extends StatefulWidget {
  static String routeName = "/donation_history_screen";

  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
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
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.1),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Tab>[
            Tab(text: trans(context, 'pending')),
            Tab(text: trans(context, 'complete')),
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
          Tab(text: trans(context, 'complete')),
        ].map((Tab tab) {
          return tab.text == 'Pending'
              ? ListView(
                  children: [
                    DonationListItem(),
                    DonationListItem(),
                  ],
                )
              : ListView(
                  children: [
                    DonationListItem(),
                  ],
                );
        }).toList(),
      ),
    );
  }
}
