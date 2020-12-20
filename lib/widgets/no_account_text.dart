import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/otp/otp_screen.dart';

import '../size_config.dart';

class AccountText extends StatelessWidget {
  final String question, action;

  AccountText({
    Key key,
    this.question,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 4,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, OTPScreen.routeName);
          },
          child: Text(
            action,
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
