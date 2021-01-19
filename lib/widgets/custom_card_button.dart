import 'package:flutter/material.dart';

import '../size_config.dart';

class CustomCardButton extends StatelessWidget {
  final double height;
  final String text;
  final Function onPressed;

  const CustomCardButton({Key key, this.text, this.onPressed, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 4.5,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
