import 'package:flutter/material.dart';

import '../size_config.dart';

class AccountText extends StatelessWidget {
  final String question, action;
  final Function onPressed;

  AccountText({
    Key key,
    this.question,
    this.action,
    this.onPressed,
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
          onTap: onPressed,
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
