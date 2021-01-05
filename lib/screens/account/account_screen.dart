import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/account/widgets/account_list_item.dart';
import 'package:mosques_donation_app/screens/donation_history/donation_history_screen.dart';
import 'package:mosques_donation_app/screens/languages/languages_screen.dart';
import 'package:mosques_donation_app/screens/suggestion/suggestion_report_screen.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans(context, 'settings'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 7),
            ),
            ListView(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 10),
              shrinkWrap: true,
              children: [
                AccountListItem(
                  title: trans(context, 'donation_history'),
                  icon: FluentIcons.history_24_regular,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    DonationHistoryScreen.routeName,
                  ),
                ),
                AccountListItem(
                  title: trans(context, 'language'),
                  icon: FluentIcons.earth_24_regular,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguagesScreen(nextEnabled: false),
                    ),
                  ),
                ),
                AccountListItem(
                  title: trans(context, 'suggest_or_complain'),
                  icon: FluentIcons.signature_24_regular,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    SuggestionReportScreen.routeName,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
