import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/screens/donation_history/widgets/donation_list_item.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:provider/provider.dart';

class DonationHistoryScreen extends StatefulWidget {
  static String routeName = "/donation_history_screen";

  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen>
    with SingleTickerProviderStateMixin {
  AuthProvider authProvider;
  TabController _tabController;
  List<Product> _pending = [];
  List<Product> _completed = [];
  num totalAmount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    getUserOrderHistory();
  }

  getUserOrderHistory() async {
    await HttpService.getUserOrders(authProvider.user.id).then((history) {
      history.forEach((h) {
        print(h);
        if (h.status == 1) _pending.add(h);
        if (h.status == 2) {
          _completed.add(h);
          totalAmount += h.productPrice;
        }
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical * 10),
          child: Column(
            children: [
              Text(
                '${trans(context, 'total_donated_amount')}: $totalAmount ${trans(context, 'kd')}',
              ),
              TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.white,
                labelStyle:
                    TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.1),
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
            ],
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
