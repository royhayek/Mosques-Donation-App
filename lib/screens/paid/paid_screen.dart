import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/tab_screens.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/widgets/custom_card_button.dart';

class PaidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.checkmark_circle_48_filled,
              color: Theme.of(context).primaryColor,
              size: SizeConfig.blockSizeHorizontal * 25,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            Text(
              'The payment was successful \n Thank you for donating!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 5,
                height: 1.5,
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 6,
              ),
              child: CustomCardButton(
                text: 'Return Home',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, TabsScreen.routeName, (route) => false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
