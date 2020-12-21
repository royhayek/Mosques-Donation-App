import 'package:flutter/material.dart';
import 'package:mosques_donation_app/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 7.4,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        color: Theme.of(context).primaryColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
